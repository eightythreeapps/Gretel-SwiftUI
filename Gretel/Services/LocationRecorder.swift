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
    
    private var viewContext:NSManagedObjectContext
    
    private var timerFormatter:DateComponentsFormatter = {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        
        return formatter
    }()
    
    @Published public var state:RecordingState = .stopped
    @Published public var elapsedTimeDisplay:String = "0h 0m 0s"
    @Published public var track:Track? = nil
    
    /**
     Initialises a new instance of LocationRecorder service. This is not a singleton, but there should only ever be one instance crearted when the app starts up.
     - parameters:
        - locationService: An instance of LocationService
        - settingsService: An instance of SettingsService
        - trackHelper: An instance with TrackDataService
     */
    required public init(locationService:LocationService, settingsService:SettingsService, viewContext:NSManagedObjectContext) {
        
        //Assign dependencies
        self.locationService = locationService
        self.settingsService = settingsService
        self.viewContext = viewContext
        
        //Start the location services
        locationService.startUpdatingUserHeading()
        locationService.startUpdatingUserLocation()
    
        super.init()
        
    }
        
    //MARK: Track preparation methods
    /**
     Prepares a `Track` object for recording. If this method is supplied with a trackId from an existing track, the name parameter will be ignored.
     - parameters:
        - trackId: The identifier of the track object to be loaded
        - name: The name of a new track object as set by the user. If this is left as `nil` the track will be named using the current date.
     */
    func prepareToRecord(trackId:UUID? = nil, name:String? = nil) {
        
        if let trackId = trackId {
            self.track = loadExistingTrack(uuid: trackId)
        }else {
            if let track = createNewTrack(name: name) {
                self.track = track
            }else{
                self.state = .error
            }
        }
        
    }
    
    /**
     Deletes a track from the data store
     - parameters:
        - trackId: The identifier of the track object to be deleted
     */
    func deleteTrack(trackId:UUID) {
        
        if let track = self.loadExistingTrack(uuid: trackId) {
            self.viewContext.delete(track)
            do {
                try self.viewContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: Recording control methods
    /**
     Starts the recording process. This will create a suscriber to listen to the location manager updates and commit them to the track object.
     */
    func startRecording() {
        
        if self.track != nil {
            self.track?.isRecording = true
            do {
                self.state = .recording
                self.track?.isRecording = true
                try self.track?.save()
                self.startListeningForLocationUpdates()
            } catch {
                print(error)
                self.state = .error 
            }
            
        }
        
    }
    
    /**
     Ends the current recording, cleans up the recorder state and resets all timers and subscribers,
     */
    func endRecording() {
        
        do {
            try self.track?.end()
            self.state = .stopped
            self.resetTimer()
            self.track = nil
            
        } catch {
            self.state = .error
        }
        
    }
    
    /**
     Stops the recorder from listening to location updates until it is restarted. All timers are paused and the `Track` object is left intact.
     */
    func pauseRecording() {
        self.state = .paused
        self.pauseTimer()
    }
    
    /**
     Cleans up a track that has not been started. If a track has been initialised and not started then it is not required so this method
     can be called to clean up and reset the recorder ready for a new track to begin.
     */
    func cleanUp() {
        
        if let track = self.track, let trackId = track.id {
            if !track.isRecording {
                self.track = nil
                self.deleteTrack(trackId: trackId)
                self.state = .stopped
            }
        }
        
    }
    
}

private extension LocationRecorder {
    
    /**
     Helper method to load an existing track object from the data store
     - parameters:
        - trackId: The identifier of the track object to be loaded
     */
    func loadExistingTrack(uuid:UUID) -> Track? {
        
        let request = Track.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid.uuidString)
        
        do {
            
            let results = try self.viewContext.fetch(request)
            if let track = results.first {
                return track
            }
            
        } catch {
            print(error)
        }
        
        return nil

    }
    
    func createNewTrack(name:String?) -> Track? {
        do {
            let track = try Track.newInstance(name: name, context: self.viewContext)
            return track
        } catch {
            print(error)
            self.state = .error
            return nil
        }
    }
    
    /**
     If the recorder is active, this captures the location data from the Core Location publisher and adds it to the track.
     */
    func captureLocation(location:CLLocation) {
        if self.track != nil {
            do {
                print("Adding location to track segment")
                try self.track?.addLocation(location: location)
            } catch {
                self.state = .error
            }
        }
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
    
    func stopListeningForLocationUpdates() {
        self.emptyCancellables()
        self.pauseTimer()
    }
    
    /**
     Clears the cancellables and stops the publisher.
     */
    func emptyCancellables() {
        cancellables.removeAll()
    }
    
}
