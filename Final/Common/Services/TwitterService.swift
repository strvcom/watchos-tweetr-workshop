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
        try await apiManager.request(TwitterRouter.timeline)
    }

    func getTweet(tweetId: Int64) async throws -> Tweet {
        try await apiManager.request(TwitterRouter.tweetDetail(tweetId))
    }

    func getCurrentUser() async throws -> User {
        try await apiManager.request(TwitterRouter.profile)
    }

    func likeTweet(tweetId: Int64) async throws -> Tweet {
        try await apiManager.request(TwitterRouter.like(tweetId))
    }

    func dislikeTweet(tweetId: Int64) async throws -> Tweet {
        try await apiManager.request(TwitterRouter.unlike(tweetId))
    }

    func retweet(tweetId: Int64) async throws -> Tweet {
        try await apiManager.request(TwitterRouter.retweet(tweetId))
    }

    func unretweet(tweetId: Int64) async throws -> Tweet {
        try await apiManager.request(TwitterRouter.unretweet(tweetId))
    }
}
