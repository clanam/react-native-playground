#!/usr/bin/env bash

# Run this like
#
# ./local-install.sh
# <or>
# ./local-install.sh release
#
# It expects the sdk to be in the project's apks/ directory.

mode=$1 # expect "debug" or "release". defaults to "debug"

if [ -z $mode ]
then
  mode="debug"
fi

printf "Installing ${mode} APK 🐱\n\n"

# What devices do we have?
printf "List of attached devices (should have exactly one or script will fail):\n"
adb devices | grep -v "List of device"
printf "\n"

set -x

# handle device unauthorized (user may need to accept usb debugging on device)
adb kill-server

# handle incompatible package upgrade by uninstalling previous installs
adb uninstall com.playground > /dev/null 2>&1

# actually install
root_dir=`git rev-parse --show-toplevel`
adb install -r $root_dir/apks/app-$mode.apk
