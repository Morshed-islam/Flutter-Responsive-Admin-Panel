import 'package:core_dashboard/pages/add_job_post/add_job_post.dart';
import 'package:core_dashboard/pages/authentication/sign_in_page.dart';
import 'package:core_dashboard/pages/edit_job/edit_job_post.dart';
import 'package:core_dashboard/pages/entry_point.dart';
import 'package:core_dashboard/providers/add_job_post_provider.dart';
import 'package:core_dashboard/providers/auth_provider.dart';
import 'package:core_dashboard/providers/job_provider.dart';
import 'package:core_dashboard/shared/constants/routes_name.dart';
import 'package:core_dashboard/shared/navigation/routes.dart';
import 'package:core_dashboard/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey: "AIzaSyCx0AdlE-XHio_owRXpPZ6yxy8w4UKuXh4",
      authDomain: "jobapplyservicebd-1bda4.firebaseapp.com",
      projectId: "jobapplyservicebd-1bda4",
      storageBucket: "jobapplyservicebd-1bda4.appspot.com",
      messagingSenderId: "890086279190",
      appId: "1:890086279190:web:bddf43c0d69f5c5888cd37",
      measurementId: "G-9VYM65PJR7"
  ));
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => AddJobProvider()),
      ],
      child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(context),
      // theme: AppTheme.lightTheme,
      // routerConfig: routerConfig,
      initialRoute: RouteNames.initialRoute,
      onGenerateRoute: (settings){
        if (settings.name == RouteNames.editPageRoute) {
          final jobId = settings.arguments as String; // Extract the jobId
          return MaterialPageRoute(
            builder: (context) => EditJobPage(jobId: jobId),
          );
        }
        // Add other routes with `if` checks as needed
        return null;

      },
      routes: {
        RouteNames.initialRoute : (context) => const SignInPage(),
        RouteNames.entryPoint : (context) => const EntryPoint(),
        RouteNames.addJobRoute : (context) => const AddJobPage(),
        // RouteNames.editPageRoute : (context) =>  EditJobPage(id: ),
      },
    );
  }
}
