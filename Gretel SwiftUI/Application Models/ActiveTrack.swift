//
//  ActiveTrack.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 02/02/2023.
//

import Foundation
import CoreLocation
import CoreData

struct ActiveTrack {
    
    var track:Track?
    var context:NSManagedObjectContext?
    var pointsCountDisplay:String = ""
    var durationDisplay:String = ""
    var totalDuration:TimeInterval = 0
    
    /**
     Ends a track sgement.
     This should be called whenever:
        - The user pauses a track
        - The GPS signal is lost and the track stops updating
     
     A new track segment should be started if the track is resumed.
     */
    mutating func endTrackSegment() throws {
     
        guard let track = self.track else {
            throw TrackDataServiceError.noActiveTack
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
    mutating func startTrackSegment() throws {
        
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
    mutating func addLocation(location:CLLocation) throws {
    
        do {
            
            let segment = try self.track?.getActiveSegment()
            
            //TODO: See if this can be refactored to remove the force unwrap
            self.track?.addPointToSegment(segment: segment!,
                                          latitude: location.coordinate.latitude,
                                          longitude: location.coordinate.longitude)
            
            self.pointsCountDisplay = updatePointsDisplayCount(count: self.track?.pointsCount() ?? 0)
            self.durationDisplay = updateDurationDisplay(interval: self.track?.totalDurationInMillis() ?? 0)
            
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
     Returns a formatted string representing the track title
     - Returns: The track name value as a `String`.
     */
    func nameDisplay() -> String {
        return self.track?.trackName() ?? ""
    }
    
    /**
     Helper function to check if there is an active Track object to persist data to.
     This is here to give a concrete boolean response so we do not have to rely on optionals in the View layer.
     - Returns: A `bool` value.
     */
    func exists() -> Bool {
        
        if self.track == nil {
            return false
        }else{
            return true
        }
        
    }
    
}
