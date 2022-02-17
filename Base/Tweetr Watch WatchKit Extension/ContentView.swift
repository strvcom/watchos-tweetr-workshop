//
//  ContentView.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 10/26/21.
//

// WIFI Name: STRV-Guest
// WIFI PW: strvhere

import SwiftUI

struct ContentView: View {
    @StateObject var authorizationStore = AuthorizationStore()

    var body: some View {
        VStack {
            switch authorizationStore.state {
            case .authorized:
                Text("Authorized")
            case .unauthorized:
                LoggedOutView()
            case .inProgress:
                ProgressView()
            case .failed:
                Text("Failure")
            }
        }
        .onAppear {
            authorizationStore.logout()
            authorizationStore.checkAuthorization()
        }
        .environmentObject(authorizationStore)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
