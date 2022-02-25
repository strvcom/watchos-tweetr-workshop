//
//  ExpandedTweetView.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 2/25/22.
//

import class AVFoundation.AVPlayer
import AVKit
import SwiftUI

struct ExpandedTweetView: View {
    let tweet: Tweet
    let onLike: () -> Void
    let onRetweet: () -> Void
    let width: CGFloat

    @ViewBuilder
    func getDestinationView(for tweet: Tweet) -> some View {
        VStack {
            if tweet.isVideoAttached, let videoUrl = tweet.videoLowQuality {
                VideoPlayer(player: AVPlayer(url: videoUrl))
            } else {
                AsyncImage(url: tweet.mediaUrl)
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                HStack {
                    AsyncImage(url: tweet.user.profileImageUrl)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())

                    Text(tweet.user.name)
                        .font(.headline)
                        .lineLimit(2)

                    Spacer()
                }

                Text(tweet.fullText ?? "")

                NavigationLink {
                    getDestinationView(for: tweet)
                } label: {
                    TweetMediaView(
                        mediaUrl: tweet.mediaUrl,
                        isVideoPreview: tweet.isVideoAttached,
                        width: width
                    )
                }
                .buttonStyle(.plain)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                HStack {
                    Button(action: onLike) {
                        Label("\(tweet.favoriteCount)", systemImage: "heart")
                    }
                    .foregroundColor(tweet.favorited ? .red : .primary)

                    Button(action: onRetweet) {
                        Label("\(tweet.retweetCount)", systemImage: "repeat")
                    }
                    .foregroundColor(tweet.retweeted ? .blue : .primary)
                }
            }
        }
    }
}
