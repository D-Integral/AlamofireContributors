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
    var index: Int? = nil
    var URL: URL? = nil
    
    override func prepareForReuse() {
        if let theURL = URL {
            AsynchronousImageLoader.shared.cancel(forURL: theURL)
            URL = nil
        }
        
        contributorAvatarImageView.image = nil
        contributorNameLabel.text = nil
    }

    func update(withContributor contributor: Contributor, newIndex: Int) {
        contributorNameLabel.text = contributor.login
        index = newIndex
        URL = contributor.avatar_url
        
        let cachedData: Data
        
        if let cachedVersion = Cache.shared.dataForKey(contributor.avatar_url.absoluteString) {
            cachedData = cachedVersion as Data
            contributorAvatarImageView.image = UIImage(data: cachedData as Data)
            contributorAvatarImageView.contentMode = .scaleAspectFit
            layoutSubviews()
        } else {
            AsynchronousImageLoader.shared.requestImage(URL: contributor.avatar_url, index: newIndex) { [weak self]
                data, receivedImageIndex in
                guard let this = self else { return }
                if this.index == receivedImageIndex {
                    this.contributorAvatarImageView.image = UIImage(data: data as Data)
                    this.layoutSubviews()
                }
            }
        }
    }
}
