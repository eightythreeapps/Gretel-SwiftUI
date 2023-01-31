//
//  TrackHelper.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/10/2022.
//

import Foundation
import CoreData
import Combine

public protocol CoreDataTrackService {
    
    
    
}

public class TrackDataService:CoreDataTrackService {
    
    private var viewContext:NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    
    @Published var allTracks:[Track] = [Track]()
    
    required init(viewContext:NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    
    var fetchRequest: NSFetchRequest<Track> {
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false
        
        return fetchRequest
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
            
            let trackSegment = TrackSegment.init(context: self.viewContext)
            trackSegment.time = now
            
            track.addToTrackSegments(trackSegment)
            
            do {
                try self.viewContext.save()
                promise(.success(track))
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                promise(.failure(error))
            }
            
        }
            
    }
    
    func endCurrentRecording() -> Future<Bool, Never> {
        
        return Future { promise in
            
            self.getCurrentActiveTrack().sink { completion in
                print("Completed")
            } receiveValue: { track in
                if let track = track {
                    track.endDate = Date()
                    track.isRecording = false
                }
            }.store(in: &self.cancellables)

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
    
    func addPointToSegment(latitude:Double, longitude:Double) {
        
        self.getCurrentActiveTrack().sink { completion in
            print("Active Track loaded")
        } receiveValue: { track in
            
            if let activeTrack = track, let activeSegment = activeTrack.getActiveSegment() {
                
                let trackPoint = TrackPoint(context: self.viewContext)
                trackPoint.latitude = latitude
                trackPoint.longitude = longitude
                trackPoint.time = Date()
                
                activeSegment.addToTrackPoints(trackPoint)
                
                do {
                    try self.viewContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
            }else{
                print("Could not get active track segment")
            }
            
        }.store(in: &cancellables)
        
    }
    
}
