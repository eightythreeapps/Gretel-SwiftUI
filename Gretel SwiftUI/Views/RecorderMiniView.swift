//
//  RecorderMiniView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 31/01/2023.
//

import SwiftUI

struct RecorderMiniView: View {
    
    @EnvironmentObject var locationRecorder:LocationRecorder
    @Binding var track:Track?
    
    var body: some View {
        HStack {
            Spacer()
            if let track = track {
                Image(systemName: "map")
                Spacer()
                VStack(alignment: .leading) {
                    Text("--:--:--")
                    Text("1,221 locaations")
                }
            }else{
                Button {
                    //Do stuff
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
