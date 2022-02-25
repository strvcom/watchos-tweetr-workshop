//
//  LoggedInView.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/11/21.
//

import SwiftUI

struct LoggedInView: View {
    var body: some View {
        TabView {
            NavigationView {
                TimelineView()
            }

            ProfileView()
        }
    }
}

struct LoggedView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInView()
    }
}
