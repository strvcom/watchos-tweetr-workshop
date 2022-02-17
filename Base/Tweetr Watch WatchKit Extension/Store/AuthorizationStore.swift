//
//  AuthorizationStore.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 10/26/21.
//

import AuthenticationServices
import Foundation

@MainActor
final class AuthorizationStore: NSObject, ObservableObject {
    @Injected var keychainManager: KeychainManaging
    @Injected var apiManager: APIManaging
    
    @Published var state: State = .unauthorized
    
    var webAuthSession: ASWebAuthenticationSession?

    func authorize() async {
        do {
            state = .inProgress
            
            let tokenRequestData = try await apiManager.request(AuthorizationRouter.requestToken)
            
            guard let tokenRequest = RequestTokenResponse(data: tokenRequestData) else {
                state = .failed
                return
            }
            
            let (token, tokenVerifier) = try await authorize(with: tokenRequest.oauthToken)
            
            let accessTokenData = try await apiManager.request(AuthorizationRouter.accessToken(token: token, verifier: tokenVerifier))
            
            guard let accessToken = RequestAuthTokenResponse(data: accessTokenData) else {
                state = .failed
                return
            }
            
            keychainManager.set(key: Constants.Keychain.authToken, value: accessToken.oauthToken)
            keychainManager.set(key: Constants.Keychain.authTokenSecret, value: accessToken.oauthTokenSecret)
            
            state = .authorized
        } catch let error {
            print("V60: ", error)
            state = .failed
        }
    }

    func logout() {
        state = .unauthorized
        keychainManager.remove(key: Constants.Keychain.authToken)
        keychainManager.remove(key: Constants.Keychain.authTokenSecret)
    }
    
    func checkAuthorization() {
        guard keychainManager.has(key: Constants.Keychain.authToken) else {
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
        ) { callbackUrl, error in
            guard
                error == nil,
                let url = callbackUrl,
                let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let oauthToken = urlComponents.queryItems?.first(where: { $0.name == "oauth_token" })?.value,
                let oauthVerifier = urlComponents.queryItems?.first(where: { $0.name == "oauth_verifier"})?.value
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
