//
//  TrackDataServiceError.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 09/02/2023.
//

import Foundation

enum TrackDataServiceError:Error {
    case noContext
    case noActiveTrack
    case noActiveSegment
    case invalidTrackPointDate
    case rethrow(error:Error)
    case saveError(error:Error)
}
