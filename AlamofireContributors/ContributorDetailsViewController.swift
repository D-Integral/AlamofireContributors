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
    
    var contributor: Contributor? {
        didSet {
            if let theContributor = contributor {
                title = theContributor.login
                
                requestUpdate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let theURL = contributor?.avatar_url {
            ImageManager.shared.cancel(forURL: theURL)
        }
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: Private methods
    
    private func requestUpdate() {
        if let theURL = contributor?.avatar_url {
            ImageManager.shared.requestImage(URL: theURL) { [weak self]
                data, _ in
                guard let this = self else { return }
                
                DispatchQueue.main.async {
                    this.avatarImageData = data as Data
                    this.updateIfLoaded()
                }
            }
        }
    }
    
    private func update() {
        if let data = avatarImageData, let image = UIImage(data: data) {
            avatarImageView.image = image
        }
        
        if let theNumberOfContributions = contributor?.contributions {
            numberOfContributionsLabel.text = String(theNumberOfContributions)
        }
    }
    
    private func updateIfLoaded() {
        if isViewLoaded {
            update()
        }
    }
    
}
