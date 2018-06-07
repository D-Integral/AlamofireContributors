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
            
            let cachedData: Data
            let key = contributor.avatar_url.absoluteString
            
            if let cachedVersion = Cache.shared.dataForKey(key) {
                cachedData = cachedVersion as Data
                contributorCell.contributorAvatarImageView.image = UIImage(data: cachedData as Data)
                contributorCell.contributorAvatarImageView.contentMode = .scaleAspectFit
                contributorCell.layoutSubviews()
            } else {
                let dispatchWorkItemGlobal = DispatchWorkItem {
                    if let data = try? Data(contentsOf: contributor.avatar_url) {
                        Cache.shared.setData(data, forKey: key)
                        
                        if contributorCell.index == index {
                            let dispatchWorkItemMain = DispatchWorkItem {
                                contributorCell.contributorAvatarImageView.image = UIImage(data: data as Data)
                                contributorCell.layoutSubviews()
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
            let contributor = contributors[selectedRow]
            let key = contributor.avatar_url.absoluteString
            
            if let cachedVersion = Cache.shared.dataForKey(key) {
                detailsVC.avatarImageData = cachedVersion as Data
                detailsVC.numberOfContributions = contributor.contributions
            } else {
                detailsVC.title = contributor.login
                
                DispatchQueue.global(qos: .userInitiated).async {
                    if let data = try? Data(contentsOf: contributor.avatar_url) {
                        Cache.shared.setData(data, forKey: key)
                        DispatchQueue.main.async {
                            detailsVC.avatarImageData = data as Data
                            detailsVC.numberOfContributions = contributor.contributions
                            detailsVC.update()
                        }
                    }
                }
            }
        }
    }

}
