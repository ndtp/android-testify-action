#!/bin/bash

RESTORE='\033[0m'
RED='\033[00;31m'
YELLOW='\033[00;33m'
BLUE='\033[00;36m'
GREEN='\033[00;32m'

error()
{
    echo -e "${RED}[ERROR] ${1}${RESTORE}" >&2
}

warn()
{
    echo -e "${YELLOW}[WARNING] ${1} ${RESTORE}" >&2
}

info()
{
    echo -e "${BLUE}[INFO]${RESTORE} ${1}" >&2
}

success()
{
    echo -e "${GREEN}[SUCCESS]${RESTORE} ${1}" >&2
}

verbose()
{
    if [ "$verbose" == true ] || [ "$VERBOSE" == true ]; then
        warn "$1"
    fi
}

install_apk()
{
    local apk=$1
    local package=$2
    local type=$3

    verbose $(adb logcat -m 1 -d)

    info "Install $apk"
    install_output="$( { adb install -r "$apk"; } 2>&1 )"
    verbose "install_output:"
    verbose "$install_output"

    info "Verify installation"
    verbose "package:"
    verbose "$package"

    instrumentation=$(adb shell pm list "$3")
    verbose "instrumentation:"
    verbose "$instrumentation"

    if [[ $instrumentation =~ "$package" ]]; then
       success "Package $package verified"
    else
        echo "$instrumentation"
        error "Failed to install $apk"
        exit 1
    fi

    if [[ "$install_output" =~ "failed" ]]; then
        echo "$install_output"
        error "Failed to install $apk"
        exit 1
    else
        ok_results=$(echo "$install_output" | grep --color=no "Success")
        success "$ok_results"
    fi
}

assert_emulator()
{
    if [ "`adb shell getprop sys.boot_completed | tr -d '\r' `" != "1" ] ; then
        error "Emulator not found"
        exit 1
    fi
}


configure_emulator()
{
    info "Configure emulator"

    if [ "$device_density" -gt "0" ]; then
        # Adjust device density
        adb shell wm density $device_density
    fi

    if [ "$animations" == false ]; then
        # Disable animations
        adb shell settings put global window_animation_scale 0
        adb shell settings put global transition_animation_scale 0
        adb shell settings put global animator_duration_scale 0
    fi


    if [ "$animations" == false ]; then
        # Disable animations
        adb shell settings put global window_animation_scale 0
        adb shell settings put global transition_animation_scale 0
        adb shell settings put global animator_duration_scale 0
    fi

    if [ "$show_ime_with_hard_keyboard" == false ]; then
        # Disable keyboard
        adb shell settings get secure show_ime_with_hard_keyboard
        adb shell settings put secure show_ime_with_hard_keyboard 0
        adb shell settings get secure show_ime_with_hard_keyboard
    fi

    if [ "$show_passwords" == false ]; then
        # Disable password text
        adb shell settings put system show_password 0
    fi
}

invoke_adb_command()
{
     if [ -n "$shard_count" ] && [ "$shard_count" -gt "0" ]; then
        shard="-e numShards $shard_count -e shardIndex $shard_index"
    fi

    local adb_command="adb shell am instrument -r -w $shard -e annotation dev.testify.annotation.ScreenshotInstrumentation $test_package/$test_runner"

    info "Running '$adb_command'..."
    adb logcat -c
    adb_command_output="$( { $adb_command; } 2>&1 )"
    logcat_output=$(adb logcat -d)

    verbose "adb_command_output:"
    verbose "$adb_command_output"

    verbose ""
    verbose "logcat_output:"
    verbose "$logcat_output"
}

pretty_results()
{
    info "pretty_results()"

    verbose "Create directory ./reports/"
    mkdir -p "./reports/"

    verbose "adb_command_output:"
    verbose "$adb_command_output"

    echo "$adb_command_output" | java -jar "$SCRIPT_DIR/Instrumentationpretty/pretty.jar"
}

exit_error()
{
    echo "$adb_command_output"
    echo "$logcat_output"
    error "Tests failed $1"
    exit 1
}

verify_test_status()
{
    info "Verify test status"
    if [[ $adb_command_output =~ "crashed" ]]; then
        exit_error "crashed"
    fi

    if [[ $adb_command_output =~ "Error in" ]]; then
        exit_error "exeception"
    fi

    if [[ $adb_command_output =~ "failures:" ]]; then
        exit_error "failures"
    fi

    if [[ $adb_command_output =~ "failure:" ]]; then
        exit_error "failure"
    fi

    if [[ $adb_command_output =~ "ScreenshotBaselineNotDefinedException" ]]; then
        exit_error "ScreenshotBaselineNotDefinedException"
    fi

    if [[ $adb_command_output =~ "androidx.test.espresso.PerformException" ]]; then
        exit_error "androidx.test.espresso.PerformException"
    fi

    if [[ $adb_command_output =~ "java.util.concurrent.TimeoutException" ]]; then
        exit_error "java.util.concurrent.TimeoutException"
    fi

    if [[ $logcat_output =~ "FAILURES!!!" ]]; then
        exit_error "FAILURES!!!"
    fi

    if [[ $logcat_output =~ "INSTRUMENTATION_CODE: 0" ]]; then
        exit_error "INSTRUMENTATION_CODE: 0"
    fi

    if [[ $logcat_output =~ "Process crashed while executing" ]]; then
        exit_error "Process crashed while executing"
    fi

    ok_results=$(echo "$adb_command_output" | grep --color=no "OK")
    success "$ok_results"

    exit 0
}

archive_failed_images()
{
    verbose "Pull failed tests for module [$module]"

    ./gradlew $module:screenshotPull

    modified_files=( $(git status --porcelain | grep --color=no .png) )
    for index in "${!modified_files[@]}" ; do [[ "${modified_files[$index]}" == "M" ]] && unset -v 'modified_files[$index]' ; done
    modified_files=("${modified_files[@]}")

    DEPLOY_DIR="./output/"
    mkdir -p $DEPLOY_DIR

    for file in "${modified_files[@]}"
    do
        verbose "Copy '$file' to $DEPLOY_DIR"
        cp $file $DEPLOY_DIR
    done
}

load_input_arguments()
{
    export animations="${1:-${ANIMATIONS}}"
    export app_apk="${2:-${APP_APK}}"
    export app_package="${3:-${APP_PACKAGE}}"
    export device_density="${4:-${DEVICE_DENSITY}}"
    export module="${5:-${MODULE}}"
    export show_ime_with_hard_keyboard="${6:-${SHOW_IME_WITH_HARD_KEYBOARD}}"
    export show_passwords="${7:-${SHOW_PASSWORDS}}"
    export test_apk="${8:-${TEST_APK}}"
    export test_package="${9:-${TEST_PACKAGE}}"
    export test_runner="${10:-${TEST_RUNNER}}"
    export shard_count="${11:-${SHARD_COUNT}}"
    export shard_index="${12:-${SHARD_INDEX}}"
    export verbose="${13:-${VERBOSE}}"
}

verify_input_arguments()
{
    info "verify_input_arguments()"
    verbose "animations=$animations"
    verbose "app_apk=$app_apk"
    verbose "app_package=$app_package"
    verbose "device_density=$device_density"
    verbose "module=$module"
    verbose "show_ime_with_hard_keyboard=$show_ime_with_hard_keyboard"
    verbose "show_passwords=$show_passwords"
    verbose "test_apk=$test_apk"
    verbose "test_package=$test_package"
    verbose "test_runner=$test_runner"
    verbose "shard_count=$shard_count"
    verbose "shard_index=$shard_index"
    verbose "verbose=$verbose"
}

main()
{
    load_input_arguments "$@"

    if [ "$verbose" == true ] || [ "$VERBOSE" == true ]; then
        info "Verbose mode enabled"
    fi

    verify_input_arguments

    SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    verbose "SCRIPT_DIR: $SCRIPT_DIR"

    assert_emulator
    install_apk $app_apk $app_package package
    install_apk $test_apk $test_package instrumentation
    configure_emulator
    invoke_adb_command
    pretty_results
    archive_failed_images
    verify_test_status
}

main "$@"
