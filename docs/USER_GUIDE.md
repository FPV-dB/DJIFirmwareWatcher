# DJI Firmware Watcher User Guide

DJI Firmware Watcher is a menu-bar utility for monitoring official DJI release-note pages. It is intended for pilots and maintainers who want a quick way to notice when DJI publishes new firmware documentation.

## First Launch

On first launch, the app selects all catalogued DJI products. This gives the watcher an immediate baseline, but most users should narrow the list to the models they actually own or support.

Recommended first-run flow:

1. Launch `DJI Firmware Watcher.app`.
2. Click the menu bar item.
3. Open `Manage Models...`.
4. Select only the aircraft, goggles, controllers, air units, and enterprise products you care about.
5. Click `Done`.
6. Click `Check Now`.

## Status Popover

The menu bar popover shows watched products and their current detection state.

Common states include:

- **Current**: the latest known release note has already been seen.
- **Update found**: a newer release note or changed PDF was detected.
- **No match**: the page was checked, but no matching release-note PDF was found.
- **Checking**: the app is actively requesting product pages.

The footer shows the last check time and how many products are currently watched.

## Managing Models

The model picker includes:

- Search by product name or category.
- Category filters for consumer drones, FPV/air units, controllers, goggles, and enterprise models.
- A selected-products section.
- `Select All Visible` and `Clear Visible` bulk actions.

Use search when DJI product names are similar. Use category filters when you want to quickly narrow the catalog.

## Checking For Updates

Click `Check Now` to run an immediate check. The app also checks automatically once every 24 hours while it is running.

The first successful check establishes a baseline. Later checks compare the newest matching release note against that baseline. A notification is only sent when a newer dated note or a different PDF for the same date is detected.

## Notifications

macOS notification permission is required for update alerts. If you do not see alerts:

1. Open macOS System Settings.
2. Go to Notifications.
3. Find DJI Firmware Watcher.
4. Allow notifications.

## Opening Release Notes

When an update is detected, use the app's status row actions to open the newest detected release-note PDF or the product's official DJI downloads page.

## Limitations

DJI may change website layouts, URLs, filenames, or product page availability. A product can temporarily report no match even when the app is working correctly.

The app does not:

- Connect to a drone.
- Install firmware.
- Verify aircraft firmware versions.
- Replace DJI Fly, DJI Assistant, or official DJI support workflows.

## Resetting State

The local state file is:

```text
~/Library/Application Support/DJIFirmwareWatcher/state.json
```

Deleting this file resets selected products and known release-note history. The next successful check will create a fresh baseline.

## Troubleshooting

### No products are shown

Open `Manage Models...` and select products to watch.

### Everything says no match

Confirm the Mac has internet access and try again later. DJI may have changed page structure or temporarily removed a document.

### Notifications do not appear

Check macOS notification permission and confirm the app has detected a genuinely newer release note after the baseline check.

### Automatic checks do not happen

The app must be running. It does not install a background daemon.
