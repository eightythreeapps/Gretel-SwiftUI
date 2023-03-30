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

//public class ActiveTrack: ObservableObject {
//
//    @Published var totalPointsCount:Int = 0
//    @Published var totalDurationSeconds:Double = 0
//    @Published var totalDistanceMetres:Double = 0
//    @Published var state:ActiveTrackState = .noTrack
//
//    var track:Track?
//
//    private var cancellables = Set<AnyCancellable>()
//    init(track: Track? = nil) {
//        self.track = track
//    }
//
//    /**
//     Returns a formatted string representing the track title
//     - Returns: The track name value as a `String`.
//     */
//    func nameDisplay() -> String {
//        if let name = track?.displayName() {
//            return name
//        }
//
//        return "Untitled"
//    }
//
//    func addLocation(location:CLLocation) {
//        do {
//            try track?.addLocation(location: location)
//        } catch {
//
//            self.state = .error(error: .errorAddingLocation)
//        }
//    }
//
//    func startRecording() {
//        do {
//            try track?.start()
//            self.state = .recording
//        } catch {
//            self.state = .error(error: .errorStartingRecording)
//        }
//    }
//
//    func pause() {
//
//        do {
//            try self.track?.endTrackSegment()
//            self.state = .loaded
//        }catch {
//            self.state = .error(error: .errorPausing)
//        }
//
//    }
//
//}
