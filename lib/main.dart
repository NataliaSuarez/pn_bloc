import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:pn_bloc/bloc/notification_bloc.dart';
import 'package:pn_bloc/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final notificationRepository = NotificationRepository();

  runApp(
    App(
      // navigatorKey: navigatorKey,
      notificationRepository: notificationRepository,
    ),
  );
}

class App extends StatelessWidget {
  const App({
    super.key,
    // required GlobalKey<NavigatorState> navigatorKey,
    required NotificationRepository notificationRepository,
  }) :
        // _navigatorKey = navigatorKey,
        _notificationRepository = notificationRepository;

  // final GlobalKey<NavigatorState> _navigatorKey;
  final NotificationRepository _notificationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _notificationRepository,
      child: BlocProvider(
        lazy: false,
        create: (context) => NotificationBloc(
          notificationRepository: context.read<NotificationRepository>(),
        ),
        child: MaterialApp(
          // navigatorKey: _navigatorKey,
          title: 'Push Notifications Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: Scaffold(
            body: BlocListener<NotificationBloc, NotificationState>(
              listenWhen: (previous, current) {
                return previous != current &&
                    current.notification != null &&
                    current.appState != null;
              },
              listener: (context, state) {
                final notification = state.notification!;
                if (state.appState!.isBackground) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: ListTile(
                        title: Text(notification.title),
                        subtitle: Text(notification.body),
                      ),
                    ),
                  );
                }
              },
              child: const Center(child: Text('Push Notifications!')),
            ),
          ),
        ),
      ),
    );
  }
}
