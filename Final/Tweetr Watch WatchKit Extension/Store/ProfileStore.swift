//
//  ProfileStore.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/30/21.
//

import Foundation

final class ProfileStore: ObservableObject {
    @Injected var twitterService: TwitterServicing
    @Published var state: State = .inProgress

    @MainActor
    func fetchCurrentUserProfile() async {
        do {
            let user = try await twitterService.getCurrentUser()
            state = .success(user)
        } catch {
            state = .failure
        }
    }

    enum State {
        case inProgress
        case success(User)
        case failure
    }
}
