//
//  Constants.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/5/21.
//

import Foundation

enum Constants {
    enum Api {
        // swiftlint:disable:next force_unwrapping
        static let baseUrl = URL(string: "https://api.twitter.com")!
    }

    enum Authentication {
        // TODO: - Add your own key and secret
        static let consumerKey = ""
        static let consumerSecret = ""
        static let callbackUrl = "tweetr://"
    }

    enum Keychain {
        static let authToken = "keychain.twitter.auth.token"
        static let authTokenSecret = "keychain.twitter.auth.token.secret"
    }
}
