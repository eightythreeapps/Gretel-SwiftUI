//
//  RecorderMiniView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 31/01/2023.
//

import SwiftUI
import SwiftDate

public class RecorderMiniViewViewModel:ObservableObject {
    
    @Published var shouldShowFullRecorderView:Bool
    @Published var track:ActiveTrack
    @Published var recordingState:RecordingState
    
    public init(shouldShowFullRecorderView: Bool, track: ActiveTrack, recordingState: RecordingState) {
        self.shouldShowFullRecorderView = shouldShowFullRecorderView
        self.track = track
        self.recordingState = recordingState
    }
    
}

struct RecorderMiniView: View {
    
    @StateObject var viewModel = ViewModelFactory.shared.makeRecorderMiniViewViewModel()

    var body: some View {
        HStack {
            Spacer()
            if viewModel.track.readyToRecord() {
                Image(systemName: "map")
                Spacer()
                VStack(alignment: .leading) {
                    Text("\($viewModel.track.totalDurationSeconds.wrappedValue.toClock(zero: [.pad,.dropMiddle]))")
                }
                .onTapGesture {
                    viewModel.shouldShowFullRecorderView = true
                }
            }else{
                
                Text("Start new recording")
                    .onTapGesture {
                        viewModel.shouldShowFullRecorderView = true
                    }
                
            }
            
            Spacer()
            RecordButtonView(recordingState: $viewModel.recordingState, size: .medium)
            Spacer()
        }
    }
}


struct RecorderMiniView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeRecorderMiniView()
    }
}
