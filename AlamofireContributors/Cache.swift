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
}
