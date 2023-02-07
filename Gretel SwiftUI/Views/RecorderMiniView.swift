//
//  RecorderMiniView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 31/01/2023.
//

import SwiftUI

struct RecorderMiniView: View {
    
    @EnvironmentObject var locationRecorder:LocationRecorder
    @Binding var shouldShowFullRecorderView:Bool
    
    var body: some View {
        HStack {
            Spacer()
            if locationRecorder.currentActiveTrack.exists() {
                Image(systemName: "map")
                Spacer()
                VStack(alignment: .leading) {
                    Text(locationRecorder.currentActiveTrack.durationDisplay)
                    Text(locationRecorder.currentActiveTrack.pointsCountDisplay)
                }
            }else{
                Button {
                    shouldShowFullRecorderView = true
                } label: {
                    Text("Start new recording")
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
