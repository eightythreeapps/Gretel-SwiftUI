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

public protocol MonitorableTrack {
    
    var track:Track? { get set }
    var unitFormatter:UnitFormatter { get set }
    var settingsService:SettingsService { get set }
    var pointsCountDisplay:String { get set }
    var durationDisplay:String { get set }
    var distanceDisplay:String { get set }
    var totalDuration:TimeInterval { get set }
    
    func endTrackSegment() throws
    func addLocation(location:CLLocation) throws
    func nameDisplay() -> String
    
}

class ActiveTrack: MonitorableTrack {
    
    var track:Track?
    var unitFormatter:UnitFormatter
    var settingsService:SettingsService
    var pointsCountDisplay:String = ""
    var durationDisplay:String = ""
    var distanceDisplay:String = ""
    var totalDuration:TimeInterval = 0
    
    private var cancellables = Set<AnyCancellable>()
    private var displayTimer:Timer?
    
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
     Returns a formatted string representing the track title
     - Returns: The track name value as a `String`.
     */
    func nameDisplay() -> String {
        return self.track?.trackName() ?? ""
    }
    
    
}

private extension ActiveTrack {
    
    func startDisplayTimer() {
        
    }
    
    func pauseDisplayTimer() {
        
    }
    
    func endDisplayTimer() {
        
    }
    
    func startMonitoringSettings() {
        settingsService.$unitType.sink { unitType in
            self.updateDisplay()
        }.store(in: &cancellables)
    }
    
    func updateDisplay() {
        
        self.pointsCountDisplay = formattedPointsDisplayCount(count: self.track?.pointsCount() ?? 0)
        self.durationDisplay    = formatDurationDisplay(interval: self.track?.totalDurationInMillis() ?? 0)
        self.distanceDisplay    = formatDistanceDisplay(meters: self.track?.totalDistanceInMeters() ?? 0)
        
    }
    
    /**
     Returns a formatted string representing the current number of recorded points across all track segments
     - Parameters:
        - count: `Int` value of the count of points
     - Returns: The int value as a `String`.
     */
    func formattedPointsDisplayCount(count:Int) -> String {
        return "\(count)"
    }
    
    /**
     Returns a formatted string representing the total elapsed time the track has been active for.
     - Returns: The duration value as a `String`.
     */
    func formatDurationDisplay(interval:TimeInterval) -> String {
        let displayTime = interval.toClock(zero: [.pad, .dropLeading])
        return displayTime
    }
    
    /**
     Returns a formatted string representing the total elapsed time the track has been active for.
     - Returns: The duration value as a `String`.
     */
    func formatDistanceDisplay(meters:Double) -> String {
        
        let formattedDistance = self.unitFormatter.formatDistance(distanceInMetres: meters, granularity: .large)
        return formattedDistance
    }
}
