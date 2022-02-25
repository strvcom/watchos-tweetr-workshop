//
//  AuthorizationStore.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 10/26/21.
//

import AuthenticationServices
import Foundation

@MainActor final class AuthorizationStore: NSObject, ObservableObject {
    @Injected var apiManager: APIManaging
    @Injected var keychainManager: KeychainManaging
    @Published var state: State = .inProgress

    var webAuthSession: ASWebAuthenticationSession?

    func authorize() async {
        do {
            state = .inProgress
            let requestTokenData = try await apiManager.request(AuthorizationRouter.requestToken)

            guard let requestToken = RequestTokenResponse(data: requestTokenData) else {
                throw APIError.decodingFailure
            }

            let (token, verifier) = try await authorize(with: requestToken.oauthToken)
            let authTokenData = try await apiManager.request(
                AuthorizationRouter.accessToken(
                    token: token,
                    verifier: verifier
                )
            )

            guard let authToken = RequestAuthTokenResponse(data: authTokenData) else {
                throw APIError.decodingFailure
            }

            keychainManager.set(key: Constants.Keychain.authToken, value: authToken.oauthToken)
            keychainManager.set(key: Constants.Keychain.authTokenSecret, value: authToken.oauthTokenSecret)

            state = .authorized
        } catch {
            state = .failed
        }
    }

    func logout() {
        keychainManager.remove(key: Constants.Keychain.authToken)
        keychainManager.remove(key: Constants.Keychain.authTokenSecret)

        state = .unauthorized
    }

    func checkAuthorization() {
        guard keychainManager.get(key: Constants.Keychain.authToken) != nil else {
            state = .unauthorized
            return
        }

        state = .authorized
    }
}

// MARK: - Private functions
private extension AuthorizationStore {
    func authorize(with token: String?, onAuthorization: @escaping (Result<(String, String), APIError>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "twitter.com"
        components.path = "/oauth/authorize"
        components.queryItems = [
            URLQueryItem(name: "oauth_token", value: token),
            URLQueryItem(name: "oauth_callback", value: "tweetr://")
        ]

        let callbackUrlScheme = "tweetr"

        guard let url = components.url else {
            state = .unauthorized
            return
        }

        webAuthSession = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: callbackUrlScheme
        ) { callbackURL, error in
            guard
                error == nil,
                let url = callbackURL,
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let oauthToken = components.queryItems?.first(where: { $0.name == "oauth_token" })?.value,
                let oauthVerifier = components.queryItems?.first(where: { $0.name == "oauth_verifier" })?.value
            else {
                onAuthorization(.failure(.unknown))
                return
            }

            onAuthorization(.success((oauthToken, oauthVerifier)))
        }

        webAuthSession?.start()
    }

    func authorize(with token: String?) async throws -> (String, String) {
        try await withCheckedThrowingContinuation { continuation in
            authorize(with: token) { result in
                continuation.resume(with: result)
            }
        }
    }
}

extension AuthorizationStore {
    enum State: Equatable {
        case inProgress
        case unauthorized
        case authorized
        case failed
    }
}
