//
//  HeadingPublisher.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 20/10/2022.
//

import Foundation
import CoreLocation
import Combine

extension CLLocationManager {
    
    public func publishHeading() -> HeadingPublisher {
        return .init()
    }
    
    public struct HeadingPublisher: Publisher {
        
        public typealias Output = CLHeading
        public typealias Failure = Error
        
        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, CLHeading == S.Input {
            let subscription = HeadingSubscription(subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
        
        final class HeadingSubscription<S:Subscriber> : NSObject, CLLocationManagerDelegate, Subscription where S.Input == Output, S.Failure == Failure {
            
            var subscriber: S
            var locationManager = CLLocationManager()
            
            init(subscriber: S) {
                self.subscriber = subscriber
                super.init()
                
                locationManager.activityType = .other
                locationManager.showsBackgroundLocationIndicator = true
                locationManager.headingFilter = 100.0
                locationManager.desiredAccuracy = 100.0
                locationManager.delegate = self
            }
            
            func request(_ demand: Subscribers.Demand) {
                locationManager.startUpdatingHeading()
            }
            
            func cancel() {
                locationManager.stopUpdatingHeading()
            }
            
            func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
                _ = subscriber.receive(newHeading)
            }
            
        }
        
    }
    
}
