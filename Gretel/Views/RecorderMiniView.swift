//
//  RecorderMiniView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 31/01/2023.
//

import SwiftUI
import SwiftDate

struct RecorderMiniView: View {

    @EnvironmentObject var locationRecorder:LocationRecorder
    @Binding var shouldShowFullRecorderView:Bool
    
    var body: some View {
        HStack {
            switch locationRecorder.state {
            case .stopped:
                Text("No active track")
            case .recording, .paused:
                VStack(alignment: .leading) {
                    Text(locationRecorder.elapsedTimeDisplay)
                }
            case .error:
                Text("Something went wrong")
            }
            
            RecordButtonView(size: .medium)
        
        }
        .padding()
        .onTapGesture {
            shouldShowFullRecorderView = true
        }
    }
}


struct RecorderMiniView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeRecorderMiniView()
    }
}
