//
//  RecordButtonView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/10/2022.
//

import SwiftUI

struct RecordButtonView: View {
    
    enum RecordButtonState {
        case recording
        case stopped
        case disabled
    }

    var buttonState: RecordButtonState = .stopped
    
    var body: some View {
        ZStack {
            Image(systemName: "circle")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(.red)
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 45, height: 45)
                .foregroundColor(.red)
        }.padding()
    }
}

struct RecordButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.RecordButtonPreview()
    }
}

