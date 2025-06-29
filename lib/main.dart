import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
/*
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
*/
import 'pantalla_login.dart';
import 'registro_pantalla.dart';
import 'pantalla_main.dart';

/*
final FlutterLocalNotificationsPlugin notificacionesPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> inicializarNotificaciones() async {
  tz.initializeTimeZones();

  const AndroidInitializationSettings initAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initSettings = InitializationSettings(
    android: initAndroid,
  );

  await notificacionesPlugin.initialize(initSettings);
}
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  /*
  await inicializarNotificaciones();
  programarRecordatorioDiario();
  programarRecordatorioSemanal();
  */
  runApp(const MyApp());
}

/* REVISAR A FUTURO PARA NOTIFICACIONES, da error en flutter_native_timezone'. del yaml.
Future<void> programarRecordatorioDiario() async {
  final now = DateTime.now();
  DateTime horaProgramada =
      DateTime(now.year, now.month, now.day, 12, 0, 0);

  if (horaProgramada.isBefore(now)) {
    horaProgramada = horaProgramada.add(const Duration(days: 1));
  }

  await notificacionesPlugin.zonedSchedule(
    0,
    'Registrar comidas',
    'No olvides registrar tus comidas de hoy.',
    tz.TZDateTime.from(horaProgramada, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'canal_diario',
        'Recordatorio Diario',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

Future<void> programarRecordatorioSemanal() async {
  final now = DateTime.now();

  int diasHastaLunes = (DateTime.monday - now.weekday) % 7;
  if (diasHastaLunes == 0 && now.hour >= 12) {
    diasHastaLunes = 7;
  }

  DateTime lunesProgramado = DateTime(
      now.year, now.month, now.day + diasHastaLunes, 12, 0, 0);

  await notificacionesPlugin.zonedSchedule(
    1,
    'Planificación semanal',
    'Planifica tu semana de comidas.',
    tz.TZDateTime.from(lunesProgramado, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'canal_semanal',
        'Recordatorio Semanal',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
  );
}
*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/Inicio': (context) => const PantallaMain(),
        '/Login': (context) => PantallaLogin(),
        '/Registro': (context) => RegistroPantalla(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return const PantallaMain();
          }
          return PantallaLogin();
        },
      ),
    );
  }
}
