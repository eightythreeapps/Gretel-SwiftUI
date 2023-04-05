//
//  RecordButtonView.swift
//  Gretel
//
//  Created by Ben Reed on 16/02/2023.
//

import SwiftUI

struct RecordButtonView: View {
    
    @EnvironmentObject var locationRecorder:LocationRecorder
    
    public enum RecordButtonSize:Double {
        case small = 20.0
        case medium = 30.0
        case large = 60.0
    }
    
    var size:RecordButtonSize = .large
    
    var body: some View {
        HStack {
            Button {
                
                switch locationRecorder.state {
                case .stopped:
                    locationRecorder.startRecording()
                case .recording:
                    locationRecorder.pauseRecording()
                case .paused:
                    locationRecorder.startRecording()
                case .error:
                    print("Erorr state")
                }
                
            } label: {
                iconForState(recordingState: locationRecorder.state)
            }
            if locationRecorder.state == .recording || locationRecorder.state == .paused {
                Button {
                    locationRecorder.endRecording()
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
        case .error:
            return Image(systemName: "record.circle")
                .resizable()
                .frame(width: size.rawValue, height: size.rawValue)
                .foregroundColor(.gray)
        case .paused, .stopped:
            return Image(systemName: "record.circle")
                .resizable()
                .frame(width: size.rawValue, height: size.rawValue)
                .foregroundColor(.red)
        }
    }
    
}

struct RecordButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeRecordButtonViewPreview()
    }
}
