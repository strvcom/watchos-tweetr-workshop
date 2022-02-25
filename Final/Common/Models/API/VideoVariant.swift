//
//  VideoVariant.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 1/16/22.
//

import Foundation

struct VideoVariant: Codable, Equatable {
    let bitrate: Int?
    let url: URL
}
