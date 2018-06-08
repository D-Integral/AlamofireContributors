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
            contributorCell.update(withContributor: contributors[indexPath.row],
                                   newIndex: indexPath.row)
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? ContributorDetailsViewController,
            let selectedRow = tableView.indexPathForSelectedRow?.row {
            detailsVC.contributor = contributors[selectedRow]
        }
    }

}
