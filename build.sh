#!/bin/bash

# Clean the Flutter project
flutter clean

# Get Flutter dependencies
flutter pub get
echo "Building Android..."

# Build the APK in release mode
flutter build apk --release -t lib/main_dev.dart

#get month
month=$(date "+%m")

#get day
day=$(date "+%d")

# build number
BUILD_NUMBER=1



# Copy the built APK to a new file with a timestamped filename
#cp build/app/outputs/flutter-apk/app-release.apk "appza_demo_v${month}.${day}.1.apk"

# works on mac
cp build/app/outputs/flutter-apk/app-release.apk  ~/Desktop/terminalbd_v${month}.${day}.${BUILD_NUMBER}.apk


# Output a message indicating that the build is complete
echo "APK created successfully"

# flutter build appbundle