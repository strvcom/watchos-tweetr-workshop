//
//  TweetDetailView.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/16/21.
//

import class AVFoundation.AVPlayer
import AVKit
import SwiftUI

struct TweetDetailView: View {
    @StateObject var store = TweetDetailStore()
    let tweetId: Int64

    var body: some View {
        VStack {
            switch store.state {
            case .inProgress:
                ProgressView()
            case let .success(tweet):
                GeometryReader { reader in
                    ExpandedTweetView(
                        tweet: tweet,
                        onLike: likeTweet,
                        onRetweet: retweet,
                        width: reader.size.width
                    )
                }
            case .failure:
                FailureView(text: "Failed to load the tweet") {
                    fetchTweetDetail(for: tweetId)
                }
            }
        }
        .onAppear {
            fetchTweetDetail(for: tweetId)
        }
    }
}

private extension TweetDetailView {
    func likeTweet() {
        guard case let .success(tweet) = store.state else {
            return
        }

        Task {
            await store.toggleLike(tweet: tweet)
        }
    }

    func retweet() {
        guard case let .success(tweet) = store.state else {
            return
        }

        Task {
            await store.toggleRetweet(tweet: tweet)
        }
    }

    func fetchTweetDetail(for tweetId: Int64) {
        Task {
            await store.fetchTweetDetail(id: tweetId)
        }
    }
}
