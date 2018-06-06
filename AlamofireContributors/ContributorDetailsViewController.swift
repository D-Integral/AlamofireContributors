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
    
    var loaded = false
    
    var avatarImageData: Data? = nil
    var numberOfContributions: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loaded = true
        update()
    }
    
    func update() {
        if loaded {
            if let data = avatarImageData, let image = UIImage(data: data) {
                avatarImageView.image = image
            }
            
            if let theNumberOfContributions = numberOfContributions {
                numberOfContributionsLabel.text = String(theNumberOfContributions)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

