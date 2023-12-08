import 'package:brain_training_app/utils/file_utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationAPI {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    final largeIconPath = await FileUtils.downloadFile(
      'https://cdn-icons-png.flaticon.com/512/3301/3301556.png',
      'largeReminderImg',
    );
    final bigPicturePath = await FileUtils.downloadFile(
      'https://cdni.iconscout.com/illustration/premium/thumb/physiotherapist-helping-to-patient-6158363-5076554.png',
      'bigPhysioImg',
    );
    final styleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        largeIcon: FilePathAndroidBitmap(largeIconPath));
    const sound = 'notification_bell.wav';
    return NotificationDetails(
      android: AndroidNotificationDetails(
        "high_importance_channel",
        "NeuroFit Notifications",
        icon: "@mipmap/ic_launcher",
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound(sound.split('.').first),
        styleInformation: styleInformation,
      ),
    );
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: android);

    // when app is closed
    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.notificationResponse?.payload);
    }
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (notificationResponse) async {
        onNotifications.add(notificationResponse.payload);
      },
    );
    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      final local = tz.getLocation(locationName);
      tz.setLocalLocation(local);
    }
  }

  static Future showNotification(
          {int id = 0, String? title, String? body, String? payload}) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

  static void showScheduledNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledDate}) async {
    _notifications.zonedSchedule(
      id,
      title,
      body,
      _scheduleDaily(scheduledDate),
      await _notificationDetails(),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  static tz.TZDateTime _scheduleDaily(DateTime time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }

  static tz.TZDateTime _scheduleWeekly(DateTime time,
      {required List<int> days}) {
    tz.TZDateTime scheduledDate = _scheduleDaily(time);
    while (!days.contains(scheduledDate.weekday)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static void cancel(int id) => _notifications.cancel(id);

  static void cancelAll() => _notifications.cancelAll();
}

// How to call notification
// 1. normal click
// NotificationAPI.showNotification(
//   title: "This is a notification",
//   body: "This is the body of the notification",
//   payload: "This is the payload of the notification"
//   );
