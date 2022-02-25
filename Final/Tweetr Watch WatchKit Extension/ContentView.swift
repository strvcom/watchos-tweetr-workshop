//
//  ContentView.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 10/26/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authorizationStore = AuthorizationStore()
    @StateObject var timelineStore = TimelineStore()

    var body: some View {
        VStack {
            switch authorizationStore.state {
            case .authorized:
                LoggedInView()
            case .unauthorized:
                LoggedOutView()
            case .inProgress:
                ProgressView()
            case .failed:
                FailureView(text: "Failed to login") {
                    authorize()
                }
            }
        }
        .onAppear {
            authorizationStore.checkAuthorization()
        }
        .environmentObject(authorizationStore)
        .environmentObject(timelineStore)
    }
}

private extension ContentView {
    func authorize() {
        Task {
            await authorizationStore.authorize()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
