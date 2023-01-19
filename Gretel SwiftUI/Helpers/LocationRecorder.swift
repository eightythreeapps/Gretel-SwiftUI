//
//  LocationService.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 16/09/2022.
//

import Foundation
import Combine
import CoreLocation
import MapKit

public final class LocationRecorder:NSObject, ObservableObject {
    
    private var locationService:LocationService
    private var trackHelper:TrackHelper
    private var settingsService:SettingsService
    private var cancellables = Set<AnyCancellable>()
    
    private static let DefaultLatitude = 0.1276
    private static let DefaultLongitude = 51.5072
    private static let DefaultCoordinateSpanDelta = 0.1
    
    @Published var currentRecordingState:RecordingState = .stopped
    @Published var currentActiveTrack:Track? = nil
    
    required public init(locationService:LocationService, settingsService:SettingsService, trackHelper:TrackHelper) {
        
        self.locationService = locationService
        self.settingsService = settingsService
        self.trackHelper = trackHelper
        
        locationService.startUpdatingUserHeading()
        locationService.startUpdatingUserLocation()
        
        super.init()
    
    }
     
    public func updateRecordingState() {
        switch self.currentRecordingState {
        case .recording:
            self.pauseRecording()
        case .stopped:
            self.createNewTrack()
        case .disabled:
            print("Recording disabled")
        case .paused:
            self.resumeRecording()
        }
    }
    
    public func createNewTrack(name:String? = nil) {
        
        trackHelper.createNewTrack(name: name)
            .sink { completion in
                self.currentRecordingState = .recording
            } receiveValue: { track in
                self.currentActiveTrack = track
                self.startRecordingTrack()
            }
            .store(in: &cancellables)
        
    }
    
    public func startRecordingTrack() {
        
        locationService.$currentLocation.sink { location in
            self.captureLocation(location: location)
        }.store(in: &cancellables)
        
    }
    
    public func resumeRecording() {
        
        guard let _ = self.currentActiveTrack else {
            self.currentRecordingState = .stopped
            return
        }
        
        self.currentRecordingState = .recording
        self.startRecordingTrack()
        
    }
    
    public func pauseRecording() {
        self.currentRecordingState = .paused
        self.emptyCancellables()
    }
    
    public func endTrack() {
        
        self.trackHelper.endCurrentRecording().sink { ended in
            if ended {
                self.currentActiveTrack = nil
                self.currentRecordingState = .stopped
                self.emptyCancellables()
            }
        }.store(in: &cancellables)
    }

    func captureLocation(location:CLLocation) {
        
        self.trackHelper.addPointToSegment(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    
    }
    
    func emptyCancellables() {
        cancellables.removeAll()
    }
    
    
}
