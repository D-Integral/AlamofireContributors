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
    
    func requestImage(forCell cell: ContributorCell, index: Int) {
        if let URL = cell.URL {
            let dispatchWorkItemGlobal = DispatchWorkItem { [weak self] in
                guard let this = self else { return }
                
                if let data = try? Data(contentsOf: URL) {
                    Cache.shared.setData(data, forKey: URL.absoluteString)
                    
                    if cell.index == index {
                        let dispatchWorkItemMain = DispatchWorkItem {
                            cell.contributorAvatarImageView.image = UIImage(data: data as Data)
                            cell.layoutSubviews()
                            this.removeFromMainQueue(forURL:URL)
                        }
                        
                        this.executeOnMainQueue(dispatchWorkItemMain, URL: URL)
                        this.removeFromGlobalQueue(forURL: URL)
                    }
                }
            }
            
            executeOnGlobalQueue(dispatchWorkItemGlobal, URL: URL)
        }
    }
    
    private func remove(from items: inout [String: DispatchWorkItem], URL: URL) {
        let item = items[URL.absoluteString]
        
        if let isCancelled = item?.isCancelled, isCancelled == false {
            item?.cancel()
        }
        
        items[URL.absoluteString] = nil
    }
}
