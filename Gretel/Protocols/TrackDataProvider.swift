//
//  TrackDataProvider.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 09/02/2023.
//

import Foundation

public protocol TrackDataProvider {
    
    var allTracks:[Track] { get set }
    
    func startNewTrack(name:String?) throws -> Track
    func endCurrentRecording(track:Track) throws
    
}
