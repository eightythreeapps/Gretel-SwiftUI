//
//  ContentView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 15/09/2022.
//

import SwiftUI
import CoreData

enum MenuItem:CaseIterable, Identifiable {
    case myTracks
    case settings
    
    var id:UUID {
        return UUID()
    }
    
    var name:String {
        switch self {
        case .myTracks:
            return "My Tracks"
        case .settings:
            return "Settings"
        }
        
    }
    
    var iconName:String {
        switch self {
        case .myTracks:
            return "gear"
        case .settings:
            return "point.topleft.down.curvedto.point.bottomright.up"
        }
    }
        
}

struct ContentView: View {
    
    @State var isShowingTrackList = false
    @EnvironmentObject var locationRecorder:LocationRecorder
    
    @State private var selectedMenuItem:MenuItem? = .myTracks
    @State private var columnVisibility:NavigationSplitViewVisibility = .automatic
    
    @EnvironmentObject var locationRecorderService:LocationRecorder
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name),
        SortDescriptor(\.startDate, order: .reverse)
    ])
    
    var tracks: FetchedResults<Track>
    
    @State var selectedTrack:Track?

    var body: some View {

        if UIDevice.isPhone {
            
            TabView {
                
                ForEach(MenuItem.allCases) { menuItem in
                    VStack {
                        NavigationStack {
                            
                            switch menuItem {
                            case .myTracks:
                                TrackListView(tracks: tracks.map{$0},
                                              selectedTrack: $selectedTrack)
                                
                            case .settings:
                                SettingsView()
                            }
                            
                        }
                        RecorderMiniView()
                    }
                    .tabItem {
                        Image(systemName: menuItem.iconName)
                        Text(menuItem.name)
                    }
                }
            }
            
        }else{
            
            NavigationSplitView(columnVisibility: $columnVisibility) {
                
                List(MenuItem.allCases, selection: $selectedMenuItem) { menuItem in
                    
                    NavigationLink {
                        switch menuItem {
                        case .myTracks:
                            TrackListView(tracks: tracks.map{$0}, selectedTrack: $selectedTrack)
                        case .settings:
                            SettingsView()
                        }
                    } label: {
                        Image(systemName: menuItem.iconName)
                        Text(menuItem.name)
                    }

                }
                
            } content: {
                TrackListView(tracks: tracks.map{$0}, selectedTrack: $selectedTrack)
            } detail: {
                Text("Detail")
            }

            
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeContentViewPreview()
    }
}

struct RecorderMiniView: View {
    
    @EnvironmentObject var locationRecorder:LocationRecorder
    
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "map")
            Spacer()
            VStack(alignment: .leading) {
                Text("0:33:54")
                Text("1,221 locaations")
            }
            Spacer()
            RecordButtonView(recordingState: $locationRecorder.currentRecordingState)
            Spacer()
        }
    }
}
