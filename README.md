# Pushy
A command-line tool to make testing push notifications simple.

## Installation
Pushy can be installed using [Mint](https://github.com/yonaskolb/Mint):

```sh
mint run khaptonstall/Pushy@<version>
```

## Usage
Prior to running Pushy, you'll need to have the following handy:
- The bundle identifier for the app you want to send push notifications to.
- The APNs device token from your app, as a hexadecimal-encoded ASCII string.
  - For details on retrieving a device token, see [Registering Your App with APNs](https://developer.apple.com/documentation/usernotifications/registering_your_app_with_apns).
- The PEM-encoded private key, without a password, associated your APNs key in App Store Connect.
  - For more information, see [Managing Keys](https://help.apple.com/developer-account/#/dev3a82eef1c).
- Your notification's JSON payload, either stored in a `.json` file or you can pass a JSON string directly.
  - For details on constrruction the JSON payload, see [Creating the Remote Notification Payload](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CreatingtheNotificationPayload.html).

Once you have the above information, you're ready to start sending notifications!

Using a `.json` file:
```sh
mint run pushy send \
--data /path/to/notification_payload.json \
--device-token <your_device_token> \
--bundle-id <your_bundle_id> \
--path-to-certificate /path/to/cert.pem
```

Using a JSON string:
```sh
mint run pushy send \
--data '{"aps":{"alert":"test"}}' \
--device-token <your_device_token> \
--bundle-id <your_bundle_id> \
--path-to-certificate /path/to/cert.pem
```
