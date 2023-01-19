//
//  ContentView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 15/09/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var isShowingTrackList = false
    
    var body: some View {
       
        TrackRecorderView()
            .sheet(isPresented: $isShowingTrackList) {
                TrackListView()
            }
        
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeContentViewPreview()
    }
}
