import 'dart:developer';

import 'package:core_dashboard/pages/authentication/register_page.dart';
import 'package:core_dashboard/pages/dashboard/dashboard_page.dart';
import 'package:core_dashboard/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:core_dashboard/shared/constants/config.dart';
import 'package:core_dashboard/shared/constants/defaults.dart';
import 'package:core_dashboard/shared/constants/ghaps.dart';

import '../../shared/constants/routes_name.dart';
import '../entry_point.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController(text: "admin@gmail.com");
  final TextEditingController _passwordController = TextEditingController(text: "11111111");
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkIfUserIsLoggedIn();
  }

  void _checkIfUserIsLoggedIn() async {
    final authService = Provider.of<AuthProvider>(context, listen: false);
    if (authService.user != null) {
      // If user is already authenticated, navigate to the home page
      Navigator.pushNamed(context, RouteNames.entryPoint);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 296,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDefaults.padding * 1.5,
                      ),
                      child: SvgPicture.asset(AppConfig.logo),
                    ),
                    Text(
                      'Sign In',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    gapH24,
                    const Divider(),
                    gapH24,
                    Text(
                      'Continue with email address',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    gapH16,

                    /// EMAIL TEXT FIELD
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/mail_light.svg',
                          height: 16,
                          width: 20,
                          fit: BoxFit.none,
                        ),
                        hintText: 'Your email',
                      ),
                    ),
                    gapH16,

                    /// PASSWORD TEXT FIELD
                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/lock_light.svg',
                          height: 16,
                          width: 20,
                          fit: BoxFit.none,
                        ),
                        hintText: 'Password',
                      ),
                    ),
                    gapH16,

                    /// SIGN IN BUTTON
                    SizedBox(
                      width: 296,
                      child: ElevatedButton(
                        onPressed: () async {
                          log("clicked");
                          try {
                            await authService.signInWithEmail(
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (authService.user != null) {
                              // If sign-in is successful, navigate to the home page
                              Navigator.pushReplacementNamed(context, RouteNames.entryPoint);
                            }
                          } catch (e) {
                            setState(() {
                              _errorMessage = e.toString();
                            });
                          }
                        },
                        child: const Text('Sign in'),
                      ),
                    ),
                    gapH16,
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    gapH24,

                    /// FOOTER TEXT
                    Text(
                      'This site is protected by reCAPTCHA and the Google Privacy Policy.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    gapH24,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
