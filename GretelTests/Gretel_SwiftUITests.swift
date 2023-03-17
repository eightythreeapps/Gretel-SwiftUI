//
//  Gretel_SwiftUITests.swift
//  Gretel SwiftUITests
//
//  Created by Ben Reed on 15/09/2022.
//

import XCTest
import CoreData
import Combine
import SwiftDate
import CoreLocation
@testable import Gretel

class Gretel_SwiftUITests: XCTestCase {
    
    var viewContext:NSManagedObjectContext!
    var cancellables = Set<AnyCancellable>()

    let coreDataTimeout = 3.0
    let generatedLocationCount = 20
    
    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.viewContext = PersistenceController.init(inMemory: true).container.viewContext
   
        XCTAssertNotNil(self.viewContext, "ViewContext shold not be nil")
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.viewContext = nil
    }

    func testCreateNewTrackWithCustomName() throws {
        
        let trackName = "Test Track"
        
        do {
            let track = try Track.newInstance(name: trackName, context: self.viewContext)
            XCTAssertNotNil(track, "Track should not be nil")
            XCTAssertNotNil(track.startDate, "Start date should not be nil")
            XCTAssertNil(track.endDate, "End date should be nil")
            XCTAssertNotNil(track.name, "Track name should not be nil")
            XCTAssertNotNil(track.displayName(), "Display name should not be nil")
            XCTAssertTrue(track.displayName() == trackName, "Track name should equal user input")
        } catch {
            XCTFail("Failed to create new track object: \(error.localizedDescription)")
        }
        
    }
    
    func testCreateNewTrackWithDefaultName() throws {
    
        do {
            let track = try Track.newInstance(context: self.viewContext)
            XCTAssertNotNil(track, "Track should not be nil")
            XCTAssertNotNil(track.startDate, "Start date should not be nil")
            XCTAssertNil(track.endDate, "End date should be nil")
            XCTAssertNotNil(track.name, "Track name should not be nil")
            XCTAssertNotNil(track.displayName(), "Display name should not be nil")
            
        } catch {
            XCTFail("Failed to create new track object: \(error.localizedDescription)")
        }
        
    }
    
    func testDurationBetweenTrackPoints() {
        
        let trackPoint1 = TrackPoint(context: self.viewContext)
        trackPoint1.time = Date()
        
        let trackPoint2 = TrackPoint(context: self.viewContext)
        trackPoint2.time = Date() + 10.seconds
        
        do {
            let interval = try Track.getInterval(from: trackPoint1, to: trackPoint2)
            XCTAssertTrue(interval == 10)
        } catch {
            XCTFail("Could not calculate interval between points")
        }
        
    }
    
    func testDurationForTrack() {
        //TODO: Fix test to ensure a measurable amount of time can be tested.
//        do {
//            let track = try self.createAndPopulateTestTrack(locationCount: generatedLocationCount, addTimeDelayBetweenPoints: true)
//            let duration = track.totalDuration()
//            print(duration)
//            XCTAssertTrue(duration == Double(generatedLocationCount))
//        } catch {
//            XCTFail("Could not calculate interval between points")
//        }
        
    }
    
//    func testAscendingOrderingOfTrackPoints() {
//        do {
//
//            let track = try self.createAndPopulateTestTrack(locationCount: generatedLocationCount)
//            let trackPoints = track.getAllPoints(orderBy: .ascending)
//
//            let first = trackPoints.first
//            let last = trackPoints.last
//
//            let result = first!.time!.isAfterDate(last!.time!, granularity: .second)
//            XCTAssertTrue(result == true)
//
//        } catch {
//            XCTFail(error.localizedDescription)
//        }
//    }
//
//    func testDescendingOrderingOfTrackPoints() {
//        do {
//
//            let track = try self.createAndPopulateTestTrack(locationCount: generatedLocationCount)
//            let trackPoints = track.getAllPoints(orderBy: .descending)
//
//            let first = trackPoints.first
//            let last = trackPoints.last
//
//            let result = first!.time!.isBeforeDate(last!.time!, granularity: .second)
//            XCTAssertTrue(result == true)
//
//        } catch {
//            XCTFail(error.localizedDescription)
//        }
//    }
    
    func testPointsCount() {
        
        do {
            
            let track = try self.createAndPopulateTestTrack(locationCount: generatedLocationCount)
            XCTAssertTrue(track.getAllPoints(orderBy: .ascending).count == generatedLocationCount)
            
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
    func testAddNewSegement() {
        
        do {
            
            let track = try self.createAndPopulateTestTrack(locationCount: generatedLocationCount)
            try track.endTrackSegment()
            
            let _ = try track.getActiveSegment()
            
            XCTAssertTrue(track.trackSegments?.count == 2)
            
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
    func testOnlyOneActiveSegment() {
        
        do {
            
            let track = try self.createAndPopulateTestTrack(locationCount: generatedLocationCount)
            try track.endTrackSegment()
            
            var _ = try track.getActiveSegment()
            try track.endTrackSegment()
            
            _ = try track.getActiveSegment()
            try track.endTrackSegment()
            
            _ = try track.getActiveSegment()
            
            var activeSegmentCount = 0
            if let segments = track.trackSegments?.allObjects as? [TrackSegment] {
                XCTAssertTrue(segments.count == 4, "Four track segments should have been created")
                for segment in segments {
                    if segment.isActiveSegment == true {
                        activeSegmentCount+=1
                    }
                }
            }
    
            XCTAssertTrue(activeSegmentCount == 1, "There should only ever be one active segment per track")
            
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
    func testEndTrackSegment() {
        
        do {
            
            let track = try self.createAndPopulateTestTrack(locationCount: generatedLocationCount)
            XCTAssertTrue(track.trackSegments?.count == 1)
            
            try track.endTrackSegment()
            
            var activeSegmentCount = 0
            if let segments = track.trackSegments?.allObjects as? [TrackSegment] {
                for segment in segments {
                    if segment.isActiveSegment == true {
                        activeSegmentCount+=1
                    }
                }
            }

            XCTAssertTrue(activeSegmentCount == 0, "There should be no active track segments")
            
        }catch {
            XCTFail(error.localizedDescription)
        }
    
    }
    
    func testEndTrack() {
        
        do {
            
            let track = try createAndPopulateTestTrack(locationCount: generatedLocationCount)
            try track.start()
            XCTAssertTrue(track.isRecording)
            
            try track.end()
            XCTAssertFalse(track.isRecording)
            XCTAssertNotNil(track.endDate)
            
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
    func testPerformanceExample() throws {
        
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

//Utility functions
extension Gretel_SwiftUITests {
    
    func createAndPopulateTestTrack(locationCount:Int, addTimeDelayBetweenPoints:Bool = false) throws -> Track {
        
        do {
            
            let track = try Track.newInstance(context: self.viewContext)
            let segment = try track.getActiveSegment()
            
            let locations = self.getMockLocationsFor(location: CLLocation(latitude: 50.336868, longitude: -4.776990), itemCount: locationCount)
            
            for i in 0...locations.count-1 {
                if addTimeDelayBetweenPoints {
                    sleep(1)
                }
                try track.addLocation(location: locations[i])
            }
            
            return track
            
        } catch {
            throw error
        }
        
    }
    
    // create random locations (lat and long coordinates) around user's location
    // https://gist.github.com/inorganik/fcaa143eba6178fb672c5c335a11c564
    func getMockLocationsFor(location: CLLocation, itemCount: Int) -> [CLLocation] {
        
        func getBase(number: Double) -> Double {
            return round(number * 1000)/1000
        }
        func randomCoordinate() -> Double {
            return Double(arc4random_uniform(140)) * 0.0001
        }
        
        let baseLatitude = getBase(number: location.coordinate.latitude - 0.007)
        // longitude is a little higher since I am not on equator, you can adjust or make dynamic
        let baseLongitude = getBase(number: location.coordinate.longitude - 0.008)
        
        var items = [CLLocation]()
        for _ in 0..<itemCount {
            
            let randomLat = baseLatitude + randomCoordinate()
            let randomLong = baseLongitude + randomCoordinate()
            let location = CLLocation(latitude: randomLat, longitude: randomLong)
            
            items.append(location)
            
        }
        
        return items
    }
    
}
