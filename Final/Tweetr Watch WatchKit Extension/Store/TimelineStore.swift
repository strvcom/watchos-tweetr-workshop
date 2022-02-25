//
//  TimelineStore.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/15/21.
//

import Foundation

class TimelineStore: ObservableObject {
    @Injected var twitterService: TwitterServicing

    @Published var state: State = .loading

    @MainActor
    func fetchTimeline() async {
        do {
            let tweets = try await twitterService.getTimeline()
            state = .success(tweets)
        } catch {
            state = .failure
        }
    }
}

// MARK: - State
extension TimelineStore {
    enum State: Equatable {
        case loading
        case success([Tweet])
        case failure
    }
}
