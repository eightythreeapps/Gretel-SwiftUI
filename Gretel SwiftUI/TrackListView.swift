//
//  TrackListView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 11/11/2022.
//

import SwiftUI
import CoreData

struct TrackListView: View {
    
    @EnvironmentObject var locationRecorderService:LocationRecorderService
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name),
        SortDescriptor(\.startDate, order: .reverse)
    ])
    var tracks: FetchedResults<Track>
    
    @State var isPresentingNewTrackForm:Bool = false
    @State var trackName:String = "New track"
    
    var body: some View {
        
        VStack {
            
            List(tracks) { track in
                NavigationLink {
                    Text(track.displayName())
                } label: {
                    Text(track.displayName())
                }
            }
            
        }
        .navigationTitle("Gretel")
        .navigationBarItems(
            trailing:
                Button(action: {
                    isPresentingNewTrackForm = true
                }, label: {
                    Image(systemName: "plus")
                })
        )
        .alert("Start recording new track?",
               isPresented: $isPresentingNewTrackForm) {
            
            TextField("Username", text: $trackName)
            
            Button("Start recording", action: {
                locationRecorderService.startNewTrack(name: trackName)
                isPresentingNewTrackForm = false
            })
            
            Button("Cancel", role: .cancel, action: {
                isPresentingNewTrackForm = false
            })
            
        }
    }
}

struct TrackListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PreviewFactory.TrackListPreview()
        }
    }
}
