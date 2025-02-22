# android-testify-action

<img src="testify.png" alt="Testify Logo" height="150px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/9/9e/Plus_symbol.svg" height="150px"/> <img src="https://github.githubassets.com/assets/GitHub-Mark-ea2971cee799.png" height="150px"/>

GitHub Action for running Android Testify screenshot tests

Run the android-testify tests annotated with [`@ScreenshotInstrumentation`](https://github.com/ndtp/android-testify/blob/main/Library/src/main/java/dev/testify/annotation/ScreenshotInstrumentation.kt) on an emulator hosted on GitHub Actions and report the test results.

Features:

- Configures the emulator for optimal performance with Testify
- Runs Android Testify tests
- Save failed test images as Artifacts
- Prepares a JUnit XML test report

Learn more at https://testify.dev

## Prerequisites

You must have an emulator configured and ready prior to invoking this step.

It is recommend that you ...


## Configuration Inputs

### app_apk

The full path to the application apk under test. For library projects, this will be the test apk.

### app_package

The package name of the app. For example, `com.sample`

### target_apk

The file name of the test runner .apk

### target_package

The package name of test runner .apk
For example, `com.sample.test`

### test_runner

The fully qualified class name for the Instrumentation test runner. e.g. `androidx.test.runner.AndroidJUnitRunner`

### module

The gradle project module name. For example, `:app`

### verbose

You can enable the verbose log for easier debugging.

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
