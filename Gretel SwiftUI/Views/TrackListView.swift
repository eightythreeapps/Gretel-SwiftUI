//
//  TrackListView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 11/11/2022.
//

import SwiftUI
import CoreData

struct TrackListView: View {
    
    @State var trackName:String = "New track"
    
    var tracks = [Track]()
    @Binding var path: [Track]

    var body: some View {
        
        List(tracks) { track in
            NavigationLink(track.displayName(), value:track)
        }
        .navigationDestination(for: Track.self) { track in
            RecordedTrackDetailView(track: track)
        }
        .navigationTitle("My tracks")
    }
}

struct TrackListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PreviewFactory.makeTrackListPreview()
        }
    }
}
