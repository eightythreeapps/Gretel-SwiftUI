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
    private var settingsService:SettingsService
    private var elapsedTime:TimeInterval = 0
    
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellables = Set<AnyCancellable>()
    
    private static let DefaultLatitude = 0.1276
    private static let DefaultLongitude = 51.5072
    private static let DefaultCoordinateSpanDelta = 0.1
    
    private var timerFormatter:DateComponentsFormatter = {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        
        return formatter
    }()
    
    /**
     Provides subscribeable access to the current recording state of the application.
     Users can interact with the UI to change the recording state and this class will need to act accordingly to process
     those changes, so there is an override of `didSet` that calls the `updateRecordingState()`
     */
    @Published public var state:RecordingState = .stopped {
        didSet {
            self.updateRecordingState()
        }
    }
    
    @Published public var elapsedTimeDisplay:String = "0h 0m 0s"
    @Published public var track:Track? = nil
    
    /**
     Initialises a new instance of LocationRecorder service. This is not a singleton, but there should only ever be one instance crearted when the app starts up.
     - parameters:
        - locationService: An instance of LocationService
        - settingsService: An instance of SettingsService
        - trackHelper: An instance with TrackDataService
     */
    required public init(locationService:LocationService, settingsService:SettingsService) {
        
        //Assign dependencies
        self.locationService = locationService
        self.settingsService = settingsService
        self.settingsService = settingsService
        
        //Start the location services
        locationService.startUpdatingUserHeading()
        locationService.startUpdatingUserLocation()
    
        super.init()
        
    }
    
    /**
     Called by the UI layer to update the recording state. This abstracts all of the business logic away from the views and keeps the View layer clean by needing fewer if... statements.
     Calling this updates the currentActiveRecordingState @Published var which the UI can subscribe to to stay in sync.
     */
    public func updateRecordingState() {
        switch self.state {
        case .recording:
            self.startRecording()
        case .stopped:
            self.endRecording()
        case .paused:
            self.pauseRecording()
        case .error:
            self.state = .error
        }
    }
    
    /**
     If the recorder is active, this captures the location data from the Core Location publisher and adds it to the track.
     */
    public func captureLocation(location:CLLocation) {
        
    }
    
}

private extension LocationRecorder {

    func startRecording() {
        //TODO: Start recording track
        print("Recording started")
    }
    
    func endRecording() {
        //TODO: Stop recording track
        print("Stopped recording")
    }
    
    func pauseRecording() {
        //TODO: Pause recording
        print("Recording paused")
    }
    
    
    func startTimer() {
        
        //Start the display timer going
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { timer in
                self.elapsedTime += 1
                self.updateTimerDisplay(elapsedTime: self.elapsedTime)
            }
            .store(in: &timerCancellables)
    }
    
    func updateTimerDisplay(elapsedTime:TimeInterval) {
        self.elapsedTimeDisplay = self.timerFormatter.string(from: elapsedTime) ?? "Error"
    }
    
    func pauseTimer() {
        timerCancellables.removeAll()
    }
    
    func resetTimer() {
        self.elapsedTime = 0
        self.updateTimerDisplay(elapsedTime: self.elapsedTime)
        timerCancellables.removeAll()
    }
    
    func startListeningForLocationUpdates() {
        
        locationService.$currentLocation.sink { location in
            self.captureLocation(location: location)
        }.store(in: &timerCancellables)
        
        startTimer()
    }
    
    
    /**
     Clears the cancellables and stops the publisher.
     */
    func emptyCancellables() {
        cancellables.removeAll()
    }
    
}
