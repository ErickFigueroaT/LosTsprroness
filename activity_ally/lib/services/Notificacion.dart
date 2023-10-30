import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart';

class Notificacion{
  
  Notificacion();
  
  final LNS = FlutterLocalNotificationsPlugin();
  
  Future<void> initialize() async{
    const AndroidInitializationSettings
      ais = AndroidInitializationSettings('@mipmap/ic_launcher');

    InitializationSettings settings = InitializationSettings(android: ais);
    await LNS.initialize(settings);//, onSelectNotification: onSelectNotification(payload));
  }//

  Future<NotificationDetails> _notificationDetails() async{
    const AndroidNotificationDetails ANDetails = AndroidNotificationDetails(
      'channelId', 
      'channelName',
      channelDescription: 'desc',
      playSound: true
      );
      return NotificationDetails(android: ANDetails);

  }

  Future<void> showNotification(
  {
    required int id, 
    required String title, 
    required String body
    }) async{
      final details = await _notificationDetails();
      await LNS.show(id, title, body, details);
    
  }

  void onDidReciveLocalNotification(int id, String? body, String? payload){
    print('id, $id');
  }

  void onSelectNotification(String? payload){
    print('payload, $payload');
  }

  

}