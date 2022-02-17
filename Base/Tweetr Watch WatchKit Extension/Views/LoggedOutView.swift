//
//  LoggedOutView.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 2/17/22.
//

import SwiftUI

struct LoggedOutView: View {
    @EnvironmentObject var authorizationStore: AuthorizationStore
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Login to your Twitter account")
            
            Button(action: authorize) {
                Text("Login")
            }
        }
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
