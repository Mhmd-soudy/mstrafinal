import 'package:flutter/material.dart';
import 'package:mstra/core/utilis/assets_manager.dart';
import 'package:mstra/view_models/splash_view_model.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final splashViewModel = Provider.of<SplashViewModel>(context);

    Future.delayed(Duration(seconds: 3), () {
      splashViewModel.navigateToNextScreen(context);
    });

    return Scaffold(
      body: Center(
        child: AnimationConfiguration.synchronized(
          duration: const Duration(seconds: 2),
          child: FadeInAnimation(
            child: ScaleAnimation(
              child:
                  Image.asset(ImageAssets.splashLogo, width: 300, height: 300),
            ),
          ),
        ),
      ),
    );
  }
}
