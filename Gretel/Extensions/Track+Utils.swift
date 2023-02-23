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
    
    func getInterval(from:TrackPoint, to:TrackPoint) throws -> TimeInterval {
        
        guard let firstPointDate = from.time else {
            throw TrackDataServiceError.invalidTrackPointDate
        }
        
        guard let lastPointDate = to.time else {
            throw TrackDataServiceError.invalidTrackPointDate
        }
        
        return lastPointDate.timeIntervalSince(firstPointDate)
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
        
        if let segments = trackSegments?.allObjects as? [TrackSegment] {
            
            for segment in segments {
                count += segment.trackPoints?.count ?? 0
            }
        }
    
        return count
        
    }
    
}