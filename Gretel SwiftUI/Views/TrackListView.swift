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
    
    @EnvironmentObject var locationRecorderService:LocationRecorder
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name),
        SortDescriptor(\.startDate, order: .reverse)
    ])
    var tracks: FetchedResults<Track>
        
    var body: some View {
        
        List(tracks) { track in
            
            NavigationLink {
                RecordedTrackDetailView()
            } label: {
                Text(track.displayName())
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
