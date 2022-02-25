//
//  LoggedOutView.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/18/21.
//

import SwiftUI

struct LoggedOutView: View {
    @EnvironmentObject var authorizationStore: AuthorizationStore

    var body: some View {
        VStack {
            Text("Log in to your Twitter account")

            Spacer()

            Button(action: authorize) {
                Text("Log in")
            }
        }
        .padding()
    }
}

private extension LoggedOutView {
    func authorize() {
        Task {
            await authorizationStore.authorize()
        }
    }
}

struct LoggedOutView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedOutView()
    }
}
