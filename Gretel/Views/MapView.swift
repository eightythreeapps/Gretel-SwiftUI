//
//  MapView.swift
//  Gretel
//
//  Created by Ben Reed on 06/04/2023.
//

import Foundation
import SwiftUI
import MapKit

struct MapView:UIViewRepresentable {
    
    @Binding var region:MKCoordinateRegion
    @Binding var recordingState:RecordingState
    
    class Coordinator:NSObject, MKMapViewDelegate {
        
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            mapView.centerCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion( center: userLocation.coordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
            mapView.setRegion(mapView.regionThatFits(region), animated: true)
            
            if self.parent.recordingState == .recording {
                print("Recording...")
            }
        }
        
        func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
            print("Could not locate user: \(error.localizedDescription)")
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
       
    }
    
}
