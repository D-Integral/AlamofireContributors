//
//  ContributorsTableViewController.swift
//  AlamofireContributors
//
//  Created by Dmytro Skorokhod on 6/4/18.
//  Copyright © 2018 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class ContributorsTableViewController: UITableViewController {
    
    var contributors: [Contributor] = []
    let cache = NSCache<NSString, NSData>()

    override func viewDidLoad() {
        super.viewDidLoad()

        APIClient.shared.requestContributors() {[weak self] receivedContributors in
            guard let this = self else { return }
            
            this.contributors = receivedContributors
            DispatchQueue.main.async {
                this.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contributors.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContributorCell", for: indexPath)
        
        if let contributorCell = cell as? ContributorCell {
            let contributor = contributors[indexPath.row]
            
            contributorCell.contributorNameLabel.text = contributor.login
            let index = indexPath.row
            contributorCell.index = index
            
            let cachdedData: Data
            let key = contributor.avatar_url.absoluteString
            
            if let cachedVersion = cache.object(forKey: key as NSString) {
                cachdedData = cachedVersion as Data
                contributorCell.contributorAvatarImageView.image = UIImage(data: cachdedData as Data)
                contributorCell.contributorAvatarImageView.contentMode = .scaleAspectFit
                contributorCell.layoutSubviews()
            } else {
                let dispatchWorkItemGlobal = DispatchWorkItem { [weak self] in
                    guard let this = self else { return }
                    
                    if let data = NSData(contentsOf: contributor.avatar_url) {
                        this.cache.setObject(data, forKey: key as NSString)
                        
                        if contributorCell.index == index {
                            let dispatchWorkItemMain = DispatchWorkItem {
                                contributorCell.contributorAvatarImageView.image = UIImage(data: data as Data)
                                cell.layoutSubviews()
                            }
                            
                            contributorCell.asynchronousImageLoadingDispatchWorkItemMain = dispatchWorkItemMain
                            
                            DispatchQueue.main.async(execute: dispatchWorkItemMain)
                        }
                    }
                }
                
                contributorCell.asynchronousImageLoadingDispatchWorkItemGlobal = dispatchWorkItemGlobal
                DispatchQueue.global(qos: .userInitiated).async(execute: dispatchWorkItemGlobal)
            }
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? ContributorDetailsViewController,
            let selectedRow = tableView.indexPathForSelectedRow?.row {
            let cache = NSCache<NSString, NSData>()
            let cachdedData: Data
            let key = "CachedImage" + String(selectedRow)
            
            if let cachedVersion = cache.object(forKey: key as NSString) {
                cachdedData = cachedVersion as Data
                detailsVC.avatarImageView.image = UIImage(data: cachdedData as Data)
            } else {
                let contributor = contributors[selectedRow]
                detailsVC.title = contributor.login
                
                DispatchQueue.global(qos: .userInitiated).async {
                    if let data = NSData(contentsOf: contributor.avatar_url) {
                        cache.setObject(data, forKey: key as NSString)
                        DispatchQueue.main.async {
                            detailsVC.avatarImageView.image = UIImage(data: data as Data)
                            detailsVC.numberOfContributionsLabel.text = String(contributor.contributions)
                        }
                    }
                }
            }
        }
    }

}
