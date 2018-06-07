//
//  Cache.swift
//  AlamofireContributors
//
//  Created by administrator on 6/6/18.
//  Copyright © 2018 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class Cache: NSObject {
    static let shared = Cache()
    
    let cache = NSCache<NSString, NSData>()
    
    func setData(_ data: Data, forKey key: String) {
        cache.setObject(data as NSData, forKey: key as NSString)
    }
    
    func dataForKey(_ key: String) -> Data? {
        return cache.object(forKey: key as NSString) as Data?
    }
}
