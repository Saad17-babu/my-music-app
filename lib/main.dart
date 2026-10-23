name: Build Android APK

on:
  push:
    branches: [ "main", "master" ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Java
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.x'
          channel: 'stable'

      - name: Create Flutter Project Structure
        run: |
          flutter create . --org com.example --project-name music_app
          
      - name: Inject Android Permissions
        run: |
          sed -i '/<application/i \    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>\n    <uses-permission android:name="android.permission.READ_MEDIA_AUDIO"/>' android/app/src/main/AndroidManifest.xml

      - name: Install dependencies
        run: flutter pub get

      - name: Build APK
        run: flutter build apk --release

      - name: Upload APK Artifact
        uses: actions/upload-artifact@v4
        with:
          name: app-release
          path: build/app/outputs/flutter-apk/app-release.apk
            
