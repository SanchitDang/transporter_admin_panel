import 'package:admin/screens/main/main_screen.dart';
import 'package:admin/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/injection_container.dart' as di;
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyArkP8jpFipJdTpYuwX45QSevEaIMPxEJo",
            authDomain: "transporter-3634f.firebaseapp.com",
            projectId: "transporter-3634f",
            storageBucket: "transporter-3634f.appspot.com",
            messagingSenderId: "828241845214",
            appId: "1:828241845214:web:bb1f7c4ab83bda11be9b4f",
            measurementId: "G-D8DDNGWHTW"
        ));

  } else {
    await Firebase.initializeApp();
  }
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transporter Admin',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: MainScreen(),
    );
  }
}
