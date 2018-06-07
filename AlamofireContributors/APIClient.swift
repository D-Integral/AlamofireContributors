//
//  APIClient.swift
//  AlamofireContributors
//
//  Created by Dmytro Skorokhod on 6/4/18.
//  Copyright © 2018 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class APIClient: NSObject {
    static let shared = APIClient()
    
    let contributorsPath: String = "https://api.github.com/repos/Alamofire/Alamofire/contributors"

    func requestContributors(_ completionHandler: @escaping ([Contributor]) -> Void) {
        contributorsDataTask(completionHandler)?.resume()
    }
    
    func contributorsDataTask(_ completionHandler: @escaping ([Contributor]) -> Void) -> URLSessionDataTask? {
        if let url = URL(string: contributorsPath) {
            return URLSession.shared.dataTask(with:url, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else { return }
                
                let decoder = JSONDecoder()
                if let contributors = try? decoder.decode([Contributor].self, from: data) {
                    completionHandler(contributors)
                }
            })
        }
        
        return nil
    }
}
