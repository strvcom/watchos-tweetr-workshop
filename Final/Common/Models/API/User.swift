//
//  User.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/22/21.
//

import Foundation

struct User: Codable, Equatable {
    let id: Int64
    let name: String
    let description: String
    let followersCount: Int
    let profileImageUrl: URL
    let friendsCount: Int
}
