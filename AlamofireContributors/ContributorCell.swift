//
//  ContributorCell.swift
//  AlamofireContributors
//
//  Created by administrator on 6/4/18.
//  Copyright © 2018 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class ContributorCell: UITableViewCell {

    @IBOutlet weak var contributorAvatarImageView: UIImageView!
    @IBOutlet weak var contributorNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        contributorAvatarImageView.image = nil
        contributorNameLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
