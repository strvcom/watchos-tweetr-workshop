//
//  TweetView.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/11/21.
//

import AVKit
import Foundation
import SwiftUI

struct TweetView: View {
    let tweet: Tweet

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                AsyncImage(url: tweet.user.profileImageUrl)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())

                Text(tweet.user.name)
                    .font(.headline)
                    .lineLimit(2)
            }

            Text(tweet.text ?? "")
                .font(.subheadline)
        }
        .padding()
    }
}
