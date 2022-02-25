//
//  APIManaging.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 10/27/21.
//

import Foundation

protocol APIManaging {
    var decoder: JSONDecoder { get }

    func request(_ endpoint: Router) async throws -> Data
    func request<T: Decodable>(_ endpoint: Router) async throws -> T
}
