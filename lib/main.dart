import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locomotive21/cubit/auth_cubit.dart';
import 'package:locomotive21/cubit/event_cubit.dart';
import 'package:locomotive21/cubit/register_cubit.dart';
import 'package:locomotive21/cubit/search_cubit.dart';
import 'package:locomotive21/pages/loading.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Remove this method to stop OneSignal Debugging
  // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("cd22c7df-d2d2-48e7-846f-753162efb144");

  // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => EventCubit()),
        BlocProvider(create: (context) => SearchCubit()),
      ],
      child: MaterialApp(
        title: 'Locomotive 21 App',
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: Colors.indigo.shade600,
            surface: Colors.white,
          ),
          cardTheme: CardTheme(
            color: Colors.white,
            surfaceTintColor: Colors.indigo.shade400,
          ),
          useMaterial3: true,
        ),
        home: const LoadingScreen(),
      ),
    );
  }
}
