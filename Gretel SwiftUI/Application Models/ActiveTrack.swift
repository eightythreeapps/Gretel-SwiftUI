//
//  ActiveTrack.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 02/02/2023.
//

import Foundation
import CoreLocation
import CoreData
import Combine

class ActiveTrack {
    
    var track:Track?
    var unitFormatter:UnitFormatter
    var settingsService:SettingsService
    var pointsCountDisplay:String = ""
    var durationDisplay:String = ""
    var distanceDisplay:String = ""
    var totalDuration:TimeInterval = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init(track: Track? = nil, unitFormatter: UnitFormatter, settingsService:SettingsService, pointsCountDisplay: String, durationDisplay: String, distanceDisplay: String, totalDuration: TimeInterval) {
        self.track = track
        self.unitFormatter = unitFormatter
        self.pointsCountDisplay = pointsCountDisplay
        self.durationDisplay = durationDisplay
        self.distanceDisplay = distanceDisplay
        self.totalDuration = totalDuration
        self.settingsService = settingsService
        
        self.startMonitoringSettings()
    }
    
    /**
     Ends a track sgement.
     This should be called whenever:
        - The user pauses a track
        - The GPS signal is lost and the track stops updating
     
     A new track segment should be started if the track is resumed.
     */
    func endTrackSegment() throws {
     
        guard let track = self.track else {
            throw TrackDataServiceError.noActiveTrack
        }
        
        let currentActiveSegment = try track.getActiveSegment()
        currentActiveSegment.isActiveSegment = false
        
        try currentActiveSegment.save()
        
    }
    
    /**
     Starts a new track segment.
     
     This shoudl be callled when:
        - A new track is started
        - An existing track is resumed
     
     - Throws:`TrackDataServiceError.rethrow(error: error)`
               Simply rethrows the existing Core Data error back up the chain.
     */
    func startTrackSegment() throws {
        
        do {
            let _ = try self.track?.getActiveSegment()
        } catch {
            throw TrackDataServiceError.rethrow(error: error)
        }
    
    }
    
    /**
     Adds a location to the current active segment
     
     This is called whenever a location update is ready to store against the track segment. This is coordinated by the Recorder Service, which is kept up to date
     by the LocationPublisher. If the recording state is set to 'recording' then this will be triggered.
     
     - Parameters:
        - location: A `CLLocation` object
     
     - Throws:`TrackDataServiceError.rethrow(error: error)`
               Simply rethrows the existing Core Data error back up the chain.
     */
    func addLocation(location:CLLocation) throws {
    
        do {
            
            guard let segment = try self.track?.getActiveSegment() else {
                if self.track == nil {
                    throw TrackDataServiceError.noActiveTrack
                }else{
                    throw TrackDataServiceError.noActiveSegment
                }
            }
            
            self.track?.addPointToSegment(segment: segment,
                                          latitude: location.coordinate.latitude,
                                          longitude: location.coordinate.longitude)
            
            self.updateDisplay()
            
        } catch {
            throw TrackDataServiceError.rethrow(error: error)
        }
    
    }
    
    /**
     Returns a formatted string representing the current number of recorded points across all track segments
     - Parameters:
        - count: `Int` value of the count of points
     - Returns: The int value as a `String`.
     */
    func updatePointsDisplayCount(count:Int) -> String {
        return "\(count)"
    }
    
    /**
     Returns a formatted string representing the total elapsed time the track has been active for.
     - Returns: The duration value as a `String`.
     */
    func updateDurationDisplay(interval:TimeInterval) -> String {
        let displayTime = interval.toClock(zero: [.pad, .dropLeading])
        return displayTime
    }
    
    /**
     Returns a formatted string representing the total elapsed time the track has been active for.
     - Returns: The duration value as a `String`.
     */
    func updateDistanceDisplay(meters:Double) -> String {
        
        let formattedDistance = self.unitFormatter.formatDistance(distanceInMetres: meters, granularity: .large)
        return formattedDistance
    }
    
    /**
     Returns a formatted string representing the track title
     - Returns: The track name value as a `String`.
     */
    func nameDisplay() -> String {
        return self.track?.trackName() ?? ""
    }
    
    func startMonitoringSettings() {
        settingsService.$unitType.sink { unitType in
            self.updateDisplay()
        }.store(in: &cancellables)
    }
    
    func updateDisplay() {
        
        self.pointsCountDisplay = updatePointsDisplayCount(count: self.track?.pointsCount() ?? 0)
        self.durationDisplay    = updateDurationDisplay(interval: self.track?.totalDurationInMillis() ?? 0)
        self.distanceDisplay    = updateDistanceDisplay(meters: self.track?.totalDistanceInMeters() ?? 0)
        
    }
}
