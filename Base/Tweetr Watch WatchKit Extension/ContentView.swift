//
//  ContentView.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 10/26/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authorizationStore = AuthorizationStore()

    var body: some View {
        VStack {
            Text("Hello, world!")
        }
        .environmentObject(authorizationStore)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
