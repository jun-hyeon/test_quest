#!/bin/sh
set -e

cd $CI_PRIMARY_REPOSITORY_PATH

echo "=== Step 1: Flutter SDK ==="
FLUTTER_DIR="$HOME/flutter"
if [ ! -d "$FLUTTER_DIR/bin" ]; then
    echo "Cloning Flutter SDK..."
    git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_DIR"
fi
export PATH="$FLUTTER_DIR/bin:$PATH"
flutter --version

echo "=== Step 2: Flutter precache iOS ==="
flutter precache --ios

echo "=== Step 3: Flutter pub get ==="
flutter pub get

echo "=== Step 4: CocoaPods check ==="
pod --version

echo "=== Step 5: Pod install ==="
cd ios
pod install --repo-update
cd ..

echo "=== Step 6: Done ==="
exit 0