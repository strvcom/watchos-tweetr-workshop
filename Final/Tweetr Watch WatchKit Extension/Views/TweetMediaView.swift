//
//  TweetMediaView.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/25/21.
//

import SwiftUI

struct TweetMediaView: View {
    let mediaUrl: URL?
    let isVideoPreview: Bool
    let width: CGFloat

    var body: some View {
        if let url = mediaUrl {
            ZStack {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case let .success(downloadedImage):
                        downloadedImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width, height: width * 0.6)

                        if isVideoPreview {
                            Image(systemName: "play.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    case .failure:
                        EmptyView()
                    default:
                        ProgressView()
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct TweetMediaView_Previews: PreviewProvider {
    static var previews: some View {
        TweetMediaView(
            mediaUrl: URL(string: "https://i0.wp.com/url-media.com/wp-content/uploads/2021/01/cropped-Icon.png?fit=512%2C512&ssl=1")!,
            isVideoPreview: false,
            width: 100
        )
    }
}
