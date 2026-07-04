# DJI Firmware Watcher Privacy Notes

DJI Firmware Watcher is a local macOS menu-bar app. It does not require an account and does not upload personal files or device data.

## Local State

The app stores state locally at:

```text
~/Library/Application Support/DJIFirmwareWatcher/state.json
```

The state file may contain:

- Selected product identifiers.
- Latest release-note URLs seen for watched products.
- Check timestamps.
- Detection status for product pages.

Deleting the state file resets the app.

## Network Requests

The app requests public DJI product download pages and release-note PDF URLs so it can detect newly published firmware notes.

It does not:

- Log in to DJI accounts.
- Query connected drones.
- Read aircraft serial numbers.
- Install firmware.
- Upload user documents.
- Send analytics or telemetry.

## Notifications

When a newer release note is detected, the app may use macOS notifications. Notification delivery is handled by macOS.

## Screenshots

Documentation screenshots are representative and redacted. They show sample product status, not private local state.

## Third-Party Website Notice

Opening a DJI downloads page or release-note PDF sends the request to DJI in the user's default browser or via the normal macOS networking stack. DJI's own terms and privacy policy apply to their website.
