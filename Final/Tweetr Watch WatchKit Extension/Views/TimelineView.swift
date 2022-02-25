//
//  TimelineView.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/11/21.
//

import Foundation
import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var timelineStore: TimelineStore
    @EnvironmentObject var authorizationStore: AuthorizationStore

    var body: some View {
        VStack {
            switch timelineStore.state {
            case .loading:
                ProgressView()
            case let .success(tweets):
                List(tweets) { tweet in
                    NavigationLink(destination: {
                        TweetDetailView(tweetId: tweet.id)
                    }) {
                        TweetView(tweet: tweet)
                    }
                }
                .listStyle(.elliptical)
            case .failure:
                FailureView(text: "Failed to load your timeline") {
                    fetchTimeline()
                }
            }
        }
        .navigationTitle("Timeline")
        .onChange(of: timelineStore.state) { newValue in
            if case .failure = newValue {
                authorizationStore.logout()
            }
        }
        .onAppear {
            fetchTimeline()
        }
    }
}

private extension TimelineView {
    func fetchTimeline() {
        Task {
            await timelineStore.fetchTimeline()
        }
    }
}
