//
//  ProfileView.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/11/21.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @StateObject var profileStore = ProfileStore()
    @EnvironmentObject var authorizationStore: AuthorizationStore

    var body: some View {
        Group {
            switch profileStore.state {
            case .inProgress:
                ProgressView()
            case let .success(user):
                UserView(user: user) {
                    authorizationStore.logout()
                }
            case .failure:
                FailureView(text: "Failed to load the profile") {
                    fetchProfile()
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            fetchProfile()
        }
    }
}

private extension ProfileView {
    func fetchProfile() {
        Task {
            await profileStore.fetchCurrentUserProfile()
        }
    }
}
