//
//  BaseApiClient.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 08/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics

protocol BaseApiClient {
}

extension BaseApiClient {
    
    @discardableResult
    internal static func performRequest<T: Decodable, U: BaseApiRouter>(router: U, captchaPhraseKey: String? = nil, captcha: String? = nil, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T, Error>)->Void) -> DataRequest {
        var request = try! router.asURLRequest()
        if let phraseKey = captchaPhraseKey, let captcha = captcha, let requestUrl = request.url {
            request.url = requestUrl.appending(Constants.APIParameterKey.captcha, value: captcha).appending(Constants.APIParameterKey.captchaPhraseKey, value: phraseKey)
        }
        return AF.request(request).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(_):
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                    if let errorInfo = errorResponse.errors.first {
                        self.choseActionForErrorResponse(accessToken: Session.shared.access_token, errorInfo: errorInfo, router: router,captcha: captcha, captchaPhraseKey: captchaPhraseKey, decoder: decoder, completion: completion)
                        return
                    }
                } catch {
                    Logger.execParsing(e: error, domain: String(describing: ErrorResponse.self))
                }
                do {
                    let result = try JSONDecoder().decode(T.self, from: response.data!)
                    completion(.success(result))
                } catch {
                    print("MYLOG: response parse error!\n \(error.localizedDescription)")
                    Logger.execParsing(e: error, domain: String(describing: T.self))
                    completion(.failure(error))
                }
                break
            case .failure(let error):
                let crashlyticsError = error as NSError
                Crashlytics.sharedInstance().recordError(crashlyticsError)
                completion(.failure(error))
                break
            }
        })
    }
    
    private static func choseActionForErrorResponse<T:Decodable, U:BaseApiRouter>(accessToken: String?, errorInfo: ErrorInfo, router: U, captcha: String?, captchaPhraseKey: String?, decoder: JSONDecoder, completion:@escaping (Result<T, Error>)->Void) {
        let code = errorInfo.error
        switch code {
        case Constants.ResponseCode.captcha:
            print("NetLog: Need to enter captcha")
            if let captcha = errorInfo.captcha {
                CaptchaHandler.show(captcha: captcha, enterCaptcha: { (captchaAnswer) in
                    performRequest(router: router, captchaPhraseKey: captcha.captcha_phrase_key, captcha: captchaAnswer, decoder: decoder, completion: completion)
                }) {
                    completion(.failure(NSError(domain: "", code: 429001, userInfo: nil)))
                    return
                }
            }
            break
        case Constants.ResponseCode.invalidSSID:
            print("NetLog: Need to update SSID")
            refreshSSIDAndRetryRequest(router: router, captcha: captcha, captchaPhraseKey: captchaPhraseKey, decoder: decoder, completion: completion)
            break
        case Constants.ResponseCode.invalidRefreshToken:
            DispatchQueue.global(qos: .background).async {
                print("NetLog: Need to update Refresh Token")
                Util.lock.lock()
                print("NetLog: Need to update Refresh Token after lock, oldToken: \(accessToken?.suffix(4) ?? ""), currentTokenInSettings: \(Session.shared.access_token?.suffix(4) ?? "")")
                if accessToken != Session.shared.access_token {
                    print("NetLog: Refresh token alredy updated")
                    performRequest(router: router, captchaPhraseKey: captchaPhraseKey, captcha: captcha, decoder: decoder, completion: completion)
                    Util.lock.unlock()
                    return
                }
                refreshTokenAndRetryRequest(accessToken: accessToken, router: router, captcha: captcha, captchaPhraseKey: captchaPhraseKey, decoder: decoder, completion: completion)
            }
            break
        default:
            completion(.failure(NSError(domain: errorInfo.error_description, code: errorInfo.error, userInfo: nil)))
            break
        }
    }
    
    private static func refreshTokenAndRetryRequest<T:Decodable, U:BaseApiRouter>(accessToken: String?, router: U, captcha: String?, captchaPhraseKey: String?, decoder: JSONDecoder, completion:@escaping (Result<T, Error>)->Void) {
        guard let oauthURL = URL(string: Constants.ProductionServer.oauthURL) else { return }
        AuthApiClient.refreshToken(url: oauthURL) { (result) in
            switch result {
            case .success(let response):
                print("NetLog: Success get new refresh token: \(response.data.attributes.refresh_token.suffix(4))")
                print("NetLog: Success get new access token: \(response.data.attributes.access_token.suffix(4))")
                Session.shared.access_token = response.data.attributes.access_token
                Session.shared.refresh_token = response.data.attributes.refresh_token
                performRequest(router: router, captchaPhraseKey: captchaPhraseKey, captcha: captcha, decoder: decoder, completion: completion)
                break
            case .failure(let error):
                if (error as NSError).code == 400013 {  //Wrong refresh token
                    OperationQueue.main.addOperation {
                        print("NetLog: Failure get new refresh token, 400013 code (wrong refresh token), exit from account")
                        PushApiClient.deleteToken { (_) in }
                        Util.deleteCurrentSessionData()
                        UIApplication.shared.open(URL(string: Util.signInURL)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    }
                } else {
                    print("NetLog: Failure get new refresh token")
                    completion(.failure(error))
                }
                break
            }
            print("NetLog: Unlock")
            Util.lock.unlock()
        }
    }
    
    private static func refreshSSIDAndRetryRequest<T:Decodable, U:BaseApiRouter>(router: U, captcha: String?, captchaPhraseKey: String?, decoder: JSONDecoder, completion:@escaping (Result<T, Error>)->Void) {
        AuthApiClient.ssid(url: router.baseUrl) {(result) in
            switch result {
            case .success(let response):
                print("NetLog: Success get new ssid: \(response.data.attributes.ssid_token)")
                Session.shared.ssid = response.data.attributes.ssid_token
                performRequest(router: router, captchaPhraseKey: captchaPhraseKey, captcha: captcha, decoder: decoder, completion: completion)
                break
            case .failure(let error):
                print("NetLog: Failure get new ssid token")
                completion(.failure(error))
                break
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
