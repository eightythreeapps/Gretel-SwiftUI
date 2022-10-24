//
//  LocationPublisher.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/10/2022.
//

import Foundation
import CoreLocation
import Combine

public struct LocationPublisherConfig {
    var activityType:CLActivityType
    var desiredAccuracy:CLLocationAccuracy
    var headingFilter:CLLocationDegrees
    
}

extension CLLocationManager {
       
    public func publishLocation(configuration:LocationPublisherConfig) -> LocationPublisher {
        return .init(configuration: configuration)
    }
    
    public struct LocationPublisher: Publisher {
        
        public typealias Output = CLLocation
        public typealias Failure = Error
        
        private var config:LocationPublisherConfig
        
        init(configuration:LocationPublisherConfig) {
            self.config = configuration
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, CLLocation == S.Input {
            let subscription = LocationSubscription(subscriber: subscriber, config: self.config)
            subscriber.receive(subscription: subscription)
        }
        
        final class LocationSubscription<S:Subscriber> : NSObject, CLLocationManagerDelegate, Subscription where S.Input == Output, S.Failure == Failure {
            
            var subscriber: S
            var locationManager:CLLocationManager
            var config:LocationPublisherConfig
            
            init(subscriber: S, config:LocationPublisherConfig) {
                self.subscriber = subscriber
                self.config = config
                self.locationManager = CLLocationManager()
                
                super.init()
                
                checkLocationAuthorisationStatus()
                
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
            
            private func configureLocationManager(config:LocationPublisherConfig) {
                
                locationManager.activityType = config.activityType
                locationManager.showsBackgroundLocationIndicator = true
                locationManager.headingFilter = config.headingFilter
                locationManager.desiredAccuracy = config.desiredAccuracy
                locationManager.startUpdatingHeading()
                
                locationManager.delegate = self
                
            }
            
            private func checkLocationAuthorisationStatus() {
                
                switch locationManager.authorizationStatus {
                    
                case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                case .restricted:
                    debugPrint("Access to your location is restricted. Likely parental controls or MDM.")
                case .denied:
                    debugPrint("Access to your location is DENIED. Enable it in settings.")
                case .authorizedAlways, .authorizedWhenInUse:
                    configureLocationManager(config: self.config)
                    break
                @unknown default:
                    break
                }
            }
            
            func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
                checkLocationAuthorisationStatus()
            }
            
        }
        
    }
    
}
