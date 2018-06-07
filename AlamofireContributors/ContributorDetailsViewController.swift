//
//  ViewController.swift
//  AlamofireContributors
//
//  Created by Dmytro Skorokhod on 6/4/18.
//  Copyright © 2018 Dmytro Skorokhod. All rights reserved.
//

import UIKit

class ContributorDetailsViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var numberOfContributionsLabel: UILabel!
    
    var avatarImageData: Data? = nil
    var numberOfContributions: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }
    
    func update(withContributor contributor: Contributor) {
        let key = contributor.avatar_url.absoluteString
        
        if let cachedVersion = Cache.shared.dataForKey(key) {
            avatarImageData = cachedVersion as Data
            numberOfContributions = contributor.contributions
            updateIfLoaded()
        } else {
            requestUpdate(withContributor: contributor)
        }
    }
    
    // MARK: Private methods
    
    private func requestUpdate(withContributor contributor: Contributor) {
        title = contributor.login
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let this = self else { return }
            
            if let data = try? Data(contentsOf: contributor.avatar_url) {
                Cache.shared.setData(data, forKey: contributor.avatar_url.absoluteString)
                
                DispatchQueue.main.async {
                    this.avatarImageData = data as Data
                    this.numberOfContributions = contributor.contributions
                    this.updateIfLoaded()
                }
            }
        }
    }
    
    private func update() {
        if let data = avatarImageData, let image = UIImage(data: data) {
            avatarImageView.image = image
        }
        
        if let theNumberOfContributions = numberOfContributions {
            numberOfContributionsLabel.text = String(theNumberOfContributions)
        }
    }
    
    private func updateIfLoaded() {
        if isViewLoaded {
            update()
        }
    }
    
}
