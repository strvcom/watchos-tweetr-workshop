//
//  AuthorizationStore.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 10/26/21.
//

import AuthenticationServices
import Foundation

final class AuthorizationStore: NSObject, ObservableObject {
    var webAuthSession: ASWebAuthenticationSession?

    var isAuthorized: Bool = false

    // TODO: - Implement authorize method
    func authorize() async {}

    // TODO: Implement logout
    func logout() {}
}

// MARK: - Private functions
private extension AuthorizationStore {
    // TODO: - Implement login using authenticationService
    func authorize(with token: String?, onAuthorization _: @escaping (Result<(String, String), APIError>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "twitter.com"
        components.path = "/oauth/authorize"
        components.queryItems = [
            URLQueryItem(name: "oauth_token", value: token),
            URLQueryItem(name: "oauth_callback", value: "tweetr://")
        ]

        let callbackUrlScheme = "tweetr"

        webAuthSession?.start()
    }

    // TODO: - Implement bridge function
    func authorize(with _: String?) {}
}

extension AuthorizationStore {
    enum State: Equatable {
        case inProgress
        case unauthorized
        case authorized
        case failed
    }
}
