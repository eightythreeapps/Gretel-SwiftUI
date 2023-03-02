//
//  IOService.swift
//  Gretel
//
//  Created by Ben Reed on 27/02/2023.
//

import SwiftUI
import Combine
import CoreGPX

public enum ExportFormat {
    case gpx
}

class IOService: ObservableObject {
    public func export(track:Track, toFormat format:ExportFormat) {
        
        switch format {
            
        case .gpx:
            self.exportAsGPXFile(track: track)
        }
        
    }
}


private extension IOService {
    
    func exportAsGPXFile(track:Track) {
        
        let gpxTrack = GPXTrack()
        
        guard let segments = track.trackSegments else {
            return
        }
        
        for case let segment as TrackSegment in segments  {
            
            let gpxSegment = GPXTrackSegment()
            
            guard let trackPoints = segment.trackPoints?.allObjects as? [TrackPoint] else {
                return
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
            return
        }
        
        writeToFile(data: gpxData)
        
    }

    func writeToFile(data:Data) {
        
        let documentsDir = getDocumentsDirectory()
        let filePath = documentsDir.appendingPathComponent("GPXFile")
    
        do {
            try data.write(to: filePath)
        } catch {
            print(error)
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
        
    }
    
}
