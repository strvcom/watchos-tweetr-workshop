//
//  UserView.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/30/21.
//

import SwiftUI

struct UserView: View {
    let user: User
    let onLogoutTap: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                AsyncImage(url: user.profileImageUrl)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())

                Text(user.name)
                    .font(.headline)
                    .lineLimit(2)
            }

            Text(user.description)
                .font(.caption)

            HStack {
                Label("\(user.friendsCount)", systemImage: "arrow.up.circle")

                Label("\(user.followersCount)", systemImage: "arrow.down.circle")
            }

            Spacer()

            Button(action: onLogoutTap) {
                Text("Log out")
            }
        }
    }
}
