import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const PushNotificationLabApp());
}

class PushNotificationLabApp extends StatelessWidget {
  const PushNotificationLabApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 14: Push Notifications',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NotificationHomePage(),
    );
  }
}

class NotificationHomePage extends StatefulWidget {
  const NotificationHomePage({super.key});
  @override
  State<NotificationHomePage> createState() => _NotificationHomePageState();
}

class _NotificationHomePageState extends State<NotificationHomePage> {
  String _fcmToken = "Retrieving Token...";
  String _lastMessage = "No messages yet";

  @override
  void initState() {
    super.initState();
    _setupPushNotifications();
  }

  Future<void> _setupPushNotifications() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      try {
        final token = await FirebaseMessaging.instance.getToken();
        setState(() { _fcmToken = token ?? "Failed to get token"; });
        debugPrint("FCM Device Token: $_fcmToken");
      } catch (e) {
        setState(() { _fcmToken = "Error getting token."; });
        debugPrint("Error: $e");
      }
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        debugPrint("Token Refreshed: $newToken");
        setState(() { _fcmToken = newToken; });
      });
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a foreground message!');
        debugPrint('Data: ${message.data}');
        setState(() {
          _lastMessage = message.notification?.title ?? "Message received without title";
        });
        if (message.notification != null) {
          debugPrint('Title: ${message.notification?.title}');
          debugPrint('Body: ${message.notification?.body}');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("New Alert: ${message.notification?.title}"),
              duration: const Duration(seconds: 3),
            ));
          }
        }
      });
    } else {
      setState(() { _fcmToken = "Permission Denied"; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notification Lab'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Your FCM Device Token:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: SelectableText(_fcmToken,
                style: const TextStyle(fontFamily: "monospace", fontSize: 12)),
            ),
            const SizedBox(height: 32),
            const Text("Last Foreground Message:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(_lastMessage, style: const TextStyle(fontSize: 16)),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _setupPushNotifications,
              child: const Text("Refresh Token & Listeners"),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
