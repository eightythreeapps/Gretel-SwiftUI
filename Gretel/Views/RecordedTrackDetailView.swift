//
//  RecordedTrackDetailView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 20/01/2023.
//

import SwiftUI

struct RecordedTrackDetailView: View {
    
    @EnvironmentObject var ioService:IOService
    
    var track:Track
    
    var body: some View {
        
        VStack {
            Text(track.displayName())
        }

    }
}

struct RecordedTrackDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeRecordedTrackDetailView()
    }
}
