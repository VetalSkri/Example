//
//  BaseApiRouter.swift
//  ePN Cashback
//
//  Created by Александр Кузьмин on 05/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation
import Alamofire

protocol BaseApiRouter: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders { get }
    var queryType: Query { get }
    var timeout: TimeInterval { get }
    var baseUrl: URL? { get }
    
}

extension BaseApiRouter {
    func defaultHeader() -> HTTPHeaders {
        var header = HTTPHeaders()
        if let token = Session.shared.access_token {
            header["X-ACCESS-TOKEN"] = token
        }
        header["Content-Type"] = "application/json"
        header["X-API-VERSION"] = Constants.ProductionServer.apiVersion
        header["ACCEPT-LANGUAGE"] = Util.languageOfContent()
        return header
    }
}

extension BaseApiRouter {
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {

        let url = (baseUrl != nil) ? baseUrl! : try Constants.ProductionServer.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.timeoutInterval = timeout
        // Parameters
        if let parameters = parameters {
            switch queryType {
            case .json:
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                } catch {
                    throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
                }
            case .path:
                let urlComponent = NSURLComponents(string: url.appendingPathComponent(path).absoluteString)!
                urlComponent.queryItems = parameters.map{ (key, value) in
                    URLQueryItem(name: key, value: String(describing: value))
                }
                urlComponent.percentEncodedQuery = urlComponent.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
                urlRequest.url = urlComponent.url!
                urlRequest.httpBody = nil
            }
        }
        
        return urlRequest
    }
}
