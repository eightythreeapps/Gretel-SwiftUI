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
            return "point.topleft.down.curvedto.point.bottomright.up"
        case .settings:
            return "gear"
        }
    }
        
}

struct ContentView: View {
    
    @State var isShowingTrackList = false
    @EnvironmentObject var locationRecorder:LocationRecorder
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name),
        SortDescriptor(\.startDate, order: .reverse)
    ])
    var tracks: FetchedResults<Track>
    
    @State private var path: [Track] = [Track]()
    
    @State private var selectedMenuItem:MenuItem? = .myTracks
    @State private var columnVisibility:NavigationSplitViewVisibility = .automatic

    var body: some View {

        if UIDevice.isPhone {
            
            TabView {
               
                VStack {
                    NavigationStack(path: $path) {
                        TrackListView(tracks: tracks.map {$0}, path: $path)
                    }
                    RecorderMiniView(track: $locationRecorder.currentActiveTrack)
                }
                .tabItem {
                    Image(systemName: MenuItem.myTracks.iconName)
                    Text(MenuItem.myTracks.name)
                }
                
                NavigationStack {
                    SettingsView()
                }
                .tabItem {
                    Image(systemName: MenuItem.settings.iconName)
                    Text(MenuItem.settings.name)
                }
                
            }
            
        }else{
            
            NavigationSplitView(columnVisibility: $columnVisibility) {
                
                List(MenuItem.allCases, selection: $selectedMenuItem) { menuItem in
                    
                    NavigationLink {
                        switch menuItem {
                        case .myTracks:
                            TrackListView(tracks: tracks.map {$0}, path: $path)
                        case .settings:
                            SettingsView()
                        }
                    } label: {
                        Image(systemName: menuItem.iconName)
                        Text(menuItem.name)
                    }

                }
                
            } content: {
                TrackListView(tracks: tracks.map {$0}, path: $path)
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
