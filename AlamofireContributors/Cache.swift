//
//  Cache.swift
//  AlamofireContributors
//
//  Created by Dmytro Skorokhod on 6/6/18.
//  Copyright © 2018 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class Cache: NSObject {
    static let shared = Cache()
    
    let cache = NSCache<NSString, DiscardableCacheItem>()
    
    func setData(_ data: Data, forKey key: String) {
        let cacheItem = DiscardableCacheItem(data: data as NSData)
        cache.setObject(cacheItem, forKey: key as NSString)
    }
    
    func dataForKey(_ key: String) -> Data? {
        let cacheItem = cache.object(forKey: key as NSString)
        return cacheItem?.data as Data?
    }
}
