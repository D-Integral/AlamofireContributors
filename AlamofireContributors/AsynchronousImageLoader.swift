//
//  AsynchronousImageLoader.swift
//  AlamofireContributors
//
//  Created by Dmytro Skorokhod on 6/7/18.
//  Copyright © 2018 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class AsynchronousImageLoader: NSObject {
    static let shared = AsynchronousImageLoader()
    
    private var items = [String: DispatchWorkItem]()
    
    func cancel(forURL URL: URL) {
        let item = items[URL.absoluteString]
        
        if let isCancelled = item?.isCancelled, isCancelled == false {
            item?.cancel()
        }
        
        items[URL.absoluteString] = nil
    }
    
    func requestImage(URL: URL, completionHandler: @escaping (Data, URL) -> Void) {
        let dispatchWorkItem = DispatchWorkItem { [weak self] in
            guard let this = self else { return }
            
            if let data = try? Data(contentsOf: URL) {
                Cache.shared.setData(data, forKey: URL.absoluteString)
                this.items[URL.absoluteString] = nil
                completionHandler(data, URL)
            }
        }
        
        execute(dispatchWorkItem, URL: URL)
    }
    
    // MARK: Private methods
    
    private func execute(_ item: DispatchWorkItem, URL: URL) {
        items[URL.absoluteString] = item
        DispatchQueue.global(qos: .userInitiated).async(execute: item)
    }
}
