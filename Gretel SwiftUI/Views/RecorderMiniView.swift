//
//  RecorderMiniView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 31/01/2023.
//

import SwiftUI

struct RecorderMiniView: View {
    
    @EnvironmentObject var locationRecorder:LocationRecorderService
    @Binding var shouldShowFullRecorderView:Bool
    
    var body: some View {
        HStack {
            Spacer()
            if locationRecorder.currentActiveTrack != nil {
                Image(systemName: "map")
                Spacer()
                VStack(alignment: .leading) {
                    Text(locationRecorder.currentActiveTrack?.durationDisplay ?? "")
                    Text(locationRecorder.currentActiveTrack?.pointsCountDisplay ?? "")
                }
                .onTapGesture {
                    shouldShowFullRecorderView = true
                }
            }else{
                
                Text("Start new recording")
                    .onTapGesture {
                        shouldShowFullRecorderView = true
                    }
            }
            
            Spacer()
            RecordButtonView(recordingState: $locationRecorder.currentRecordingState, size: .medium)
            Spacer()
        }
    }
}


struct RecorderMiniView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeRecorderMiniView()
    }
}
