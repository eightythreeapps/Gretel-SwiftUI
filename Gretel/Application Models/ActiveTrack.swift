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

public class ActiveTrack: ObservableObject {
    
    @Published var totalPointsCount:Int = 0
    @Published var totalDurationSeconds:Double = 0
    @Published var totalDistanceMetres:Double = 0
    
    var track:Track?
    
    private var cancellables = Set<AnyCancellable>()
    init(track: Track? = nil) {
        self.track = track
    }
    
    /**
     Ends a track sgement.
     This should be called whenever:
        - The user pauses a track
        - The GPS signal is lost and the track stops updating
     
     A new track segment should be started if the track is resumed.
     */
    func endTrackSegment() throws {
        
        do {
            let currentActiveSegment = try getActiveSegment()
            currentActiveSegment.isActiveSegment = false
            
            try currentActiveSegment.save()
        } catch {
            throw TrackDataServiceError.noActiveTrack
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
        
            let segment = try self.getActiveSegment()
            
            self.addPointToSegment(segment: segment,
                                          latitude: location.coordinate.latitude,
                                          longitude: location.coordinate.longitude)
        } catch {
            throw TrackDataServiceError.rethrow(error: error)
        }
    
    }
    
    /**
     Returns a formatted string representing the track title
     - Returns: The track name value as a `String`.
     */
    func nameDisplay() -> String {
        if let name = self.track?.name {
            return name
        }
        
        return "Untitled"
    }
    
    func readyToRecord() -> Bool {
        return self.track != nil
    }
    
    func startRecording() -> Future<Bool, Error> {
        
        return Future { promise in
            
            guard let context = self.track?.managedObjectContext else {
                promise(.failure(DataError.noContextAvailable))
                return
            }
            
            self.track?.isRecording = true
            
            do {
                try context.save()
                promise(.success(true))
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                promise(.success(false))
            }
            
        }
    }
 
    func getActiveSegment() throws -> TrackSegment {
        
        let segments = self.track?.trackSegments?.allObjects as? [TrackSegment]
        
        if let activeSegment = segments?.first(where: {$0.isActiveSegment == true }) {
            
            return activeSegment
            
        }else{
            
            if let context = self.track?.managedObjectContext {
                let segment = TrackSegment(context: context)
                segment.time = Date()
                segment.isActiveSegment = true
                
                self.track?.addToTrackSegments(segment)
                return segment
            }else{
                throw TrackDataServiceError.noContext
            }
            
        }
        
    }
    
    func addPointToSegment(segment:TrackSegment, latitude:Double, longitude:Double) {
      
        if let moc = self.track?.managedObjectContext {

            let trackPoint = TrackPoint(context: moc)
            trackPoint.latitude = latitude
            trackPoint.longitude = longitude
            trackPoint.time = Date()

            segment.addToTrackPoints(trackPoint)

            do {
                try moc.save()
                print("Point added to segment")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }

        }
        
    }
    
}
