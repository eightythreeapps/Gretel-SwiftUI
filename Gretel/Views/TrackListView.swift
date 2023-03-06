//
//  TrackListView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 11/11/2022.
//

import SwiftUI
import CoreData

struct TrackListView: View {
    
    @State var trackName:String = "Untitled"
    
    @Environment(\.managedObjectContext) var moc
    @SectionedFetchRequest<String, Track>(
        sectionIdentifier: \.formattedCreated!,
        sortDescriptors: [
            SortDescriptor(\.name),
            SortDescriptor(\.startDate, order: .reverse)
        ])
    
    var tracks: SectionedFetchResults<String, Track>
    
    @Binding var path: [Track]

    var body: some View {
        
        List(tracks) { section in
            Section(header: Text(section.id)) {
                ForEach (section) { track in
                    NavigationLink("\(track.displayName()): Points: \(track.pointsCount())",
                                   value:track)
                }
            }
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
