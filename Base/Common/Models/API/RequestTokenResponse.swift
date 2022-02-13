//
//  RequestTokenResponse.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 2/13/22.
//

import Foundation

struct RequestTokenResponse {
    let oauthToken: String

    init?(data: Data) {
        guard
            let dataString = String(data: data, encoding: .utf8),
            let token = dataString.urlQueryStringParameters["oauth_token"]
        else {
            return nil
        }

        oauthToken = token
    }
}
