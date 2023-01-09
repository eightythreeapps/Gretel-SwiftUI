//
//  TrackHelper.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/10/2022.
//

import Foundation
import CoreData
import Combine

public class TrackHelper {
    
    private var viewContext:NSManagedObjectContext
    
    required init(viewContext:NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func createNewTrack(name:String? = nil) -> Future<Track?,Error> {
        
        return Future { promise in
         
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let trackName = dateFormatter.string(from: now)
            
            let track = Track.init(context: self.viewContext)
            track.name = name != nil ? name : trackName
            track.startDate = now
            track.isRecording = true
            
            do {
                try self.viewContext.save()
                promise(.success(track))
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                promise(.failure(error))
            }
            
        }
            
    }
    
    func getCurrentActiveTrack() -> Future<Track?,Error> {
        
        return Future { promise in
            
            let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isRecording == true")
            
            self.viewContext.perform {
                do {
                    let result = try fetchRequest.execute()
                    if let track = result.first {
                        promise(.success(track))
                    }
                } catch {
                    print("Unable to Execute Fetch Request, \(error)")
                    promise(.failure(error))
                }
            }
            
        }
        
    }
    
}
