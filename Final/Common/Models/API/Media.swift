//
//  Media.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/22/21.
//

import Foundation

struct Media: Codable, Equatable {
    let id: Int64
    let type: MediaType?
    let mediaUrl: URL
    let videoInfo: VideoInfo?
}
