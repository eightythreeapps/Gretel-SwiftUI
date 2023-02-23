//
//  LocationRecorderProvider.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 09/02/2023.
//

import Foundation
import CoreLocation

public protocol LocationRecorderProvider {
    var currentRecordingState:RecordingState { get set }
    var currentActiveTrack:MonitorableTrack? { get set }
    
    func updateRecordingState()
    func createNewActiveTrack(name:String?)
    func resumeRecording()
    func pauseRecording()
    func endTrack()
    func captureLocation(location:CLLocation)
}
