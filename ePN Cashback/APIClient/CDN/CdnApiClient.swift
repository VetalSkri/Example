//
//  CdnApiClient.swift
//  Backit
//
//  Created by Александр Кузьмин on 03/12/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics

public class CdnApiClient: BaseApiClient {
    
    static func getTokenAndUrl(type: String, visibility: String, completion:@escaping (Result<CdnGetUploadUrlResponse, Error>)->Void) {
        performRequest(router: CdnApiRouter.getTokenAndUrl(type: type, visibility: visibility), completion: completion)
    }
    
    static func getDownloadUrl(fileId: String, completion:@escaping (Result<CdnGetDownloadUrlResponse, Error>)->Void) {
        performRequest(router: CdnApiRouter.getDownloadUrl(fileId: fileId), completion: completion)
    }
    
    static func uploadFile(data: Data, type: String, name: String, visibility: String = "private", changeProgress:((Double)->())?, completion:@escaping (Result<CdnUploadFileResponse, Error>)->Void) {
        CdnApiClient.getTokenAndUrl(type: type, visibility: visibility) { (result) in
            switch result {
            case .success(let response):
                AF.upload(multipartFormData: { (multiparmFormData) in
                    if let tokenData = response.data.attributes.token.data(using: .utf8) {
                        multiparmFormData.append(tokenData, withName: Constants.APIParameterKey.token)
                    }
                    multiparmFormData.append(data, withName: name, fileName: name, mimeType: nil)
                }, to: response.data.attributes.uploadUrl)
                    .uploadProgress { (progress) in
                        changeProgress?(progress.fractionCompleted)
                }
                .responseJSON { response in
                    switch response.result {
                    case .success(_):
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                            if let errorInfo = errorResponse.errors.first {
                                completion(.failure(NSError(domain: errorInfo.error_description, code: errorInfo.error, userInfo: nil)))
                                return
                            }
                        } catch {
                            Logger.execParsing(e: error, domain: String(describing: ErrorResponse.self))
                        }
                        do {
                            let result = try JSONDecoder().decode(CdnUploadFileResponse.self, from: response.data!)
                            completion(.success(result))
                        } catch {
                            print("MYLOG: response parse error!\n \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                        break
                    case .failure(let error):
                        let crashlyticsError = error as NSError
                        Crashlytics.sharedInstance().recordError(crashlyticsError)
                        completion(.failure(error))
                        break
                    }
                }
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    
    static func downloadFile(fileId: String, key: String,changeProgress:((Double)->())? , completion:@escaping (Result<Bool, Error>)->Void) {
        CdnApiClient.getDownloadUrl(fileId: fileId) { (result) in
            switch result {
            case .success(let response):
                AF.download(response.data.attributes.url).downloadProgress { (progress) in
                    print("MYLOG: send download progress: \(progress.fractionCompleted)")
                    NotificationCenter.default.post(name: NSNotification.Name("downloadStateForSupportFile"), object: nil, userInfo: ["key" : key, "progress" : progress.fractionCompleted])
                    changeProgress?(progress.fractionCompleted)
                }.responseData { response in
                    switch response.result {
                    case .success(let data):
                        LruFileCache.shared.add(file: data, forKey: key)
                        NotificationCenter.default.post(name: NSNotification.Name("downloadStateForSupportFile"), object: nil, userInfo: ["key" : key, "success" : true])
                        completion(.success(true))
                        break
                    case .failure(let error):
                        NotificationCenter.default.post(name: NSNotification.Name("downloadStateForSupportFile"), object: nil, userInfo: ["key" : key, "success" : false])
                        completion(.failure(error))
                        break
                    }
                }
                break
            case .failure(let error):
                NotificationCenter.default.post(name: NSNotification.Name("downloadStateForSupportFile"), object: nil, userInfo: ["key" : key, "success" : false])
                completion(.failure(error))
                break
            }
        }
    }
}
