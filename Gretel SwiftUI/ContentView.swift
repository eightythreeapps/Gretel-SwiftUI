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
    
    @EnvironmentObject var recordingService:RecordingService
    
    var body: some View {
        NavigationView {
            TripDashboardView()
                .environmentObject(recordingService)
                .JMAlert(showModal: $showPermissionsModal, for: [.locationAlways], autoCheckAuthorization: true)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.ContentViewPreview()
    }
}
