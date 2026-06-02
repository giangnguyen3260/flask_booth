# Admin/Backend Update Contract

This note describes the backend/admin changes needed for the kiosk app update flow.

## Context

The kiosk app now supports:

- Lightweight admin data version checks while on stand-by.
- Local cache for frame/background/category assets.
- Backup and rollback for admin data.
- Offline printing.
- Local upload queue and retry for printed results.

Backend/admin must provide a stable version contract so the kiosk can detect updates without downloading full admin data every few minutes.

## Required Endpoint

Add:

```http
GET /pub/main-info/version
```

Minimum response:

```json
{
  "version": "1",
  "updatedAt": "2026-06-02T08:00:00Z"
}
```

Requirements:

- `version` must map to the same value as `configInfo.configVersion` from `GET /pub/main-info`.
- `version` may be a string or number. The kiosk can read both.
- `updatedAt` should be ISO 8601 UTC.
- This endpoint must stay lightweight. Do not return frame/background data here.

## Existing Main Info Contract

`GET /pub/main-info` should continue returning the full runtime data:

```json
{
  "framesInfo": [],
  "configInfo": {
    "configVersion": 1,
    "timer": [],
    "appConfig": []
  }
}
```

Requirements:

- `configInfo.configVersion` must always be present.
- `configInfo.configVersion` must equal `/pub/main-info/version.version`.
- The returned data should represent the currently published admin snapshot.

## Version Bump Rules

Increment `configVersion` whenever a published admin change affects kiosk runtime behavior.

Bump version for:

- Add/edit/delete frame.
- Add/edit/delete background.
- Add/edit/delete background category icon.
- Change frame image URL or template image URL.
- Change background image URL.
- Change frame setting: photo count, time per shot, additional price, photo limit, cut mode, transparent areas, width, height, price, print quantity.
- Change timer/config values under `configInfo.timer` or `configInfo.appConfig`.
- Change default language/theme/runtime config used by kiosk.

No version bump needed for:

- Admin-only notes.
- Audit logs.
- Internal metadata not returned by `/pub/main-info`.

## Publish Semantics

Recommended admin flow:

1. Admin edits data as draft.
2. Admin clicks publish.
3. Backend validates the published payload.
4. Backend verifies all asset URLs are available.
5. Backend increments `configVersion`.
6. Backend stores a published snapshot.
7. `/pub/main-info` returns that published snapshot.
8. `/pub/main-info/version` returns the version of that same snapshot.

Important:

- Do not expose a newer version before `/pub/main-info` and all related asset URLs are ready.
- Kiosk only applies new data after full data and assets are resolved locally.

## Asset URL Requirements

Kiosk downloads assets before applying a new admin data version.

Asset URLs returned by `/pub/main-info` must be:

- Directly downloadable via HTTP GET from the kiosk machine.
- Not dependent on admin browser session cookies.
- Not protected by admin-only auth.
- Stable enough for the kiosk to finish downloading all assets.
- Valid image bytes.
- Preferably have clear extensions: `.png`, `.jpg`, `.jpeg`, `.webp`.

If an asset changes, prefer a versioned URL:

```text
https://cdn.example.com/frames/frame_a_v12.png
```

Avoid reusing the exact same URL for different bytes unless cache headers make that safe.

## Kiosk Behavior

Current kiosk behavior:

- On stand-by, kiosk calls `/pub/main-info/version` every 5 minutes.
- If the latest version differs from active local version, kiosk shows a small badge on the reload button.
- Operator clicks reload to apply admin update.
- Kiosk calls `/pub/main-info`.
- Kiosk resolves/downloads all frame/background/category assets locally.
- Kiosk validates that at least usable frame assets are available.
- Only after success, kiosk applies new data and saves a local backup.
- If full data load or asset download fails, kiosk keeps the currently active data.
- On startup without network, kiosk loads latest local backup.
- If no backup exists, kiosk loads bundled dummy data.

## Upload Retry Requirement

Kiosk now prints even if upload fails.

If `/pub/submit` fails:

- Kiosk stores the printed result in a local upload queue.
- Kiosk retries later when back on stand-by.

Backend should make `/pub/submit` idempotent by `saleNo`.

Expected behavior:

- First submit for a `saleNo` creates the media/order record.
- Retry with the same `saleNo` should not create duplicate records.
- If the previous upload already succeeded, return the existing `qrUrl`.
- If the previous upload did not complete, finish or replace the pending upload safely.

Response contract remains:

```json
{
  "qrUrl": "https://..."
}
```

## Acceptance Checklist

Backend/admin work is complete when:

- `GET /pub/main-info/version` exists.
- `version` equals `configInfo.configVersion` from `/pub/main-info`.
- Publishing runtime admin changes increments version.
- Version is not updated before full data and assets are available.
- Asset URLs are directly downloadable from kiosk.
- `/pub/submit` retry with the same `saleNo` does not create duplicates.
- `/pub/submit` retry returns a usable `qrUrl` once upload exists.

