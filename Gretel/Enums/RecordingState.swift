//
//  RecordingState.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 25/10/2022.
//

import Foundation

public enum RecordingError:Error {
    case couldNotStartRecording
    case couldNotEndRecording
    case unknown
}

public enum RecordingState:Equatable {
    case stopped
    case recording
    case paused
    case error
}
