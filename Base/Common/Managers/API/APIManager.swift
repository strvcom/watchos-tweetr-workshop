//
//  APIManager.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 10/27/21.
//

import Foundation

final class APIManager {
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

    // TODO: Implement request function
    func request(_: Router) {}
}
