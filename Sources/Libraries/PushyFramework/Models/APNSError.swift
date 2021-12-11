// Copyright © 2021 Kyle Haptonstall.

import Foundation

public struct APNSError {
    // MARK: Properties

    /// The error code indicating the reason for the failure.
    public let reason: String

    /// The time, represented in milliseconds since Epoch, at which APNs confirmed the token was no longer valid for the topic.
    /// This value is included only when the error in the :status field is 410.
    public let timestamp: Int?

    /// A human-readable description about the APNs error.
    public var description: String {
        let developerDocs = "https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/handling_notification_responses_from_apns"
        if let timestamp = self.timestamp {
            return "APNs returned an error: \(self.reason), timestamp: \(timestamp) (milliseconds since Epoch). For more details on this error code, visit \(developerDocs)"
        } else {
            return "APNs returned an error: \(self.reason). For more details on this error code, visit \(developerDocs)"
        }
    }

    // MARK: Initialization

    public init(reason: String, timestamp: Int? = nil) {
        self.reason = reason
        self.timestamp = timestamp
    }
}

// MARK: - Equatable

extension APNSError: Equatable {}
