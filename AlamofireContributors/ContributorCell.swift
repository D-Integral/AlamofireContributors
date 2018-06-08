//
//  ContributorCell.swift
//  AlamofireContributors
//
//  Created by Dmytro Skorokhod on 6/4/18.
//  Copyright © 2018 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class ContributorCell: UITableViewCell {
    
    @IBOutlet weak var contributorAvatarImageView: UIImageView!
    @IBOutlet weak var contributorNameLabel: UILabel!
    var contributor: Contributor? = nil
    
    override func prepareForReuse() {
        if let theContributor = contributor {
            ImageManager.shared.cancel(forURL: theContributor.avatar_url)
            contributor = nil
        }
        
        contributorAvatarImageView.image = nil
        contributorNameLabel.text = nil
    }

    func update(withContributor newContributor: Contributor, newIndex: Int) {
        contributor = newContributor
        contributorNameLabel.text = contributor?.login
        
        if let theURL = contributor?.avatar_url {
            ImageManager.shared.requestImage(URL: theURL) { [weak self]
                data, receivedImageURL in
                guard let this = self else { return }
                if this.contributor?.avatar_url == receivedImageURL {
                    DispatchQueue.main.async {
                        this.contributorAvatarImageView.image = UIImage(data: data as Data)
                        this.layoutSubviews()
                    }
                }
            }
        }
    }
}
