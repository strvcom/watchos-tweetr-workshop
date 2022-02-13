//
//  AuthorizationType.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/15/21.
//

import Foundation

enum AuthorizationType {
    case oauth

    var value: String {
        switch self {
        case .oauth:
            return "OAuth"
        }
    }
}
