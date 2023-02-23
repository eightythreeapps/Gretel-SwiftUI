//
//  RecorderMiniView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 31/01/2023.
//

import SwiftUI
import SwiftDate

struct RecorderMiniView: View {

    @Binding var shouldShowFullRecorderView:Bool
    @Binding var track:ActiveTrack
    @Binding var recordingState:RecordingState
    
    var body: some View {
        HStack {
            Spacer()
            if track.readyToRecord() {
                Image(systemName: "map")
                Spacer()
                VStack(alignment: .leading) {
                    Text("\($track.totalDurationSeconds.wrappedValue.toClock(zero: [.pad,.dropMiddle]))")
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
            RecordButtonView(recordingState: $recordingState, size: .medium)
            Spacer()
        }
    }
}


struct RecorderMiniView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeRecorderMiniView()
    }
}
