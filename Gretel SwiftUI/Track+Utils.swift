//
//  Track+Utils.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 11/11/2022.
//

import Foundation
import Combine

enum DataError: Error {
    case noContextAvailable
}

extension Track {
    
    func displayName() -> String {
        
        if let name = self.name {
            return name
        }
        
        return "No name"
    }
    
    func totalDistanceDisplay() -> String {
        return "10.0km"
    }
    
    func durationDisplay() -> String {
        return "2:04:23"
    }
    
    func pointsCountDisplay() -> String {
        return "1,244"
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
 
    func getActiveSegment() -> TrackSegment? {
        
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
            }
            
            return nil
            
        }
        
    }
    
}
