//
//  HTTPHeader.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 10/27/21.
//

import Foundation

public enum HTTPHeader {
    public enum HeaderField: String {
        case contentType = "Content-Type"
    }

    public enum ContentType: String {
        case json = "application/json"
        case text = "text/html;charset=utf-8"
    }
}
