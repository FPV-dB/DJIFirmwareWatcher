# DJI Firmware Watcher

A macOS menu bar app that checks selected official DJI download pages for newer product release-note PDFs.

## Behavior

- All catalog products are selected on first launch.
- **Check Now** performs an immediate check.
- The app checks again when 24 hours have elapsed while it is running.
- Selections, last-seen releases, and the last check time are stored in `~/Library/Application Support/DJIFirmwareWatcher/state.json`.
- The first successful scan establishes a baseline. Later, newer dated release notes trigger macOS notifications.
- Some newly announced or separately bundled products may not have an individual public DJI downloads page. These appear with a clear HTTP or matching-note status instead of generating false results.

## Build

```bash
./scripts/build-app.sh
```

The app bundle is written to `outputs/DJI Firmware Watcher.app`.
