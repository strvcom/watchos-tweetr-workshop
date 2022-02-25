//
//  MediaType.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 1/16/22.
//

import Foundation

enum MediaType: String, Codable, Equatable {
    case photo
    case video
    case gif = "animated_gif"
}
