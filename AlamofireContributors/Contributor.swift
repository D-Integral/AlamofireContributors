//
//  Contributor.swift
//  AlamofireContributors
//
//  Created by administrator on 6/4/18.
//  Copyright © 2018 Dmytro Skorokhod. All rights reserved.
//

import Foundation

struct Contributor: Codable {
    let id: Int
    let avatar_url: URL
    let login: String
    let contributions: Int
}
