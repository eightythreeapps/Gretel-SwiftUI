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

public final class LocationRecorderService:NSObject, ObservableObject {
    
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
    @Published public var currentRecordingState:RecordingState = .stopped {
        didSet {
            self.updateRecordingState()
        }
    }
    
    @Published public var elapsedTimeDisplay:String = "0h 0m 0s"
    @Published public var currentActiveTrack:ActiveTrack = ActiveTrack()
    
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
            self.startRecordingTrack()
        case .stopped:
            self.stopRecordingTrack()
        case .disabled:
            print("Recording disabled")
        case .paused:
            self.pauseRecording()
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
            let track = try Track.newInstance(context: PersistenceController.shared.container.viewContext)
            self.currentActiveTrack = ActiveTrack(track:track)
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
        
        if self.currentActiveTrack.state == .loaded {
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
        
        if self.currentActiveTrack.state == .recording {
            self.currentActiveTrack.pause()
            self.emptyCancellables()
            self.pauseTimer()
        }else{
            self.currentRecordingState = .error
        }
        
    }
    
    /**
     Ends the surrecnt track.
     */
    public func endTrack() {
        if self.currentActiveTrack.state == .recording {
            self.resetActiveTrack()
        }
    }
    
    /**
     If the recorder is active, this captures the location data from the Core Location publisher and adds it to the track.
     */
    public func captureLocation(location:CLLocation) {
        if self.currentActiveTrack.state == .recording {
            self.currentActiveTrack.addLocation(location: location)
        }
    }
    
}

private extension LocationRecorderService {
    
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
    
    /**
     Starts recording a new track and starts the location publisher
     */
    func startRecordingTrack() {
        
        //TODO: Bring this in line with the Active Track state enum
        if let track = self.currentActiveTrack.track {
            self.resumeTrack(track: track)
        }else{
            self.startNewTrack()
        }
                
    }
    
    func resumeTrack(track:Track) {
        self.startListeningForLocationUpdates()
    }
    
    func startListeningForLocationUpdates() {
        self.currentActiveTrack.startRecording()
        locationService.$currentLocation.sink { location in
            self.captureLocation(location: location)
        }.store(in: &timerCancellables)
        
        startTimer()
    }
    
    func startNewTrack() {
        //Start the track recording
        do {
            
            //TODO: Figure out dependency on moc
            let track = try Track.newInstance(context: PersistenceController.shared.container.viewContext)
            self.currentActiveTrack = ActiveTrack(track: track)
            self.currentActiveTrack.startRecording()
            
            self.startListeningForLocationUpdates()
            
        } catch {
            self.currentRecordingState = .error
        }
    }
    
    func stopRecordingTrack() {
        //TODO: Refactor this to the ActiveTrack class
        if let track = self.currentActiveTrack.track {
            resetRecorder(track: track)
        }
    }
    
    func resetRecorder(track:Track) {
        //TODO: end current track
        self.resetActiveTrack()
        self.resetTimer()
    }
    
    func resetActiveTrack() {
        self.currentActiveTrack = ActiveTrack()
        self.currentRecordingState = .stopped
    }
    
    /**
     Clears the cancellables and stops the publisher.
     */
    func emptyCancellables() {
        cancellables.removeAll()
    }
    
}
