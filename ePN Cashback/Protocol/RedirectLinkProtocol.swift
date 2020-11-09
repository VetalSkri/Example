//
//  RedirectLinkProtocol.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 31/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol RedirectLinkProtocol {
    
    func checkCorrectLink(_ resultOfLinks: LinkGenerateDataResponse, completion: @escaping ((URL)->()))
    func checkLinkForMobileApp(_ result: OfferLinkInfo, completion: @escaping ((URL)->()))
    
}

extension RedirectLinkProtocol {
    
    func checkCorrectLink(_ resultOfLinks: LinkGenerateDataResponse, completion: @escaping ((URL)->())) {
        OperationQueue.main.addOperation {
            let urlLink = URL(string: resultOfLinks.attributes.cashbackDefault)!
            guard let schema = resultOfLinks.attributes.cashbackPackage?.schema, !schema.isEmpty else {
                completion(urlLink)
                return
            }
            if UIApplication.shared.canOpenURL(URL(string: "\(schema)://")!) {
                guard let mobileLink = resultOfLinks.attributes.cashbackPackage?.link else {
                    completion(urlLink)
                    return
                }
                let urlMobile = URL(string: mobileLink)!
                self.getData(from: urlMobile) { data, response, error in
                    guard let data = data, error == nil else {
                        completion(urlLink)
                        return
                    }
                    OperationQueue.main.addOperation {
                        do {
                            let jsonlink = try JSONDecoder().decode(RedirectLinkResponse.self, from: data)
                            let url_app = URL(string: "\(jsonlink.redirect_url)")!
                            completion(url_app)
                            return
                        } catch let error {
                            print("Error of parsing \(error)")
                            completion(urlLink)
                        }
                    }
                }
            } else {
                completion(urlLink)
            }
        }
    }
    
    func checkLinkForMobileApp(_ result: OfferLinkInfo, completion: @escaping ((URL)->())) {
        OperationQueue.main.addOperation {
            let urlLink = URL(string: result.redirectUrl)!
            guard let schema = result.cashbackPackage?.schema, !schema.isEmpty else {
                completion(urlLink)
                return
            }
            if UIApplication.shared.canOpenURL(URL(string: "\(schema)://")!) {
                guard let mobileLink = result.cashbackPackage?.link else {
                    completion(urlLink)
                    return
                }
                let urlMobile = URL(string: mobileLink)!
                self.getData(from: urlMobile) { data, response, error in
                    guard let data = data, error == nil else {
                        completion(urlLink)
                        return
                    }
                    OperationQueue.main.addOperation {
                        do {
                            let jsonlink = try JSONDecoder().decode(RedirectLinkResponse.self, from: data)
                            let url_app = URL(string: "\(jsonlink.redirect_url)")!
                            completion(url_app)
                            return
                        } catch let error {
                            print("Error of parsing \(error)")
                            completion(urlLink)
                        }
                    }
                }
            } else {
                completion(urlLink)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
