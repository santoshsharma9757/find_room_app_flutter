import 'package:find_your_room_nepal/constant/api_url.dart';
import 'package:find_your_room_nepal/view/login_screen.dart';
import 'package:find_your_room_nepal/view/main_screen.dart';
import 'package:find_your_room_nepal/view_model.dart/auth_view_model.dart';
import 'package:find_your_room_nepal/view_model.dart/room_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("AuthBox");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.indigo, // Change this to the desired color
    ));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthViewModel()),
          ChangeNotifierProvider(create: (context) => RoomViewModel())
        ],
        child: KhaltiScope(
            publicKey: "test_public_key_4145e1c7bd524ccfb590bb0b19450ccb",
            enabledDebugging: true,
            builder: (context, navKey) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColor: Colors.indigo,
                ),
                home: SessionHandler(),
                navigatorKey: navKey,
                localizationsDelegates: const [
                  KhaltiLocalizations.delegate,
                ],
              );
            }));
  }
}

class SessionHandler extends StatefulWidget {
  const SessionHandler({super.key});

  @override
  _SessionHandlerState createState() => _SessionHandlerState();
}

class _SessionHandlerState extends State<SessionHandler> {
  final _appUrl = AppUrl();
  String? token;
  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    final fetchedToken = await _appUrl.readToken();
    setState(() {
      token = fetchedToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (token == null || token == "") {
      return const LoginScreen();
    } else {
      return const HomeScreen();
    }
  }
}
