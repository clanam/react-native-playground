#!/usr/bin/env bash

starting_dir=$(pwd)
root_dir=`git rev-parse --show-toplevel`

# Prep the debug build to not require its assets from the development server.
# the --dev false flag is important!
cd $root_dir/Playground
mkdir -p android/app/src/main/assets
./node_modules/.bin/react-native bundle \
  --platform android \
  --dev false \
  --entry-file index.js \
  --bundle-output android/app/src/main/assets/index.android.bundle \
  --assets-dest android/app/src/main/res \
  --sourcemap-output android/app/src/main/assets/index.android.bundle.map

# Enter android directory where gradlew is
cd android

# Build the debug apk
./gradlew assembleDebug \
  --no-daemon \
  --max-workers 4 \
  -Drelease=true \
  -Dorg.gradle.caching=true \
  -Dorg.gradle.configureondemand=true \
  -Dkotlin.compiler.execution.strategy=in-process

mkdir -p $root_dir/apks
cp app/build/outputs/apk/debug/*.apk $root_dir/apks

# return to previous directory
cd $starting_dir
