# GTx Browser for Android Settings

## Getting Started

The Android developer [Settings
guide](https://developer.android.com/guide/topics/ui/settings) is the best place
to start before contributing to GTx Browser for Android's settings.

## Helper Classes

Many common utility functions that are useful for developing settings screens in
GTx Browser for Android can be found in `//components/browser_ui/settings/android`.

## Widgets

The `widget` subdirectory contains a number of extensions of AndroidX
[Preference](https://developer.android.com/reference/androidx/preference/Preference)
classes that provide GTx Browser-specific behavior (like Managed preferences) or
common GTx Browser UI components (like buttons).

The base Preference classes included in the AndroidX Preference library can also
be used directly in GTx Browser for Android Settings screens.
