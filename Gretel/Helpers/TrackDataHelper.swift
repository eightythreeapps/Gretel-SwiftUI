//
//  TrackHelper.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/10/2022.
//

import Foundation
import CoreData
import Combine

public class TrackDataHelper {
    
    private var viewContext:NSManagedObjectContext
    
    required init(viewContext:NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    public func startNewTrack(name:String? = nil) throws -> Track {
        
        let now = Date()
       
        //TODO: Update these to read from device locale
        let sectionKey = now.toFormat("EEEE dd MMM yyyy")
        let trackName = now.toFormat("dd MMM yyyy HH:mm:ss")
        
        let track = Track.init(context: self.viewContext)
        track.formattedCreated = sectionKey
        track.name = name != nil ? name : trackName
        track.startDate = now
        
        do {
            try track.save()
            return track
        } catch {
            throw error
        }
        
    }
    
    public func endCurrentRecording(track:Track) throws {
        
        track.endDate = Date()
        track.isRecording = false
        
        do {
            try track.save()
        } catch {
            throw error
        }
        
    }

    //Update this to thow a custom error
    func getCurrentActiveTrack() -> Track? {
        
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isRecording == true")
        
        var activeTrack:Track?
        
        do {
            let results = try self.viewContext.fetch(fetchRequest)
            if let track = results.first {
                activeTrack = track
            }
        } catch {
            print("Could not fetch active track")
        }
        
        return activeTrack
        
    }
    
}

