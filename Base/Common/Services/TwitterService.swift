//
//  TwitterService.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/11/21.
//

import Foundation

protocol TwitterServicing {
    func getTimeline() async throws -> [Tweet]
    func getTweet(tweetId: Int64) async throws -> Tweet
    func getCurrentUser() async throws -> User

    @discardableResult
    func likeTweet(tweetId: Int64) async throws -> Tweet

    @discardableResult
    func dislikeTweet(tweetId: Int64) async throws -> Tweet

    @discardableResult
    func retweet(tweetId: Int64) async throws -> Tweet

    @discardableResult
    func unretweet(tweetId: Int64) async throws -> Tweet
}

struct TwitterService: TwitterServicing {
    @Injected var apiManager: APIManaging

    func getTimeline() async throws -> [Tweet] {
        let tweets: [Tweet] = try await apiManager.request(TwitterRouter.timeline)

        return tweets
    }

    func getTweet(tweetId: Int64) async throws -> Tweet {
        let tweet: Tweet = try await apiManager.request(TwitterRouter.tweetDetail(tweetId))

        return tweet
    }

    func getCurrentUser() async throws -> User {
        let user: User = try await apiManager.request(TwitterRouter.profile)

        return user
    }

    func likeTweet(tweetId: Int64) async throws -> Tweet {
        let tweet: Tweet = try await apiManager.request(TwitterRouter.like(tweetId))

        return tweet
    }

    func dislikeTweet(tweetId: Int64) async throws -> Tweet {
        let tweet: Tweet = try await apiManager.request(TwitterRouter.unlike(tweetId))

        return tweet
    }

    func retweet(tweetId: Int64) async throws -> Tweet {
        let tweet: Tweet = try await apiManager.request(TwitterRouter.retweet(tweetId))

        return tweet
    }

    func unretweet(tweetId: Int64) async throws -> Tweet {
        let tweet: Tweet = try await apiManager.request(TwitterRouter.unretweet(tweetId))

        return tweet
    }
}
