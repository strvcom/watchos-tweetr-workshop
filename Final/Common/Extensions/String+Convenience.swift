//
//  String+Convenience.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/5/21.
//

import Foundation

extension String {
    var urlEncoded: String {
        var charset: CharacterSet = .urlQueryAllowed
        charset.remove(charactersIn: "\n:#/?@!$&'()*+,;=")
        return addingPercentEncoding(withAllowedCharacters: charset) ?? ""
    }

    var urlQueryStringParameters: [String: String] {
        // breaks apart query string into a dictionary of values
        var params = [String: String]()
        let items = split(separator: "&")
        for item in items {
            let combo = item.split(separator: "=")
            if combo.count == 2 {
                let key = "\(combo[0])"
                let val = "\(combo[1])"
                params[key] = val
            }
        }

        return params
    }
}
