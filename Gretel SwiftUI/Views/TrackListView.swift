//
//  TrackListView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 11/11/2022.
//

import SwiftUI
import CoreData

struct TrackListView: View {
    
    var tracks:[Track]? = [Track]()
    @Binding var selectedTrack:Track?
    @State var trackName:String = "New track"
    
    var body: some View {
        
        VStack {
            if let tracks = tracks {
                List(tracks, selection:$selectedTrack) { track in
                    
                    NavigationLink {
                        RecordedTrackDetailView(track: $selectedTrack)
                    } label: {
                        Text(track.displayName())
                    }
                }
            }else{
                Text("No tracks to display")
            }
        }
        .navigationTitle("My tracks")
        .navigationBarItems(
            trailing:
                Button(action: {

                }, label: {
                    Image(systemName: "plus")
                })
        )
    }
}

struct TrackListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PreviewFactory.makeTrackListPreview()
        }
    }
}
