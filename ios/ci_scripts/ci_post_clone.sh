#!/bin/sh
set -e

echo "=== Step 0: Move to project root ==="
cd $CI_PRIMARY_REPOSITORY_PATH

echo "=== Step 1: Flutter SDK 설치/확인 ==="
FLUTTER_DIR="$HOME/flutter"
if [ ! -d "$FLUTTER_DIR/bin" ]; then
    echo "Cloning Flutter SDK..."
    git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_DIR"
fi
export PATH="$FLUTTER_DIR/bin:$PATH"
flutter --version

echo "=== Step 2: Flutter 의존성 설치 ==="
flutter pub get

echo "=== Step 3: CocoaPods 확인 ==="
pod --version || echo "CocoaPods not installed"

echo "=== Step 4: Pod install ==="
pod install --project-directory=ios --repo-update

echo "=== Step 5: Flutter iOS build ==="
flutter build ios --no-codesign -t lib/main.dart

echo "=== Step 6: Done ==="
exit 0