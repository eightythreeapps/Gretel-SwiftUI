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
import CoreData

public final class LocationRecorder:NSObject, ObservableObject {
    
    private var locationService:LocationService
    private var trackHelper:TrackDataService
    private var settingsService:SettingsService
    private var cancellables = Set<AnyCancellable>()
    
    private static let DefaultLatitude = 0.1276
    private static let DefaultLongitude = 51.5072
    private static let DefaultCoordinateSpanDelta = 0.1
    
    @Published var currentRecordingState:RecordingState = .stopped
    @Published var currentActiveTrack:ActiveTrack = ActiveTrack()
    
    /**
     Initialises a new instance of LocationRecorder service. This is not a singleton, but there should only ever be one instance crearted when the app starts up.
     - parameters:
        - locationService: An instance of LocationService
        - settingsService: An instance of SettingsService
        - trackHelper: An instance with TrackDataService
     */
    required public init(locationService:LocationService, settingsService:SettingsService, trackHelper:TrackDataService) {
        
        //Assign dependencies
        self.locationService = locationService
        self.settingsService = settingsService
        self.trackHelper = trackHelper
        
        //Start the location services
        locationService.startUpdatingUserHeading()
        locationService.startUpdatingUserLocation()
        
        //TODO: Check to see if we have a current active track in CoreData?
        
        super.init()
        
    }
    
    /**
     Called by the UI layer to update the recording state. This abstracts all of the business logic away from the views and keeps the View layer clean by needing fewer if... statements.
     Calling this updates the currentActiveRecordingState @Published var which the UI can subscribe to to stay in sync.
     */
    public func updateRecordingState() {
        switch self.currentRecordingState {
        case .recording:
            self.pauseRecording()
        case .stopped:
            self.createNewActiveTrack()
        case .disabled:
            print("Recording disabled")
        case .paused:
            self.resumeRecording()
        case .error:
            print("Error starting new recording")
        }
    }
    
    /**
     Creates a new track in the Core Data store. If successfull the track will begin recording. If there is an error, the currentRecordingState is updated so the UI
     can reflect this change to the user in the UI.
     */
    public func createNewActiveTrack(name:String? = nil) {
        
        do {
            let track = try trackHelper.startNewTrack(name: name)
            self.currentActiveTrack = ActiveTrack(track: track, context: trackHelper.viewContext)
            self.startRecordingTrack()
            self.currentRecordingState = .recording
        } catch {
            self.currentRecordingState = .error
        }
    }
    
    /**
     Resumes recording the surrecnt track.
     */
    public func resumeRecording() {
        
        if self.currentActiveTrack.exists() {
            self.currentRecordingState = .recording
            self.startRecordingTrack()
        }else{
            self.currentRecordingState = .error
        }
        
    }
    
    /**
     Pauses the surrecnt track.
     */
    public func pauseRecording() {
        
        do {
            if self.currentActiveTrack.exists() {
                self.currentRecordingState = .paused
                try self.currentActiveTrack.endTrackSegment()
                self.emptyCancellables()
            }else{
                self.currentRecordingState = .error
            }
        } catch {
            
            self.currentRecordingState = .error
        }
        
    }
    
    /**
     Ends the surrecnt track.
     */
    public func endTrack() {
        if self.currentActiveTrack.exists() {
            self.resetActiveTrack()
        }
    }
    
    /**
     If the recorder is active, this captures the location data from the Core Location publisher and adds it to the track.
     */
    func captureLocation(location:CLLocation) {
        do {
            try self.currentActiveTrack.addLocation(location: location)
        } catch {
            self.currentRecordingState = .error
        }
    }
    
}

private extension LocationRecorder {
    
    func resetActiveTrack() {
        self.currentActiveTrack = ActiveTrack()
        self.currentRecordingState = .stopped
    }
    
    /**
     Starts recording a new track and starts the location publisher
     */
    func startRecordingTrack() {
        
        locationService.$currentLocation.sink { location in
            self.captureLocation(location: location)
        }.store(in: &cancellables)
        
    }
    
    /**
     Clears the cancellables and stops the publisher.
     */
    func emptyCancellables() {
        cancellables.removeAll()
    }
    
}
