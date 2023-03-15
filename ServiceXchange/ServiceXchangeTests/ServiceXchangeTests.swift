//
//  ServiceXchangeTests.swift
//  ServiceXchangeTests
//
//  Created by Dillon Kermani on 3/14/23.
//

import XCTest

@testable import ServiceXchange
final class ServiceXchangeTests: XCTestCase {
    
    var df: CustomDateFormatter!

    override func setUp() {
        super.setUp()
        df = CustomDateFormatter()
    }

    override func tearDown() {
        df = nil
        super.tearDown()
    }

    func testFormatDate() {
        // Given
        let date = Date(timeIntervalSince1970: 1646869200) // March 9, 2022 at 12:00:00 AM GMT
        let format = "MMM d, yyyy"
        
        // When
        let result = df.formatDate(date, format: format)
        
        // Then
        XCTAssertEqual(result, "Mar 9, 2022")
    }

    func testFormatTimestamp() {
        // Given
        let timestamp = 1646869200 // March 9, 2022 at 12:00:00 AM GMT
        let format = "MMM d, yyyy"
        
        // When
        let result = df.formatTimestamp(Double(timestamp), format: format)
        
        // Then
        XCTAssertEqual(result, "Mar 9, 2022")
    }

    func testFormatTimestampSince_JustNow() {
        // Given
        let timestamp = Date().timeIntervalSince1970
        
        // When
        let result = df.formatTimestampSince(timestamp)
        
        // Then
        XCTAssertEqual(result, "just now")
    }

    func testFormatTimestampSince_MinutesAgo() {
        // Given
        let timestamp = Date().addingTimeInterval(-300).timeIntervalSince1970 // 5 minutes ago
        
        // When
        let result = df.formatTimestampSince(timestamp)
        
        // Then
        XCTAssertEqual(result, "5 minutes ago")
    }

    func testFormatTimestampSince_HoursAgo() {
        // Given
        let timestamp = Date().addingTimeInterval(-7200).timeIntervalSince1970 // 2 hours ago
        
        // When
        let result = df.formatTimestampSince(timestamp)
        
        // Then
        XCTAssertEqual(result, "2 hours ago")
    }

    func testFormatTimestampSince_DaysAgo() {
        // Given
        let timestamp = Date().addingTimeInterval(-86400).timeIntervalSince1970 // 1 day ago
        
        // When
        let result = df.formatTimestampSince(timestamp)
        
        // Then
        XCTAssertEqual(result, "Mar 14, 2023")
    }

    
}
