# Flashy Booth UI Refresh Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refresh the remaining Flutter kiosk screens to match the provided Photo Booth template while keeping layouts responsive.

**Architecture:** Reuse shared visual primitives from `lib/resources/flashy_booth_theme.dart` for background, step bar, language pill, and round navigation controls. Update each feature screen in place, preserving existing provider/data flow and only replacing presentation layout.

**Tech Stack:** Flutter, Provider, auto_route, flutter_screenutil, existing `BasePageState` screen framework.

---

## Current Status

- [x] Screen 1: StandBy splash, logo, start button
- [x] Screen 2/2.1: Choose frame, horizontal scroll, selected frame CTA
- [x] Screen 3: Choose print quantity
- [x] Screen 4/5/5.1: Order summary, payment, coupon modal
- [x] Screen 6: Shooting guide
- [x] Screen 7: Shooting camera
- [x] Screen 8/8.1: Photo selection
- [x] Screen 9: Background/filter selection
- [x] Screen 10: Printing/QR

## Responsive Rules For Every Screen

- [x] Use `LayoutBuilder` for major sections.
- [x] Prefer viewport-relative widths with `min/max` constraints.
- [x] Keep fixed-format widgets stable with explicit size or aspect ratio.
- [x] Avoid text overlap by using `maxLines`, `overflow`, and constrained width.
- [x] Disable `BasePageState` default footer/counter only when replacing it with template-native controls.
- [x] Run `dart format`, `flutter analyze`, and macOS debug build after each screen group.

## Remaining Screen Plan

### Task 1: Payment Screen

**Files:**
- Modify: `lib/features/payment_screen/payment_screen.dart`
- Review: `lib/features/payment_screen/provider/payment_screen_provider.dart`

- [ ] Map `screen_4.png` and `screen_4.1.png` to payment states: waiting for payment, coupon applied or paid state.
- [ ] Replace current payment layout with template styling.
- [ ] Keep bill acceptor/mock payment logic unchanged.
- [ ] Keep coupon entry action accessible and visually consistent.
- [ ] Verify total price, paid amount, remaining amount, coupon discount, and next navigation still work.

### Task 2: Coupon Popup/Screen

**Files:**
- Modify: `lib/features/coupon_screen/coupon_screen.dart`
- Review: `lib/features/coupon_screen/provider/coupon_provider.dart`

- [ ] Style coupon input and keypad/button states to match the pink template.
- [ ] Keep numeric/alphanumeric coupon behavior working.
- [ ] Keep delete/clear action working.
- [ ] Verify invalid coupon and valid coupon messages do not overflow.

### Task 3: Shooting Guide Screen

**Files:**
- Modify: `lib/features/shooting_guide_screen/shooting_guide_screen.dart`

- [ ] Map the matching reference image from `screen_5.png` or `screen_6.png`.
- [ ] Convert guide content to responsive centered template layout.
- [ ] Preserve countdown/auto-start behavior and navigation to camera.

### Task 4: Shooting Camera Screen

**Files:**
- Modify: `lib/features/shooting_screen/shooting_screen.dart`
- Review: `lib/features/shooting_screen/provider/shooting_screen_provider.dart`

- [ ] Map the matching camera reference image.
- [ ] Keep camera preview aspect ratio stable.
- [ ] Style countdown, capture state, retake/progress controls.
- [ ] Preserve mock camera default test image behavior.
- [ ] Verify captured files are passed to `PhotoSelectionRoute`.

### Task 5: Photo Selection Screen

**Files:**
- Modify: `lib/features/photo_selection/photo_selection_screen.dart`
- Review: `lib/features/photo_selection/provider/photo_selection_screen_provider.dart`

- [ ] Keep current working slot-fill behavior.
- [ ] Apply template spacing, frame preview position, selected-image states, and responsive sizing.
- [ ] Ensure selected photos fit exactly within transparent areas.
- [ ] Keep deselect/reselect behavior working.

### Task 6: Background/Filter Selection Screen

**Files:**
- Modify: `lib/features/background_selection/background_selection.dart`
- Review: `lib/features/background_selection/provider/background_selection_provider.dart`

- [x] Preserve current layering rule: background -> transparent photos -> frame.
- [x] Apply template styling to filter/category/background panels.
- [x] Keep background preview thumbnails responsive.
- [x] Verify background does not cover transparent photo regions.
- [x] Keep print CTA outside scrollable panels.

### Task 7: Printing/QR Screen

**Files:**
- Modify: `lib/features/printing/printing_screen.dart`
- Review: `lib/features/printing/provider/printing_screen_provider.dart`

- [x] Match final waiting/printing/QR reference screens.
- [x] Show final composited print image, not partial preview.
- [x] Keep QR area reserved and responsive.
- [x] Preserve upload, print, and finish/restart behavior.

### Task 8: Shared Cleanup

**Files:**
- Modify: `lib/resources/flashy_booth_theme.dart`
- Optional modify: `lib/resources/app_text_style.dart`

- [x] Extract duplicated title/subtitle/header controls.
- [x] Extract responsive bottom round navigation controls.
- [x] Keep color/theme values centralized.
- [x] Run full targeted analysis on all modified screens.

## Verification Commands

- [x] `dart format lib/resources/flashy_booth_theme.dart lib/features/payment_screen/payment_screen.dart lib/features/coupon_screen/coupon_screen.dart lib/features/shooting_guide_screen/shooting_guide_screen.dart lib/features/shooting_screen/shooting_screen.dart lib/features/photo_selection/photo_selection_screen.dart lib/features/background_selection/background_selection.dart lib/features/printing/printing_screen.dart`
- [x] `flutter analyze lib/resources/flashy_booth_theme.dart lib/features/payment_screen/payment_screen.dart lib/features/coupon_screen/coupon_screen.dart lib/features/shooting_guide_screen/shooting_guide_screen.dart lib/features/shooting_screen/shooting_screen.dart lib/features/photo_selection/photo_selection_screen.dart lib/features/background_selection/background_selection.dart lib/features/printing/printing_screen.dart`
- [x] `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer PTB_BASE_URL=http://127.0.0.1:8080 PTB_PAYMENT_MODE=mock PTB_CAMERA_MODE=mock flutter build macos --debug`
