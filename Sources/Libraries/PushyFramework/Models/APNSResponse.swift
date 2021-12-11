// Copyright © 2021 Kyle Haptonstall.

import Foundation

/// Represents a response from the APNs server as either a success or failure,
public struct APNSResponse {
    // MARK: ResponseType
    
    public enum ResponseType {
        case success
        case error(FailureReason)
    }

    // MARK: Properties

    /// The type of response received from the APNs server.
    public let type: ResponseType

    /// A human-readable description about the contents of the response, indicating either a success or failure.
    public var description: String {
        switch self.type {
        case .success:
            return "APNs returned a successful response!"
        case let .error(failureReason):
            return failureReason.description
        }
    }

    // MARK: Initialization

    /// Creates a new instance of `APNSResponse`.
    /// - Parameter data: The data response received from an APNs request.
    public init(data: Data) {
        guard !data.isEmpty else {
            // APNs will return an empty response if the call was a success.
            self.type = .success
            return
        }

        // If the data is not empty, convert it to a JSON object so we can find the underlying error.
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
            self.type = .error(.invalidResponseFormat)
            return
        }

        guard let reason = json["reason"] as? String else {
            self.type = .error(.missingFailureReasonKey)
            return
        }

        self.type = .error(.apnsFailure(APNSError(reason: reason, timestamp: json["timestamp"] as? Int)))
    }
}

// MARK: - APNSResponse + FailureReason

public extension APNSResponse {
    enum FailureReason {
        /// Indicates the failure response was not sent as properly formatted JSON.
        case invalidResponseFormat
        /// Indicates the failure response JSON does not include a `"reason"` key.
        case missingFailureReasonKey
        /// Indicates a informative errror was received from the APNs server.
        case apnsFailure(APNSError)

        /// A human-readable description about the error.
        var description: String {
            switch self {
            case .invalidResponseFormat:
                return "APNs returned an error, but the API response was not valid JSON."
            case .missingFailureReasonKey:
                return "APNs returned an error, but the underlying reason was not found."
            case let .apnsFailure(apnsError):
                return apnsError.description
            }
        }
    }
}

// MARK: - APNSResponse.FailureReason + Equatable

extension APNSResponse.FailureReason: Equatable {
    public static func == (lhs: APNSResponse.FailureReason, rhs: APNSResponse.FailureReason) -> Bool {
        switch (lhs, rhs) {
        case (.invalidResponseFormat, .invalidResponseFormat):
            return true
        case (.missingFailureReasonKey, .missingFailureReasonKey):
            return true
        case let (.apnsFailure(lhsError), .apnsFailure(rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

// MARK: - APNSResponse.ResponseType + Equatable

extension APNSResponse.ResponseType: Equatable {}
