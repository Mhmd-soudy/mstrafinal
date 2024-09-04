import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mstra/core/utilis/color_manager.dart';
import 'package:mstra/core/utilis/general_utils.dart';
import 'package:mstra/core/utilis/space_widgets.dart';
import 'package:mstra/core/widgets/validators.dart';
import 'package:mstra/routes/routes_manager.dart';
import 'package:mstra/view/Auth/widgets/decoration.dart';
import 'package:mstra/view_models/auth_view_model.dart';
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

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLabel("البريد الالكترونى"),
                const VerticalSpace(0.01),
                _buildTextField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  nextFocusNode: passwordFocusNode,
                  hintText: "البريد الالكترونى",
                  icon: Icons.mail_outline,
                  validator: validateEmail,
                  textInputAction: TextInputAction.next,
                ),
                const VerticalSpace(0.03),
                _buildLabel("كلمة السر"),
                const VerticalSpace(0.01),
                _buildPasswordField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  hintText: "كلمة المرور",
                  validator: validatePassword,
                ),
                const VerticalSpace(0.03),
                CupertinoButton(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(255, 119, 197, 134),
                  child: const Text(
                    "تسجيل الدخول",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await authViewModel.login(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        context: context,
                      );
                    }
                  },
                ),
                const VerticalSpace(0.02),
                _buildRegisterText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.topRight,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    required TextInputAction textInputAction,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.right,
        textInputAction: textInputAction,
        validator: validator,
        onFieldSubmitted: (value) {
          if (nextFocusNode != null) {
            Utils.fieldFocusChange(context, focusNode, nextFocusNode);
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: ColorManager.indigoAccent),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: _buildBorder(),
          focusedBorder: _buildBorder(isFocused: true),
          errorBorder: _buildBorder(isError: true),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.right,
        obscureText: _obsecureText,
        validator: validator,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            icon: Icon(_obsecureText ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _obsecureText = !_obsecureText;
              });
            },
          ),
          suffixIcon: const Icon(
            Icons.lock_outline,
            color: ColorManager.indigoAccent,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: _buildBorder(),
          focusedBorder: _buildBorder(isFocused: true),
          errorBorder: _buildBorder(isError: true),
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(
      {bool isFocused = false, bool isError = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: isError
            ? Colors.red
            : isFocused
                ? ColorManager.indigoAccent
                : Colors.grey,
        width: 1.5,
      ),
    );
  }

  Widget _buildRegisterText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, RoutesManager.registerPage);
          },
          child: Text(
            "انشاء حساب",
            style: TextStyle(
              color: const Color.fromARGB(255, 119, 197, 134),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "لا تملك حساب؟",
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
      ],
    );
  }
}
