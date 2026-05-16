# Laboratory Activity Week 14: Push Notifications Integration

**Course:** Mobile Application Development  
**Activity:** Engaging Users Through Real-Time Alerts via Firebase Cloud Messaging  
**Student Name:** [Your Name]  
**Date:** [Submission Date]  

---

## 🎯 1. Activity Objectives
The primary objective of this laboratory activity is to successfully integrate Firebase Cloud Messaging (FCM) into a Flutter application. This involves configuring the Firebase project, retrieving a unique device registration token, and properly handling push notifications across different application states (foreground and background) to engage users with real-time alerts.

---

## 🛠️ 2. Tools & Environment
*   **IDE**: Visual Studio Code (VS Code)
*   **Framework**: Flutter SDK
*   **Backend Services**: Firebase Console (Firebase Core & Firebase Messaging)
*   **Testing Environment**: Android Emulator / Physical Device

---

## ✅ 3. Laboratory Deliverables & Implementation

### A. Working Application Setup
The application has been successfully configured and linked to the Firebase project. 
* The `google-services.json` file was downloaded and securely placed inside the `android/app/` directory. 
* The `firebase_core` and `firebase_messaging` plugins were added to `pubspec.yaml`.
* The Firebase backend was initialized by invoking `Firebase.initializeApp()` inside the `main()` function.

### B. Core Code Implementation

#### 1. Token Retrieval Initialization
The following snippet demonstrates how the FCM Device Token is retrieved. This token acts as the unique identifier for the device, which is required to send targeted notifications from the Firebase Console.

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> retrieveDeviceToken() async {
  // Request notification permissions (required for iOS and Android 13+)
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
  
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // Retrieve the unique FCM registration token
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("🔑 FCM Device Token: $fcmToken");
    
    // Set up an onTokenRefresh listener to handle token updates
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("🔄 Token Refreshed: $newToken");
      // TODO: Send the new token to the backend server if applicable
    });
  } else {
    print("⚠️ User declined or has not accepted permission");
  }
}
```

#### 2. Foreground Notification Listener (`onMessage`)
When a notification is received while the app is actively running in the foreground, it is processed via the `onMessage` stream. The code below logs the incoming payload.

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

void setupForegroundListener() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📥 Got a message whilst in the foreground!');
    print('Message data payload: ${message.data}');

    // Check if the message contains a notification payload
    if (message.notification != null) {
      print('🔔 Notification Title: ${message.notification?.title}');
      print('🔔 Notification Body: ${message.notification?.body}');
    }
  });
}
```

---

## 📸 4. Visual Evidence & Execution

> [!IMPORTANT]  
> Replace the bracketed placeholders below with your actual token and screenshots before submitting this document to the LMS.

### 🔑 FCM Device Token
**Target Device Token:** `[PASTE_YOUR_COPIED_FCM_TOKEN_HERE]`

### 📤 1. Sent Notification (Firebase Console)
*Screenshot of the Firebase Console showing the notification configuration, target token, and "Sent/Published" status.*

![Firebase Console Notification Setup]([INSERT_SCREENSHOT_HERE])

### 📱 2. Received Notification (Device/Emulator Tray)
*Screenshot of the push notification successfully appearing on the device/emulator notification tray.*

![Device Notification Tray]([INSERT_SCREENSHOT_HERE])

### 💻 3. Working App Console Output
*Screenshot showing the Flutter app running successfully, with the FCM token and incoming message printed to the debug console.*

![Working App Debug Console]([INSERT_SCREENSHOT_HERE])

---
*Grading Breakdown Reference: Completion = 60% | Code Quality = 20% | Screenshots = 20%*
