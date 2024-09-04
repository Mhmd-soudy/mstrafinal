import 'package:flutter/material.dart';
import 'package:mstra/core/utilis/assets_manager.dart';
import 'package:mstra/core/utilis/color_manager.dart';
import 'package:mstra/core/utilis/space_widgets.dart';
import 'package:mstra/view/Auth/login/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundcolor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  color: Color.fromARGB(
                      255, 119, 197, 134), // Background color of the wave
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const VerticalSpace(0.1),
                      Image.asset(
                        ImageAssets.authImage,
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(15),
                        child: Center(
                          child: SingleChildScrollView(
                            child: LoginForm(),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.4); // Move the wave up
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.4,
      size.width * 0.5,
      size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.2,
      size.width,
      size.height * 0.3,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
