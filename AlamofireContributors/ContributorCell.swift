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
    var asynchronousImageLoadingDispatchWorkItemGlobal: DispatchWorkItem? = nil
    var asynchronousImageLoadingDispatchWorkItemMain: DispatchWorkItem? = nil
    var index: Int? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        asynchronousImageLoadingDispatchWorkItemGlobal?.cancel()
        asynchronousImageLoadingDispatchWorkItemGlobal = nil
        asynchronousImageLoadingDispatchWorkItemMain?.cancel()
        asynchronousImageLoadingDispatchWorkItemMain = nil
        contributorAvatarImageView.image = nil
        contributorNameLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
