//
//  ContributorsTableViewController.swift
//  AlamofireContributors
//
//  Created by administrator on 6/4/18.
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
            
            let cache = NSCache<NSString, NSData>()
            let cachdedData: Data
            let key = "CachedImage" + String(indexPath.row)
            
            if let cachedVersion = cache.object(forKey: key as NSString) {
                cachdedData = cachedVersion as Data
                contributorCell.contributorAvatarImageView.image = UIImage(data: cachdedData as Data)
                contributorCell.layoutSubviews()
            } else {
                DispatchQueue.global(qos: .userInitiated).async {
                    if let data = NSData(contentsOf: contributor.avatar_url) {
                        cache.setObject(data, forKey: key as NSString)
                        DispatchQueue.main.async {
                            contributorCell.contributorAvatarImageView.image = UIImage(data: data as Data)
                            cell.layoutSubviews()
                        }
                    }
                }
            }
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
