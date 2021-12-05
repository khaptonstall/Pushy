// Copyright © 2021 Kyle Haptonstall.

import ArgumentParser
import Foundation

enum SendError: Error {
    /// Occurs when the `data` option represents a JSON file, but the `FileManager` cannot find the file.
    case cannotAccessDataFile
    /// Occurs when we're unable to convert the contents of the JSON file provided for the `data` option..
    case dataParsingFailed
}

/// A command to send requests to the development APNs server.
/// For more detailed information about APNs and sending foreground/background notifications,
/// see [Sending Notification Requests to APNs](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/sending_notification_requests_to_apns)
/// and [Pushing Background Updates to Your App](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/pushing_background_updates_to_your_app).
struct Send: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Sends a push notification to a physical device")

    // MARK: Options

    @Option(help: "Either a JSON string or the path to a JSON file representing the push notification payload.")
    private var data: String = "{\"aps\":{\"alert\":{\"title\":\"Pushy\",\"body\":\"This is a test.\"}}}"

    @Option(help: "Reflects the contents of your notification's payload. Represents the apns-push-type header. (allowed: \(APNSPushType.allValueStrings))")
    private var pushType: APNSPushType = .alert

    @Option(help: "The bundle identifier of the app to target. Represents the apns-topic header.")
    private var bundleID: String

    @Option(help: "The priority of the notification. Represents the apns-priority header. For silent notifications, set to 5.")
    private var priority: Int = 10

    @Option(help: "The PEM-encoded private key, without a password, associated your APNs key in App Store Connect.")
    private var pathToCertificate: String

    @Option(help: "The device token from your app, as a hexadecimal-encoded ASCII string.")
    private var deviceToken: String

    // MARK: Flags

    @Flag(name: .shortAndLong, help: "If set, additional debug logging will be printed.")
    private var debug = false

    func run() throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c"] + [try self.buildAPNSRequest()]
        try process.run()
    }

    // MARK: Utilities

    private func buildAPNSRequest() throws -> String {
        var options = [
            "--data '\(try self.transformDataToJSONString())'",
            "--header \"apns-topic: \(self.bundleID)\"",
            "--header \"apns-priority:  \(self.priority)\"",
            "--header \"apns-push-type: \(self.pushType.rawValue)\"",
            "--http2",
            "--cert \(self.pathToCertificate)",
        ]

        if self.debug {
            options.append("-v")
        }

        return self.buildCurlRequest(url: "https://api.sandbox.push.apple.com/3/device/\(self.deviceToken)",
                                     options: options)
    }

    private func buildCurlRequest(url: String, options: [String]) -> String {
        return "curl \(options.joined(separator: " ")) \(url)"
    }

    private func transformDataToJSONString() throws -> String {
        guard URL(fileURLWithPath: self.data).pathExtension == "json" else {
            return self.data
        }

        guard FileManager.default.fileExists(atPath: self.data) else {
            throw SendError.cannotAccessDataFile
        }

        do {
            return try String(contentsOfFile: self.data)
        } catch {
            throw SendError.dataParsingFailed
        }
    }
}
