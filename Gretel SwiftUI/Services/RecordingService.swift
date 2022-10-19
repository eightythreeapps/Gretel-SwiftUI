//
//  RecordingService.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/10/2022.
//

import Foundation
import CoreData
import CoreLocation
import Combine

public class RecordingService:ObservableObject {

    @Published var isUpdatingLocation = false
    
    
    private var cancellables = Set<AnyCancellable>()
    private var trackHelper:TrackHelper

    required init(trackHelper:TrackHelper) {
        self.trackHelper = trackHelper
    }
    
    func endTrip() {
        
    }
    
    public func startRecordingLocation() {
        
        isUpdatingLocation = true
        
        CLLocationManager.publishLocation().sink(
            receiveCompletion: { completion in
                // Called once, when the publisher was completed.
                print(completion)
            },
            receiveValue: { value in
                // Can be called multiple times, each time that a
                // new value was emitted by the publisher.
                print(value)
            }
        )
        .store(in: &cancellables)

    }
    
    public func stopRecordingLocation() {
        isUpdatingLocation = false
        cancellables.removeAll()
    }
    
}

private extension RecordingService {
    
}
