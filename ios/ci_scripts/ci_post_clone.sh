#!/bin/bash
set -e

echo "=== Step 1: Flutter SDK 설치 ==="
FLUTTER_DIR="$HOME/flutter"
if [ ! -d "$FLUTTER_DIR/bin" ]; then
    echo "Flutter SDK를 설치합니다..."
    git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_DIR"
fi
export PATH="$FLUTTER_DIR/bin:$PATH"
flutter --version

echo "=== Step 2: Flutter 의존성 설치 ==="
flutter precache --ios
flutter pub get

echo "=== Step 3: CocoaPods 설치 ==="
HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods

echo "=== Step 4: iOS 의존성 설치 ==="
cd ios
pod install --repo-update
cd ..

echo "=== Step 5: Flutter 빌드 ==="
flutter build ios --no-codesign -t lib/main.dart

exit 0