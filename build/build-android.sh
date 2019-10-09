#!/usr/bin/env bash

root_dir=`git rev-parse --show-toplevel`

# Enter android directory where gradlew is
cd $root_dir/Playground/android

# clean stuff out from old builds
rm app/src/main/res/raw/app.json > /dev/null 2>&1
rm app/src/main/res/drawable-mdpi/*.png > /dev/null 2>&1

# Build the release apk
./gradlew assembleRelease \
  --no-daemon \
  --max-workers 4 \
  -Drelease=true \
  -Dorg.gradle.caching=true \
  -Dorg.gradle.configureondemand=true \
  -Dkotlin.compiler.execution.strategy=in-process

mkdir -p $root_dir/apks
cp app/build/outputs/apk/release/*.apk $root_dir/apks

# Return to previous directory
cd -

# FYI You still need to sign your release APK!
