//
//  RecordButtonView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/10/2022.
//

import SwiftUI

struct RecordButtonView: View {
    
    @Binding var buttonState:RecordingState
    
    var body: some View {
        ZStack {
            
            switch buttonState {
                
            case .recording:
                
                Image(systemName: "circle")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.black)
                Image(systemName: "pause.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
                
            case .stopped:
            
                Image(systemName: "circle")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.red)
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.red)
                
            case .disabled:
                
                Image(systemName: "circle")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.gray)
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.gray)
                
            case .paused:
                Image(systemName: "circle")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.red)
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.red)
            }
            
            
        }.padding()
    }
    
}

struct RecordButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.RecordButtonPreview()
    }
}

