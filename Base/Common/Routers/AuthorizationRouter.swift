//
//  AuthorizationRouter.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 10/28/21.
//

import CryptoKit
import Foundation

enum AuthorizationRouter {
    case requestToken
    case authorize(token: String)
    case accessToken(token: String, verifier: String)
}

extension AuthorizationRouter: Router {
    var baseURL: URL {
        Constants.Api.baseUrl
    }

    var path: String {
        switch self {
        case .requestToken:
            return "oauth/request_token"
        case .authorize:
            return "oauth/authorize"
        case .accessToken:
            return "oauth/access_token"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .requestToken,
             .accessToken:
            return .post
        case .authorize:
            return .get
        }
    }

    var urlParameters: [String: Any]? {
        switch self {
        case .requestToken:
            return nil
        case let .authorize(token):
            return ["oauth_token": token]
        case let .accessToken(token, verifier):
            return [
                "oauth_token": token,
                "oauth_verifier": verifier
            ]
        }
    }

    var headers: [String: String]? {
        nil
    }

    var isAuthorizationRequired: Bool {
        switch self {
        case .requestToken:
            return true
        default:
            return false
        }
    }
}

extension AuthorizationRouter: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        isAuthorizationRequired
            ? .oauth
            : .none
    }
}
