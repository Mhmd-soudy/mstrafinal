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
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const VerticalSpace(0.1),
                  Image.asset(
                    ImageAssets.authImage,
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.25,
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
      ),
    );
  }
}
