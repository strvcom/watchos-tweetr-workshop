//
//  TwitterRouter.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/10/21.
//

import CryptoKit
import Foundation

enum TwitterRouter {
    // MARK: - GET
    case timeline
    case tweetDetail(Int64)
    case profile

    // MARK: - POST
    case like(Int64)
    case unlike(Int64)
    case retweet(Int64)
    case unretweet(Int64)
}

extension TwitterRouter: Router {
    var baseURL: URL {
        Constants.Api.baseUrl.appendingPathComponent("1.1")
    }

    var path: String {
        switch self {
        case .timeline:
            return "statuses/home_timeline.json"
        case .tweetDetail:
            return "statuses/show.json"
        case .profile:
            return "account/verify_credentials.json"
        case .like:
            return "favorites/create.json"
        case .unlike:
            return "favorites/destroy.json"
        case let .retweet(id):
            return "statuses/retweet/\(id).json"
        case let .unretweet(id):
            return "statuses/unretweet/\(id).json"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .timeline,
             .tweetDetail,
             .profile:
            return .get
        case .like,
             .unlike,
             .retweet,
             .unretweet:
            return .post
        }
    }

    var urlParameters: [String: Any]? {
        switch self {
        case .timeline:
            return [
                "count": 800,
                "trim_user": false
            ]
        case let .tweetDetail(id),
             let .like(id),
             let .unlike(id):
            return [
                "id": id,
                "tweet_mode": "extended",
                "include_entities": true
            ]
        case .unretweet,
             .retweet:
            return [
                "trim_user": false,
                "tweet_mode": "extended",
                "include_entities": true
            ]
        default:
            return nil
        }
    }

    var headers: [String: String]? {
        nil
    }

    var acceptableStatusCodes: Range<HTTPStatusCode>? {
        nil
    }

    var isAuthorizationRequired: Bool {
        true
    }
}

extension TwitterRouter: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        isAuthorizationRequired
            ? .oauth
            : .none
    }
}
