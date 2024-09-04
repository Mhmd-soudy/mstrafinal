import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mstra/core/utilis/color_manager.dart';
import 'package:mstra/core/utilis/general_utils.dart';
import 'package:mstra/core/utilis/space_widgets.dart';
import 'package:mstra/core/widgets/validators.dart';
import 'package:mstra/routes/routes_manager.dart';
import 'package:mstra/view/Auth/widgets/decoration.dart';
import 'package:mstra/view_models/auth_view_model.dart';
import 'package:mstra/view_models/get_device_ip.dart';

import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  bool _obsecureText = true;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topRight,
                child: const Text(
                  "البريد الالكترونى",
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ),
              const VerticalSpace(0.01),
              TextFormField(
                focusNode: emailFocusNode,
                onFieldSubmitted: (value) {
                  Utils.fieldFocusChange(
                      context, emailFocusNode, passwordFocusNode);
                },
                textAlign: TextAlign.right,
                textInputAction: TextInputAction.next,
                validator: validateEmail,
                controller: emailController,
                decoration:
                    formDecoration("البريد الالكترونى", Icons.mail_outline),
              ),
              const VerticalSpace(0.03),
              Container(
                alignment: Alignment.topRight,
                child: const Text(
                  "كلمة السر",
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ),
              const VerticalSpace(0.01),
              TextFormField(
                  focusNode: passwordFocusNode,
                  obscureText: _obsecureText,
                  textAlign: TextAlign.right,
                  textInputAction: TextInputAction.next,
                  validator: validatePassword,
                  controller: passwordController,
                  decoration: InputDecoration(
                      errorStyle: const TextStyle(
                        fontSize: 10,
                      ),
                      prefixIcon: IconButton(
                        icon: Icon(_obsecureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obsecureText = !_obsecureText;
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
                      errorBorder: errorborder)),
              const VerticalSpace(0.03),
              // ButtonBar(
              //   children: [
              //     TextButton(
              //         onPressed: () {
              //           Navigator.pushReplacementNamed(
              //               context, RoutesManager.resetPasswordPage);
              //         },
              //         child: const Text("نسيت كلمة المرور؟",
              //             style: TextStyle(
              //               color: Colors.grey,
              //               fontSize: 17,
              //             )))
              //   ],
              // ),
              // const VerticalSpace(0.02),
              CupertinoButton(
                  borderRadius: BorderRadius.circular(15),
                  color: ColorManager.indigoAccent,
                  child: const Text(
                    "تسجيل الدخول",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await authViewModel.login(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          context: context);
                    }
                  }),

              const VerticalSpace(0.02),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, RoutesManager.registerPage);
                  },
                  child: const Text("انشاء حساب",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      )),
                ),
                const Text(
                  "لا تملك حساب؟",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                  ),
                ),
              ]),
            ],
          ),
        ));
  }
}
