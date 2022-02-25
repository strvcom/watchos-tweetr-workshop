//
//  HTTPStatusCode.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 10/27/21.
//

import Foundation

public typealias HTTPStatusCode = Int

public extension HTTPStatusCode {
    static var successCodes: Range<HTTPStatusCode> {
        200..<300
    }

    /// HTTP status code between 300-400
    static var redirectCodes: Range<HTTPStatusCode> {
        300..<400
    }

    /// HTTP status code between 200-400
    static var successAndRedirectCodes: Range<HTTPStatusCode> {
        200..<400
    }
}
