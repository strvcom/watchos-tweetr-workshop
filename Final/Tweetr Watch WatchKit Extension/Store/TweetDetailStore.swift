//
//  TweetDetailStore.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/19/21.
//

import Foundation

final class TweetDetailStore: ObservableObject {
    @Injected var twitterService: TwitterServicing
    @MainActor
    @Published var state: State = .inProgress

    @MainActor
    func fetchTweetDetail(id: Int64) async {
        do {
            let tweet = try await twitterService.getTweet(tweetId: id)
            state = .success(tweet)
        } catch {
            state = .failure
        }
    }

    @MainActor
    func toggleLike(tweet: Tweet) async {
        do {
            if tweet.favorited {
                try await twitterService.dislikeTweet(tweetId: tweet.id)
            } else {
                try await twitterService.likeTweet(tweetId: tweet.id)
            }

            let updatedTweet = toggleFavorite(for: tweet)

            state = .success(updatedTweet)
        } catch {
            print("There was an error liking tweet")
        }
    }

    @MainActor
    func toggleRetweet(tweet: Tweet) async {
        do {
            if tweet.retweeted {
                try await twitterService.unretweet(tweetId: tweet.id)
            } else {
                try await twitterService.retweet(tweetId: tweet.id)
            }

            let updatedTweet = toggleRetweet(for: tweet)

            state = .success(updatedTweet)
        } catch {
            print("There was an error retweeting")
        }
    }

    enum State {
        case inProgress
        case success(Tweet)
        case failure
    }
}

// MARK: - Private Helpers
private extension TweetDetailStore {
    func toggleRetweet(for tweet: Tweet) -> Tweet {
        let counter = tweet.retweeted ? -1 : 1
        var updatedTweet = tweet

        updatedTweet.retweeted.toggle()
        updatedTweet.retweetCount += counter

        return updatedTweet
    }

    func toggleFavorite(for tweet: Tweet) -> Tweet {
        let counter = tweet.favorited ? -1 : 1
        var updatedTweet = tweet

        updatedTweet.favorited.toggle()
        updatedTweet.favoriteCount += counter

        return updatedTweet
    }
}
