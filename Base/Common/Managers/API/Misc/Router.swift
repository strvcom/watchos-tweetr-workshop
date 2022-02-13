//
//  Router.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 10/27/21.
//

import Foundation

protocol Router {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var urlParameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var isAuthorizationRequired: Bool { get }

    func asRequest() throws -> URLRequest
}

extension Router {
    func asRequest() throws -> URLRequest {
        let urlPath = baseURL.appendingPathComponent(path)

        guard var urlComponents = URLComponents(url: urlPath, resolvingAgainstBaseURL: true) else {
            throw APIError.invalidUrlComponents
        }

        if let urlParameters = urlParameters {
            urlComponents.queryItems = urlParameters.map {
                URLQueryItem(name: $0, value: String(describing: $1))
            }
        }

        guard let url = urlComponents.url else {
            throw APIError.invalidUrlComponents
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        request.setValue(
            HTTPHeader.ContentType.json.rawValue,
            forHTTPHeaderField: HTTPHeader.HeaderField.contentType.rawValue
        )

        return request
    }
}
