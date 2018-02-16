//
//  DurationFormatterTests.swift
//  DeezerPOCTests
//
//  Created by Jerome Ceccato on 16/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import XCTest
@testable import DeezerPOC

class DurationFormatterTests: XCTestCase {
    
    var formatter: DurationFormatterType!
    
    override func setUp() {
        super.setUp()
        formatter = DurationFormatter.shared
    }
    
    override func tearDown() {
        formatter = nil
        super.tearDown()
    }
    
    func testInvalid() {
        XCTAssertEqual(formatter.string(from: -1), "-")
    }
    
    func testUnits() {
        // Null
        XCTAssertEqual(formatter.string(from: 0), "00:00:00")
        
        // Seconds
        XCTAssertEqual(formatter.string(from: 4), "00:00:04")
        XCTAssertEqual(formatter.string(from: 12), "00:00:12")
        
        // Minutes
        XCTAssertEqual(formatter.string(from: 60), "00:01:00")
        XCTAssertEqual(formatter.string(from: 17 * 60), "00:17:00")
        
        // Hours
        XCTAssertEqual(formatter.string(from: 3600), "01:00:00")
        XCTAssertEqual(formatter.string(from: 18 * 3600), "18:00:00")
    }
    
    func testCombinations() {
        // Seconds and minutes
        XCTAssertEqual(formatter.string(from: 11 * 60 + 23), "00:11:23")
        
        // Hours and minutes
        XCTAssertEqual(formatter.string(from: 17 * 3600 + 56 * 60), "17:56:00")
        
        // Hours and seconds
        XCTAssertEqual(formatter.string(from: 17 * 3600 + 56), "17:00:56")
        
        // All
        XCTAssertEqual(formatter.string(from: 8 * 3600 + 32 * 60 + 41), "08:32:41")
    }
}
