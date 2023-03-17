//
//  Track+Utils.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 11/11/2022.
//

import Foundation
import Combine
import SwiftDate
import CoreLocation
import CoreData

enum SortOrder {
    case ascending
    case descending
}

extension Track {
    
    static var dateFormatter:DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMM yyyy"
        return dateFormatter
    }
    
    @objc
    var sectionSortKey:String {
        let dateString = Track.dateFormatter.string(from: self.startDate!)
        return dateString
    }
    
    static func newInstance(name:String? = nil, context:NSManagedObjectContext) throws -> Track {
        
        let now = Date()
       
        //TODO: Update these to read from device locale
        let trackName = now.toFormat("dd MMM yyyy HH:mm")
        
        let track = Track(context: context)
        track.name = name != nil ? name : trackName
        track.startDate = now
        
        do {
            try track.save()
            return track
        } catch {
            throw error
        }
        
    }
    
    static func getInterval(from:TrackPoint, to:TrackPoint) throws -> TimeInterval {
        
        guard let firstPointDate = from.time else {
            throw TrackDataServiceError.invalidTrackPointDate
        }
        
        guard let lastPointDate = to.time else {
            throw TrackDataServiceError.invalidTrackPointDate
        }
        
        return lastPointDate.timeIntervalSince(firstPointDate).rounded()
    }
    
    func displayName() -> String {
        return self.name ?? "No name"
    }
    
    func getDistanceBetween(pointA:TrackPoint, pointB:TrackPoint) -> Double {
        
        let startLocation = CLLocation(latitude: pointA.latitude,
                                  longitude: pointA.longitude)
        
        let endLocation = CLLocation(latitude: pointB.latitude,
                                     longitude: pointB.longitude)
        
        let distance = endLocation.distance(from: startLocation)
        
        return distance
        
    }
    
    
    
    func getAllPoints(orderBy:SortOrder) -> [TrackPoint] {
        
        var trackPoints = [TrackPoint]()
        
        guard let trackSegments = self.trackSegments?.allObjects as? [TrackSegment] else {
            return trackPoints
        }
        
        for segment in trackSegments {
            if let points = segment.trackPoints?.allObjects as? [TrackPoint] {
                trackPoints.append(contentsOf: points)
            }
        }
        
        trackPoints.sort { a, b in
            
            if orderBy == .descending {
                return a.time!.isBeforeDate(b.time!, granularity: .second)
            }else{
                return a.time!.isAfterDate(b.time!, granularity: .second)
            }

        }
        
        return trackPoints
    }
    
    func totalDistanceInMeters() -> Double {
        
        var distance:Double = 0
        
        let points = getAllPoints(orderBy: .descending)
        if let firstPoint = points.first, let lastPoint = points.last {
            distance = getDistanceBetween(pointA: firstPoint, pointB: lastPoint)
        }
        
        return distance
        
    }
    
    func totalDuration() -> Double {
        
        var interval:Double = 0
        
        let points = getAllPoints(orderBy: .descending)
        
        do {
            if let firstPoint = points.first, let lastPoint = points.last {
                interval = try Track.getInterval(from: firstPoint, to: lastPoint)
            }
        } catch {
            print("Error calculating interval")
        }
        
        return interval
    }
    
    func pointsCount() -> Int {
        
        var count = 0
        
        if let segments = trackSegments?.allObjects as? [TrackSegment] {
            
            for segment in segments {
                count += segment.trackPoints?.count ?? 0
            }
        }
    
        return count
        
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
    
    func addPointToSegment(segment:TrackSegment, latitude:Double, longitude:Double) {
      
        if let moc = self.managedObjectContext {

            let trackPoint = TrackPoint(context: moc)
            trackPoint.latitude = latitude
            trackPoint.longitude = longitude
            trackPoint.time = Date()

            segment.addToTrackPoints(trackPoint)

            do {
                try self.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }

        }
        
    }
    
    func getActiveSegment() throws -> TrackSegment {
        
        let segments = self.trackSegments?.allObjects as? [TrackSegment]
        
        if let activeSegment = segments?.first(where: {$0.isActiveSegment == true }) {
            
            return activeSegment
            
        }else{
            
            if let context = self.managedObjectContext {
                let segment = TrackSegment(context: context)
                segment.time = Date()
                segment.isActiveSegment = true
                
                self.addToTrackSegments(segment)
                return segment
            }else{
                throw TrackDataServiceError.noContext
            }
            
        }
        
    }
    
    public func start() throws {
        
        do {
            self.isRecording = true
            try self.save()
        } catch {
            throw error
        }
        
    }
    
    public func end() throws {
        
        self.endDate = Date()
        self.isRecording = false
        
        do {
            try self.save()
        } catch {
            throw error
        }
        
    }
    
}
