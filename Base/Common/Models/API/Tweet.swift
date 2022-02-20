//
//  Tweet.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/11/21.
//

import Foundation

struct Tweet: Codable, Identifiable, Equatable {
    var id: Int64
    let text: String?
    let fullText: String?
    var retweetCount: Int
    var favoriteCount: Int
    let user: User
    var favorited: Bool
    var retweeted: Bool
    let extendedEntities: ExtendedEntities?

    var isVideoAttached: Bool {
        extendedEntities?.media.first?.type == .video
    }

    var mediaUrl: URL? {
        extendedEntities?.media.first?.mediaUrl
    }

    var videoLowQuality: URL? {
        extendedEntities?
            .media
            .first?
            .videoInfo?
            .variants
            .sorted(by: { ($0.bitrate ?? 0) < ($1.bitrate ?? 0) })
            .first?
            .url
    }
}
