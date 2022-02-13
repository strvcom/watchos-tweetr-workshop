//
//  HTTPMethod.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 10/27/21.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case head = "HEAD"
    case patch = "PATCH"
    case options = "OPTIONS"
    case delete = "DELETE"
}
