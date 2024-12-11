import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi{
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
   await messaging.requestPermission(
     alert: true,
   );
   final fcmToken=await messaging.getToken();
    print(fcmToken);
  }

  static Future<void> subscribeToTopic(String topic) async {
    await messaging.subscribeToTopic(topic);
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await messaging.unsubscribeFromTopic(topic);
  }
}