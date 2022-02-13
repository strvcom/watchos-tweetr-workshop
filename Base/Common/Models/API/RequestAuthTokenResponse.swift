//
//  RequestAuthTokenResponse.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 2/13/22.
//

import Foundation

struct RequestAuthTokenResponse {
    let oauthToken: String
    let oauthTokenSecret: String

    init?(data: Data) {
        guard
            let dataString = String(data: data, encoding: .utf8),
            let token = dataString.urlQueryStringParameters["oauth_token"],
            let tokenSecret = dataString.urlQueryStringParameters["oauth_token_secret"]
        else {
            return nil
        }

        oauthToken = token
        oauthTokenSecret = tokenSecret
    }
}
