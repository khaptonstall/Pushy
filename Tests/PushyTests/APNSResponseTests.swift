// Copyright © 2021 Kyle Haptonstall.

import Foundation
import PushyFramework
import XCTest

final class APNSResponseTests: XCTestCase {
    func testEmptyDataIndicatesASuccessResponse() {
        // Initialize the APNSResponse with an empty Data object.
        let response = APNSResponse(data: Data())

        // Verify the response represents a success.
        XCTAssertEqual(response.type, .success)
    }

    func testDataThatCannotBeRepresentedAsJSONReturnsInvalidResponseFormatAsFailureReason() throws {
        // Create a Data object which cannot be represented as JSON.
        let data = try XCTUnwrap("( not json )".data(using: .utf8))

        // Verify the response represents a invalidResponseFormat error.
        let response = APNSResponse(data: data)
        XCTAssertEqual(response.type, .error(.invalidResponseFormat))
    }

    func testJSONDataMissingReasonKeyReturnsMissingFailureReasonKeyAsFailureReason() throws {
        // Create a JSON Data object which is missing the "reason" key.
        let json = "{ \"key\": \"value\" }"
        let data = try XCTUnwrap(json.data(using: .utf8))

        // Verify the response represents a missingFailureReasonKey error.
        let response = APNSResponse(data: data)
        XCTAssertEqual(response.type, .error(.missingFailureReasonKey))
    }

    func testJSONDataFromAPNSReturnsAPNSFailureAsFailureReason() throws {
        // Create a JSON Data object which is missing the "reason" key.
        let reason = "BadDeviceToken"
        let json = "{ \"reason\": \"\(reason)\" }"
        let data = try XCTUnwrap(json.data(using: .utf8))

        // Verify the response represents a apnsFailure error.
        let response = APNSResponse(data: data)
        let apnsError = APNSError(reason: reason, timestamp: nil)
        XCTAssertEqual(response.type, .error(.apnsFailure(apnsError)))
    }
}
