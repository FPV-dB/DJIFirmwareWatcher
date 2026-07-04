# DJI Firmware Watcher

DJI Firmware Watcher is a lightweight macOS menu-bar app that monitors official DJI download pages for new firmware release-note PDFs. Choose the products you use, check them on demand, and receive a notification when a newer release note appears.

> [!NOTE]
> This is an independent community project. It is not affiliated with, endorsed by, or supported by DJI.

## Features

- Runs as a native macOS menu-bar app.
- Watches selected DJI drones, controllers, goggles, air units, and enterprise products.
- Checks immediately with **Check Now** and automatically once every 24 hours while running.
- Uses official DJI product download pages as its data source.
- Opens the newest detected release-note PDF or the product's DJI downloads page.
- Sends a macOS notification when a newer release note is detected.
- Includes searchable, category-based model selection.
- Stores preferences and check history locally.

## How It Works

On first launch, all catalogued products are selected. Open **Manage Models** to choose which products the app should watch.

The first successful check establishes a local baseline. Later checks compare the newest matching release note with that baseline. A notification is sent only when the app finds a newer dated note or a different PDF for the same date.

Some products share a downloads page, and some newly announced products may not yet have an individual public page. In those cases, the app reports the HTTP or matching status rather than treating it as an update.

## Requirements

- macOS 14 Sonoma or later
- Xcode or compatible Swift 6 command-line tools to build from source
- Internet access to official DJI websites
- Notification permission for update alerts

## Build From Source

Clone the repository and run the bundled build script:

```bash
git clone https://github.com/FPV-dB/DJIFirmwareWatcher.git
cd DJIFirmwareWatcher
./scripts/build-app.sh
```

The app bundle is created at:

```text
outputs/DJI Firmware Watcher.app
```

Move the app to `/Applications`, then launch it normally:

```bash
cp -R "outputs/DJI Firmware Watcher.app" /Applications/
open "/Applications/DJI Firmware Watcher.app"
```

You can also build and test the Swift package directly:

```bash
swift build
swift test
```

## Privacy

DJI Firmware Watcher does not require an account and does not upload personal data. It requests public DJI download pages and saves its state locally at:

```text
~/Library/Application Support/DJIFirmwareWatcher/state.json
```

The state file contains selected product identifiers, the latest release notes seen, and check timestamps. Deleting it resets the app to its first-launch state.

## Limitations

- DJI may change its website structure, which can temporarily prevent release-note detection.
- The app detects published release notes; it does not query a drone or install firmware.
- A product without a matching public release-note document may show **No matching release notes found**.
- Automatic checks occur while the app is running; this project does not currently install a separate background service.

## Project Structure

```text
Sources/DJIFirmwareWatcher/       SwiftUI menu-bar interface
Sources/DJIFirmwareWatcherCore/   Product catalog, parsing, scheduling, and state
Tests/                            Core parser and scheduling tests
Resources/                        Menu-bar artwork
scripts/build-app.sh              Application bundle build script
```

## Contributing

Bug reports and focused pull requests are welcome. When reporting a missed release, include the DJI product name and its official downloads-page URL.
## Hire / Contact

FPV-dB is available for hire for macOS, SwiftUI, RF tooling, drone software, mapping, and field-operations utilities. For work enquiries, contact ex.dee.emm@gmail.com.
