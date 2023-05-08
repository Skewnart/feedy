# Feedy

## Description

Feedy is a Flutter application to keep up to date watering and misting informations about all your house plants.

## Installation

Have [Flutter](https://docs.flutter.dev/get-started/install) up to date to compile the project.

Then run :

`flutter pub get`

**1) Debugging**

Plug smartphone. Then run `flutter run`

**1.1) WiFi debugging**

Once plugged in, run `adb tcpip 5555` then `adb connect ip_address`. Unplug.

**2) Build**

Run `flutter build apk` (for android), and move into *build\app\outputs\flutter-apk*.

Take *app.apk*

## Installation Firebase

In order to connect firebase with your project, you obviously need a flutter application and a [firebase project](https://console.firebase.google.com).

We now are going to install Firebase tools.

Download [Node](https://nodejs.org/en/download) to get `npm` command. It's also possible to install firebase by directly download the associated CLI. (For me, it did not work properly... So I advise you to go with npm.)

Then run `npm install -g firebase-tools` (Gives you the `firebase` command)

Connect to your firebase account with `firebase login` (and follow login instructions)

Activate firebase for flutter : Execute `dart pub global activate flutterfire_cli` and `flutterfire configure` in your project directory.

Keep in mind that you will always need to execute this last command each time you add firebase component in your project. 

Then setup mandatory firebase flutter files with `flutter pub add firebase_core` and again `flutterfire configure`

`fultter run`

Here you go ! ([Plugins list](https://firebase.google.com/docs/flutter/setup?hl=fr#available-plugins))
