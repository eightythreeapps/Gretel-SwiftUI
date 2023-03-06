//
//  RecordedTrackDetailView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 20/01/2023.
//

import SwiftUI

struct RecordedTrackDetailView: View {
    
    var track:Track
    
    var body: some View {
        
        VStack {
            Text(track.displayName())
            
//            ShareLink(item: try! GPXFile(track: track).fileURL(), preview: SharePreview("Your Trip")) {
//                Text("Share me")
//            }
        }
        
    }
}

struct RecordedTrackDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeRecordedTrackDetailView()
    }
}
