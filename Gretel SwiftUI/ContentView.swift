//
//  ContentView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 15/09/2022.
//

import SwiftUI
import CoreData
import PermissionsSwiftUI
import CoreLocation

struct ContentView: View {
    
    @State var showPermissionsModal = true
    @EnvironmentObject var locationRecorder:LocationRecorderService
    
    var body: some View {
        NavigationView {
            TripDashboardView()
                .environmentObject(locationRecorder)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.ContentViewPreview()
    }
}
