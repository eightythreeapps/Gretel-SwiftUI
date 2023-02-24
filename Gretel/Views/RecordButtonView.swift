//
//  RecordButtonView.swift
//  Gretel
//
//  Created by Ben Reed on 16/02/2023.
//

import SwiftUI

struct RecordButtonView: View {
    
    @Binding var recordingState:RecordingState
    
    public enum RecordButtonSize:Double {
        case small = 20.0
        case medium = 30.0
        case large = 60.0
    }
    
    var size:RecordButtonSize = .large
    
    var body: some View {
        HStack {
            Button {
                
                switch recordingState {
                case .recording:
                    recordingState = .paused
                case .stopped:
                    recordingState = .recording
                case .disabled, .error:
                    recordingState = .error
                case .paused:
                    recordingState = .recording
                }
                
            } label: {
                iconForState(recordingState: recordingState)
            }
            if recordingState == .paused {
                Button {
                    recordingState = .stopped
                } label: {
                    Image(systemName: "stop.circle")
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                        .foregroundColor(.primary)
                }
            }
            
        }
        
    }
    
    func iconForState(recordingState:RecordingState) -> some View {
        
        switch recordingState {
            
        case .recording:
            return Image(systemName: "pause.circle.fill")
                .resizable()
                .frame(width: size.rawValue, height: size.rawValue)
                .foregroundColor(.blue)
        case .disabled:
            return Image(systemName: "record.circle")
                .resizable()
                .frame(width: size.rawValue, height: size.rawValue)
                .foregroundColor(.gray)
        case .paused, .stopped, .error:
            return Image(systemName: "record.circle")
                .resizable()
                .frame(width: size.rawValue, height: size.rawValue)
                .foregroundColor(.red)
        
        }
        
    }
    
}

struct RecordButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RecordButtonView(recordingState: .constant(.paused))
    }
}
