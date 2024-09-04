import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mstra/core/utilis/assets_manager.dart';
import 'package:mstra/core/utilis/color_manager.dart';
import 'package:mstra/core/utilis/space_widgets.dart';
import 'package:mstra/core/widgets/validators.dart';
import 'package:mstra/routes/routes_manager.dart';
import 'package:mstra/view/Auth/widgets/decoration.dart';
import 'package:mstra/view/Auth/widgets/label_text.dart';
import 'package:mstra/view_models/auth_view_model.dart'; // Import the AuthViewModel
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmationController;

  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmationController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              ImageAssets.authImage,
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.25,
            ),
            const VerticalSpace(0.02),
            Container(
              alignment: Alignment.centerRight,
              child: LabelText(labeltext: "اسم المستخدم"),
            ),
            const VerticalSpace(0.005),
            TextFormField(
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.next,
              validator: validateName,
              controller: nameController,
              decoration: formDecoration("اسم المستخدم", Icons.person_outline),
            ),
            const VerticalSpace(0.02),
            Container(
              alignment: Alignment.centerRight,
              child: LabelText(labeltext: "البريد الالكترونى"),
            ),
            const VerticalSpace(0.005),
            TextFormField(
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.next,
              validator: validateEmail,
              controller: emailController,
              decoration:
                  formDecoration("البريد الالكترونى", Icons.mail_outlined),
            ),
            const VerticalSpace(0.02),
            Container(
              alignment: Alignment.centerRight,
              child: LabelText(labeltext: "رقم الهاتف"),
            ),
            const VerticalSpace(0.005),
            TextFormField(
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.next,
              validator: validatePhoneNumber,
              controller: phoneNumberController,
              decoration: formDecoration("رقم الهاتف", Icons.phone_outlined),
            ),
            const VerticalSpace(0.02),
            Container(
              alignment: Alignment.centerRight,
              child: LabelText(labeltext: "كلمة المرور"),
            ),
            const VerticalSpace(0.005),
            TextFormField(
              obscureText: _obscureText,
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.next,
              validator: validatePassword,
              controller: passwordController,
              decoration: InputDecoration(
                errorStyle: const TextStyle(fontSize: 10),
                prefixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                hintTextDirection: TextDirection.rtl,
                suffixIcon: const Icon(
                  Icons.lock_outline,
                  color: ColorManager.indigoAccent,
                ),
                errorMaxLines: 3,
                hintText: "كلمة المرور",
                contentPadding: const EdgeInsets.all(5),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                ),
                enabledBorder: enabledborder,
                focusedBorder: focusedborder,
                errorBorder: errorborder,
              ),
            ),
            const VerticalSpace(0.02),
            Container(
              alignment: Alignment.centerRight,
              child: LabelText(labeltext: "تأكيد كلمة المرور"),
            ),
            const VerticalSpace(0.005),
            TextFormField(
              obscureText: _obscureText,
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                } else if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              controller: passwordConfirmationController,
              decoration: InputDecoration(
                errorStyle: const TextStyle(fontSize: 10),
                prefixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                hintTextDirection: TextDirection.rtl,
                suffixIcon: const Icon(
                  Icons.lock_outline,
                  color: ColorManager.indigoAccent,
                ),
                errorMaxLines: 3,
                hintText: "تأكيد كلمة المرور",
                contentPadding: const EdgeInsets.all(5),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                ),
                enabledBorder: enabledborder,
                focusedBorder: focusedborder,
                errorBorder: errorborder,
              ),
            ),
            const VerticalSpace(0.03),
            CupertinoButton(
              borderRadius: BorderRadius.circular(15),
              color: ColorManager.indigoAccent,
              child: const Text(
                "تسجيل حساب",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await AuthViewModel().register(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    phone: phoneNumberController.text.trim(),
                    password: passwordController.text.trim(),
                    passwordConfirmation:
                        passwordConfirmationController.text.trim(),
                    context: context,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
            ),
            const VerticalSpace(0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.popAndPushNamed(context, RoutesManager.loginPage);
                  },
                  child: const Text(
                    "تسجيل الدخول",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                ),
                const Text(
                  "لديك حساب؟",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
