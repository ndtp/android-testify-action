# android-testify-action

<img src="testify.png" alt="Testify Logo" height="150px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/9/9e/Plus_symbol.svg" height="150px"/> <img src="https://github.githubassets.com/assets/GitHub-Mark-ea2971cee799.png" height="150px"/>

GitHub Action for running Android Testify screenshot tests

Run the android-testify tests annotated with [`@ScreenshotInstrumentation`](https://github.com/ndtp/android-testify/blob/main/Library/src/main/java/dev/testify/annotation/ScreenshotInstrumentation.kt) on an emulator hosted on GitHub Actions and report the test results.

Features:

- Configures the emulator for optimal performance with Testify
- Runs Android Testify tests
- Save failed test images as Artifacts
- Prepares a JUnit XML test report
- Annotates the associated PR with any reported errors

Learn more at https://testify.dev

## Prerequisites

You must have an emulator configured and ready prior to invoking this step.

It is recommend that you ...


## Configuration Inputs

### api-level

API level of the platform system image - e.g. 23 for Android Marshmallow, 29 for Android 10. Minimum API level supported is 15.

Example:
```yaml
    api-level: 29
```

### target

Target of the system image - default, google_apis, playstore, android-wear, android-wear-cn, android-tv, google-tv, aosp_atd or google_atd. Note that aosp_atd and google_atd currently require the following: api-level: 30, arch: x86 or arch: arm64-v8 and channel: canary.

Example:
```yaml
    target: google_apis
```

### arch

CPU architecture of the system image - x86, x86_64 or arm64-v8a. Note that x86_64 image is only available for API 21+. arm64-v8a images require Android 4.2+ and are limited to fewer API levels (e.g. 30).

Example:
```yaml
    arch: x86_64
```

### profile

Hardware profile used for creating the AVD - e.g. Nexus 6. For a list of all profiles available, run avdmanager list device.

Example:
```yaml
    profile: pixel_3a
```

### module

The gradle project module name. You can find the module name by running `./gradlew projects`

Example:
```yaml
    module: ":LegacySample"
```

### app_apk

The full path to the application apk under test. For library projects, this will be the test apk.

Example:
```yaml
    app_apk: "./Samples/Legacy/build/outputs/apk/debug/LegacySample-debug.apk"
```

### app_package

The package name of the app. This is normally the `namespace` values from your `build.gradle`, including any suffixes.

Example:
```yaml
    app_package: "dev.testify.sample"
```

### test_apk

The full path to the instrumentation test runner .apk.

Example:
```yaml
    test_apk: "./Samples/Legacy/build/outputs/apk/androidTest/debug/LegacySample-debug-androidTest.apk"
```

### test_package

The package name of the instrumentation test runner .apk. This is normally the `namespace` of your application, with the suffix `.test`.

Example:
```yaml
    test_package: "dev.testify.sample.test"
```

### test_runner

The fully qualified class name for the Instrumentation test runner. This is the value of `testInstrumentationRunner` from your `build.gradle`.

Example:
```yaml
    test_runner: "androidx.test.runner.AndroidJUnitRunner"
```

### animations

Optional, default is `false`.

Enables animations on the emulator.

Example:
```yaml
    animations: true
```

### device_density

Optional, default is `0`.

DPI value to set on the emulator. This must be an integer value.

Use a value greater than zero to adjust the display density on the emulator using `adb shell wm density $device_density`.

Example:
```yaml
    device_density: 440
```

### show_ime_with_hard_keyboard:

Optional, default is `false`.

Show the onscreen keyboard (IME).

Example:
```yaml
    show_ime_with_hard_keyboard: true
```

### show_passwords:

Optional, default is `false`.

Show password entry characters

Example:
```yaml
    show_passwords: true
```

### verbose

Optional, default is `false`.

You can enable the verbose log for easier debugging. Verbose logging increases the amount of log output substantially.

Example:
```yaml
    verbose: true
```

---

## License

MIT License

Copyright (c) 2025 ndtp

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
