import 'package:flutter/material.dart';
import 'package:mstra/view/Auth/register/register_form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: const SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Center(
              child: SingleChildScrollView(
                child: RegisterForm(),
              ),
            ),
          )
        ],
      )),
    );
  }
}
