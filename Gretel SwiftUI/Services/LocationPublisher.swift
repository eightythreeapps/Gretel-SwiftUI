//
//  LocationPublisher.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/10/2022.
//

import Foundation
import CoreLocation
import Combine

extension CLLocationManager {
    
    public static func publishLocation() -> LocationPublisher {
        return .init()
    }
    
    public struct LocationPublisher: Publisher {
        
        public typealias Output = CLLocation
        public typealias Failure = Error
        
        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, CLLocation == S.Input {
            let subscription = LocationSubscription(subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
        
        final class LocationSubscription<S:Subscriber> : NSObject, CLLocationManagerDelegate, Subscription where S.Input == Output, S.Failure == Failure {
            
            var subscriber: S
            var locationManager = CLLocationManager()
            
            init(subscriber: S) {
                self.subscriber = subscriber
                super.init()
                
                locationManager.activityType = .other
                locationManager.showsBackgroundLocationIndicator = true
                locationManager.headingFilter = 100.0
                locationManager.desiredAccuracy = 100.0
                locationManager.startUpdatingHeading()
                
                locationManager.delegate = self
            }
            
            func request(_ demand: Subscribers.Demand) {
                locationManager.startUpdatingLocation()
            }
            
            func cancel() {
                locationManager.stopUpdatingLocation()
            }
            
            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                for location in locations {
                    _ = subscriber.receive(location)
                }
            }
            
        }
        
    }
    
}
