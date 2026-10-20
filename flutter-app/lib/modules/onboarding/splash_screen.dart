
import 'package:flutter/material.dart';

import '../../app/widget/app_logo.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          child: AppLogo(),
          
        )
      ),
    );
  }
}