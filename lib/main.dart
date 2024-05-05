import 'package:find_your_room_nepal/constant/api_url.dart';
import 'package:find_your_room_nepal/view/login_screen.dart';
import 'package:find_your_room_nepal/view/main_screen.dart';
import 'package:find_your_room_nepal/view_model.dart/auth_view_model.dart';
import 'package:find_your_room_nepal/view_model.dart/room_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.indigo,
        ),
        home: SessionHandler(),
      ),
    );
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
    if (token == null) {
      return const LoginScreen();
    } else {
      return const HomeScreen();
    }
  }
}
