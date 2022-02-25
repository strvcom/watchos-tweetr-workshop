//
//  APIError.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 10/27/21.
//

import Foundation

enum APIError: Error, LocalizedError {
    case unknown
    case apiError(reason: String)
    case missingURL
    case parametersNil
    case encodingFailure
    case decodingFailure
    case invalidUrlComponents
    case encryptionFailed

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case let .apiError(reason):
            return reason
        case .missingURL:
            return "URL is nil"
        case .parametersNil:
            return "Parameters are nil"
        case .encodingFailure:
            return "Encoding failed"
        case .decodingFailure:
            return "Decoding failed"
        case .invalidUrlComponents:
            return "Invalid URL components"
        case .encryptionFailed:
            return "Failed to encrypt the parameters"
        }
    }
}
