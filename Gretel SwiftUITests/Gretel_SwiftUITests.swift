//
//  Gretel_SwiftUITests.swift
//  Gretel SwiftUITests
//
//  Created by Ben Reed on 15/09/2022.
//

import XCTest
import CoreData
import Combine
@testable import Gretel_SwiftUI

class Gretel_SwiftUITests: XCTestCase {
    
    var viewContext:NSManagedObjectContext!
    var cancellables = Set<AnyCancellable>()
    var trackHelper:TrackHelper!

    let coreDataTimeout = 3.0
    
    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.viewContext = PersistenceController.init(inMemory: true).container.viewContext
        self.trackHelper = TrackHelper(viewContext: self.viewContext)
        
        XCTAssertNotNil(self.viewContext, "ViewContext shold not be nil")
        XCTAssertNotNil(self.trackHelper, "Track helper shold not be nil")
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateNewTrackWithCustomName() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let expectation = expectation(description: "Create new track")
    
        trackHelper.createNewTrack(name: "Test track").sink { completion in
            print(completion)
        } receiveValue: { track in
            XCTAssertNotNil(track, "Track should not be nil")
            XCTAssertTrue(track?.name == "Test track", "Track name should be Test Track")
            expectation.fulfill()
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: coreDataTimeout)
        
    }
    
    func testCreateNewTrackWithDefaultName() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let expectation = expectation(description: "Create new track with default name")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let trackName = dateFormatter.string(from: Date())
        
        trackHelper.createNewTrack().sink { completion in
            print(completion)
        } receiveValue: { track in
            XCTAssertNotNil(track, "Track should not be nil")
            XCTAssertTrue(track?.name == trackName, "Track name should be \(trackName)")
            expectation.fulfill()
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: coreDataTimeout)
        
    }
    
    func testGetCurrentActiveTrack() {
        
        let expectation = expectation(description: "Get current active track")
        
        trackHelper.createNewTrack().sink { completion in
            print(completion)
        } receiveValue: { track in
            XCTAssertNotNil(track, "Track should not be nil")
            XCTAssertTrue(track?.isRecording == true, "Track should be recording")
            expectation.fulfill()
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: coreDataTimeout)

    }
    
    func testNoActiveTrack() {
        
        let expectation = expectation(description: "Test no active track")
        
        trackHelper.endCurrentRecording().sink { success in
            
            self.trackHelper.getCurrentActiveTrack().sink { completion in
                print(completion)
            } receiveValue: { track in
                XCTAssertNil(track, "Track should be nil")
                expectation.fulfill()
            }.store(in: &self.cancellables)
            
        }.store(in: &cancellables)
    
        waitForExpectations(timeout: coreDataTimeout)
        
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
