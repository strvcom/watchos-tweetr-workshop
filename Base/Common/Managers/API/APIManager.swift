//
//  APIManager.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 10/27/21.
//

import Foundation

final class APIManager: APIManaging {
    @Injected var keychainManager: KeychainManaging
    
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30

        return URLSession(configuration: config)
    }()

    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        return decoder
    }()

    func request(_ endpoint: Router) async throws -> Data {
        var request = try endpoint.asRequest()
        
        let token = keychainManager.get(key: Constants.Keychain.authToken)
        let tokenSecret = keychainManager.get(key: Constants.Keychain.authTokenSecret)
        
        if
            let authorizableRequest = request as? AccessTokenAuthorizable,
            let header = try authorizableRequest.getAuthenticationHeader(token: token, tokenSecret: tokenSecret)
        {
            request.setValue(header, forHTTPHeaderField: "Authorization")
        }
        
        let (data, _) = try await urlSession.data(for: request)
        
        return data
    }
    
    func request<T>(_ endpoint: Router) async throws -> T where T: Decodable {
        let data = try await request(endpoint)
        let object = try decoder.decode(T.self, from: data)
        
        return object
    }
}
