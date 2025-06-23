import 'package:app_todolist/controller/notification_controller.dart';
import 'package:app_todolist/providers/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'view/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationController().initialize();

  FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
  



  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CalendarProvider>(create: (_) => CalendarProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apps ToDo',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
