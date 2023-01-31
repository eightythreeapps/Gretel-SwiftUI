//
//  RecordedTrackDetailView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 20/01/2023.
//

import SwiftUI

struct RecordedTrackDetailView: View {
    
    @Binding var track:Track?
    
    var body: some View {
        
        if let track = track {
            Text("Track \(track.displayName())")
        }else{
            Text("No data to display")
        }
        
       
    }
}

struct RecordedTrackDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeRecordedTrackDetailView()
    }
}
