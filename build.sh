#!/bin/bash

# Clean the Flutter project
flutter clean

# Get Flutter dependencies
flutter pub get
echo "Building Android..."

# Build the APK in release mode
flutter build apk --release -t lib/main_dev.dart

# Get the current date and time in the desired format
current_date=$(date "+%Y-%m-%d_%I:%M:%S_%p")

# Replace colons with hyphens to ensure it's a valid filename
sanitized_date=$(echo $current_date | tr ':' '-')

# Copy the built APK to a new file with a timestamped filename
cp build/app/outputs/flutter-apk/app-release.apk "sandra_${sanitized_date}.apk"

# Output a message indicating that the build is complete
echo "APK created successfully"