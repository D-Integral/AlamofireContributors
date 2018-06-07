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
    
    private var itemsOnMainQueue = [String: DispatchWorkItem]()
    private var itemsOnGlobalQueues = [String: DispatchWorkItem]()
    
    func cancel(forURL URL: URL) {
        removeFromGlobalQueue(forURL: URL)
        removeFromMainQueue(forURL: URL)
    }

    func executeOnMainQueue(_ item: DispatchWorkItem, URL: URL) {
        itemsOnMainQueue[URL.absoluteString] = item
        DispatchQueue.main.async(execute: item)
    }
    
    func executeOnGlobalQueue(_ item: DispatchWorkItem, URL: URL) {
        itemsOnGlobalQueues[URL.absoluteString] = item
        DispatchQueue.global(qos: .userInitiated).async(execute: item)
    }
    
    func removeFromMainQueue(forURL URL: URL) {
        remove(from: &itemsOnMainQueue, URL: URL)
    }
    
    func removeFromGlobalQueue(forURL URL: URL) {
        remove(from: &itemsOnGlobalQueues, URL: URL)
    }
    
    private func remove(from items: inout [String: DispatchWorkItem], URL: URL) {
        let item = items[URL.absoluteString]
        
        if let isCancelled = item?.isCancelled, isCancelled == false {
            item?.cancel()
        }
        
        items[URL.absoluteString] = nil
    }
}
