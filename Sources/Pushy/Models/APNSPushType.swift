// Copyright © 2021 Kyle Haptonstall.

import ArgumentParser
import Foundation

/// Represents the allowed values for the apns-push-type header. For even more details on each push type,
/// see [Sending Notification Requests to APNS](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/sending_notification_requests_to_apns).
enum APNSPushType: String, Decodable, CaseIterable, ExpressibleByArgument {
    /// Use the alert push type for notifications that trigger a user interaction—for example, an alert, badge, or sound.
    case alert

    /// Use the background push type for notifications that deliver content in the background, and don’t trigger any user interactions.
    case background

    /// Use the location push type for notifications that request a user’s location.
    case location

    /// Use the voip push type for notifications that provide information about an incoming Voice-over-IP (VoIP) call.
    case voip

    /// Use the complication push type for notifications that contain update information for a watchOS app’s complications.
    case complication

    /// Use the fileprovider push type to signal changes to a File Provider extension.
    case fileprovider

    /// Use the mdm push type for notifications that tell managed devices to contact the MDM server.
    case mdm
}
