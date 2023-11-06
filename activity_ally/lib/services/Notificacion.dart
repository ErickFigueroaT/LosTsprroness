import 'package:activity_ally/Models/Activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart'as tz;

class Notificacion{
  
  Notificacion();
  
  final LNS = FlutterLocalNotificationsPlugin();
  
  Future<void> initialize() async{
    tz.initializeTimeZones();
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
      playSound: true,
      importance: Importance.max,
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
  //uiLocalNotificationDateInterpretation

   Future<void> NotificacionProgramada(Activity actividad) async{
      final details = await _notificationDetails();
      if (actividad.date.isAfter(DateTime.now())){
        await LNS.zonedSchedule(actividad.id, actividad.title, actividad.description, 
        tz.TZDateTime.from(actividad.date.add(Duration(seconds: 0)), tz.local), details,
        androidAllowWhileIdle:  true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
  }

  Future<void> NotificacionFin(Activity actividad) async{
      final details = await _notificationDetails();
      DateTime fin = DateTime.now().add(Duration(minutes: actividad.duration));

      await LNS.zonedSchedule(actividad.id, 'No olvides terminar tus activdades: ${actividad.title}', actividad.description, 
      tz.TZDateTime.from(fin.add(Duration(seconds: 0)), tz.local), details,
      androidAllowWhileIdle:  true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    
  }

  void onDidReciveLocalNotification(int id, String? body, String? payload){
    print('id, $id');
  }

  void onSelectNotification(String? payload){
    print('payload, $payload');
  }

  Future<bool> checkScheduledNotification(int notificationId) async {
    
    List<PendingNotificationRequest> pendingNotifications = await LNS.pendingNotificationRequests();

    return pendingNotifications.any((notification) => notification.id == notificationId);
  }

  Future<void> cancela(int id) async{
      LNS.cancel(id);

  }
  

}