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
@testable import Gretel

class Gretel_SwiftUITests: XCTestCase {
    
    var viewContext:NSManagedObjectContext!
    var cancellables = Set<AnyCancellable>()

    let coreDataTimeout = 3.0
    
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
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let trackName = "Test Track"
        
        do {
            let track = try Track.newInstance(name: trackName, context: self.viewContext)
            XCTAssertNotNil(track)
            XCTAssertNotNil(track.startDate)
            XCTAssertNil(track.endDate)
            XCTAssertTrue(track.displayName() == trackName)
            
        } catch {
            XCTFail("Failed to create new track object: \(error.localizedDescription)")
        }
        
    }
    
    func testCreateNewTrackWithDefaultName() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        
        let trackName = dateFormatter.string(from: Date())
        
        do {
            let track = try Track.newInstance(context: self.viewContext)
            XCTAssertNotNil(track)
            XCTAssertNotNil(track.startDate)
            XCTAssertNil(track.endDate)
            XCTAssertTrue(track.displayName() == trackName)
            
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
        
        
        do {
            
            let track = try Track.newInstance(context: self.viewContext)
            let segment = TrackSegment(context: self.viewContext)
            
            for i in 0...10 {
                let trackPoint = TrackPoint(context: self.viewContext)
                trackPoint.time = Date() + i.minutes
                segment.addToTrackPoints(trackPoint)
            }
            
            track.addToTrackSegments(segment)
            
            let duration = track.totalDuration()
            XCTAssertTrue(duration == 600)
            
        } catch {
            XCTFail("Could not calculate interval between points")
        }
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
