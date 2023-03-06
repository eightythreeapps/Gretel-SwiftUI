//
//  IOService.swift
//  Gretel
//
//  Created by Ben Reed on 27/02/2023.
//

import SwiftUI
import Combine
import CoreGPX

public enum IOHelperError:Error {
    case exportError
}

public enum ExportFormat {
    case gpx
}

public enum IOServiceState {
    case exporting
    case success
    case error
    case inactive
}

class IOService: ObservableObject {
    
    @Published var state:IOServiceState = .inactive
    @Published var shareabledata:Data?
    

    init(state: IOServiceState) {
        self.state = state
    }
    
}

class GPXFile:Transferable {
    
    private var track:Track
    
    init(track: Track) {
        self.track = track
    }
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .xml) { xmlFile in
            SentTransferredFile(try! xmlFile.fileURL())
        }
    }
    
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
        
    }
    
    func fileURL() throws -> URL {
        
        let documentsDir = getDocumentsDirectory()
        let filePath = documentsDir.appendingPathComponent("GPXFile").appendingPathExtension("gpx")
        
        do {
            let data = asData()
            try data?.write(to: filePath)
            return filePath
        } catch {
            throw IOHelperError.exportError
        }
        
    }

    
    func asData() -> Data? {
        
        let gpxTrack = GPXTrack()
        
        guard let segments = track.trackSegments else {
            return nil
        }
        
        for case let segment as TrackSegment in segments  {
            
            let gpxSegment = GPXTrackSegment()
            
            guard let trackPoints = segment.trackPoints?.allObjects as? [TrackPoint] else {
                return nil
            }
            
            let sortedPoints = trackPoints.sorted {
                $0.time! < $1.time!
            }
            
            for case let trackPoint in sortedPoints  {
                let gpxPoint = GPXTrackPoint(latitude: trackPoint.latitude, longitude: trackPoint.longitude)
                gpxSegment.add(trackpoint: gpxPoint)
            }
            gpxTrack.add(trackSegment: gpxSegment)
            
        }
        
        guard let gpxData = gpxTrack.gpx().data(using: .utf8) else {
            return nil
        }
        
        return gpxData
        
    }
    
}



