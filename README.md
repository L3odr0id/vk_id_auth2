# VK ID Auth 2

A Flutter plugin for auth via VK ID SDK. The plugin allows you to log in using VK ID SDK and receive an
access token and user data.

# This package is a fork of https://pub.dev/packages/vk_id_auth, but VK ID SDK updated to 2.x

## Getting Started

1. add vk_id_auth2 to your pubspec.yaml file;
2. create an app on VK.com;
3. setup android;
4. setup ios.

## VK ID SDK version, used in plugin

- IOS: 2.2.1

- ANDROID: 2.2.1

## Minimum requirements

- IOS 12.0


- ANDROID minSdkVersion 21

## SDK Documentation:

- [iOS SDK](https://id.vk.com/about/business/go/docs/ru/vkid/latest/vk-id/connection/ios/install)


- [Android SDK](https://id.vk.com/about/business/go/docs/ru/vkid/latest/vk-id/connection/android/install)

## ANDROID SETUP

### Installation

Run these commands:

1. flutter pub add vk_id_auth2 or add it to pubspec.yaml manually

2. flutter pub get

### Create proguard-rules.pro in android/app folder and insert next rows:

```
-dontwarn com.my.tracker.**
-dontwarn com.vk.**
-dontwarn kotlinx.parcelize.Parcelize
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**
-dontwarn com.google.errorprone.annotations.Immutable
```

### Change android/build.gradle:
    
```
    // If there buildscript.
    buildscript {
        ext.kotlin_version = <kotlin_version>
        repositories {
        ...
        // Insert row.
        maven {
            url("https://artifactory-external.vkpartner.ru/artifactory/vkid-sdk-andorid/")
        }
    }

    allprojects {
        repositories {
            ...
            // Insert row.
            maven {
                url("https://artifactory-external.vkpartner.ru/artifactory/vkid-sdk-andorid/")
            }
        }
    }
```

### Change android/app/build.gradle:

```
    defaultConfig {
        // Set minSdkVersion to 21.
        minSdkVersion 21
        ...
        // Set data from VK app settings.
        manifestPlaceholders += [
                VKIDClientID: 'APPID',
                VKIDClientSecret: 'CLIENTSECRET',
                VKIDRedirectHost: 'vk.com',
                VKIDRedirectScheme: 'vk[APPID]'
        ]
    }
```

### You may also need to update your project's Kotlin version.

Flutter Docs: https://docs.flutter.dev/release/breaking-changes/kotlin-version

## IOS SETUP

### Installation

Run these commands:

1. flutter pub add vk_id_auth2 or add it to pubspec.yaml manually

2. flutter pub get

3. set min IOS version 12.0

4. pod install --repo-update

### Change Info.plist

```
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>vkauthorize-silent</string>
</array>
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>auth_callback</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>vk52569562</string> /// Replace 123456 with your application ID.
        </array>
    </dict>
</array>
<key>CLIENT_ID</key>
<string>52569562</string>  /// Replace 123456 with your application ID.
<key>CLIENT_SECRET</key>
<string>iA79AHTZeSLSDkjZDycJ</string> /// Replace XXXXXXXXXXX with your application client secret.
```

### Add Universal Link support

When setting up an application in the VK ID authorization service account, specify the Universal Link through which 
the authorization provider will open your application. Add [Universal Links](https://developer.apple.com/documentation/xcode/supporting-associated-domains?language=objc) support to your application.

#### Example of Runner.entitlements

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.developer.associated-domains</key>
	<array>
		<string>applinks:vk.id.auth.example.com</string>
	</array>
</dict>
</plist>
```

## Example of usage

```dart
Future<void> _doEverything() async {
    try {
      final isInit = await VkIdAuth().isInitialized;
      if (!isInit) {
        await VkIdAuth().initialize();
      }
      print('Initialized');
      final res = await VkIdAuth().login(['phone']);
      final phone = res?.userData.phone;
      print('Result: ${res?.token} phone: $phone');
  } on Object catch (error, stackTrace) {
    // ...
  }
}
```

## Error codes

- initialization_failed - an error occurred while initializing the plugin;


- auth_cancelled - auth cancelled by user;


- not_initialized - plugin has not been initialized;


- unknown - unknown error;


- context_null - an error occurred while trying to retrieve the Context (only ANDROID);


- lifecycle_owner_null - an error occurred while trying to retrieve the LifecycleOwner (only ANDROID);


- ui_view_controller_null - an error occurred while trying to retrieve the UIViewController (only IOS);


- cant_read_client_id - an error occurred while trying to get the CLIENT_ID (only IOS);


- cant_read_client_secret - an error occurred while trying to get the CLIENT_SECRET (only IOS);


- auth_already_in_progress - an error occurred when authorization was called when auth is already in progress (only IOS);

## Error handling

```dart
Future<void> method() async {
  try {
    // ...
  } on PlatformException catch (error, stackTrace) {
    if (error.code == "initialization_failed") {
      print('An error occurred while initializing the plugin!');
    } else {
      // ...
    }
  }
}
```