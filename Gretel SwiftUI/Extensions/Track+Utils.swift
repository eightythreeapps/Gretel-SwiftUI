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

enum SortOrder {
    case ascending
    case descending
}

extension Track {
    
    func trackName() -> String {
        
        if let name = self.name {
            return name
        }
        
        return "Untitled"
    }
    
    func totalDistanceInMeters() -> Double {
        
        var distance:Double = 0
        
        let points = getAllPoints(orderBy: .descending)
        
        if let firstPoint = points.first, let lastPoint = points.last {
            distance = getDistanceBetween(pointA: firstPoint, pointB: lastPoint)
        }
        
        return distance
        
    }
    
    func totalDurationInMillis() -> Double {
        
        var interval:Double = 0
        
        let points = getAllPoints(orderBy: .descending)
        
        do {
            if let firstPoint = points.first, let lastPoint = points.last {
                interval = try getInterval(from: firstPoint, to: lastPoint)
            }
        } catch {
            print("Error calculating interval")
        }
        
        return interval
    }
    
    func pointsCount() -> Int {
        
        var count = 0
        
        if let segments = self.trackSegments?.allObjects as? [TrackSegment] {
            
            for segment in segments {
                count += segment.trackPoints?.count ?? 0
            }
        }
    
        return count
        
    }
    
    func startRecording() -> Future<Bool, Error> {
        return Future { promise in
            
            guard let context = self.managedObjectContext else {
                promise(.failure(DataError.noContextAvailable))
                return
            }
            
            self.isRecording = true
            
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
        
        let segments = trackSegments?.allObjects as? [TrackSegment]
        
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
    
    func addPointToSegment(segment:TrackSegment, latitude:Double, longitude:Double) {
      
        if let moc = self.managedObjectContext {

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
    
    private func getDistanceBetween(pointA:TrackPoint, pointB:TrackPoint) -> Double {
        
        let startLocation = CLLocation(latitude: pointA.latitude,
                                  longitude: pointA.longitude)
        
        let endLocation = CLLocation(latitude: pointB.latitude,
                                     longitude: pointB.longitude)
        
        let distance = endLocation.distance(from: startLocation)
        
        return distance
        
    }
    
    private func getInterval(from:TrackPoint, to:TrackPoint) throws -> TimeInterval {
        
        guard let firstPointDate = from.time else {
            throw TrackDataServiceError.invalidTrackPointDate
        }
        
        guard let lastPointDate = to.time else {
            throw TrackDataServiceError.invalidTrackPointDate
        }
        
        return lastPointDate.timeIntervalSince(firstPointDate)
    }
    
    private func getAllPoints(orderBy:SortOrder) -> [TrackPoint] {
        
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
}
