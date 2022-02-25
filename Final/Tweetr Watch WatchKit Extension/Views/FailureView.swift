//
//  FailureView.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 1/24/22.
//

import SwiftUI

struct FailureView: View {
    let text: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Text(text)
                .font(.callout)
                .multilineTextAlignment(.center)

            Button(action: onRetry) {
                Text("Retry")
            }
        }
    }
}

struct FailureView_Previews: PreviewProvider {
    static var previews: some View {
        FailureView(
            text: "Failure",
            onRetry: {}
        )
    }
}
