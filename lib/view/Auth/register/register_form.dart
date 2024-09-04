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
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              ImageAssets.authImage,
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.15,
            ),
            const VerticalSpace(0.02),
            _buildLabel("اسم المستخدم"),
            const VerticalSpace(0.01),
            _buildTextField(
              controller: nameController,
              hintText: "اسم المستخدم",
              icon: Icons.person_outline,
              validator: validateName,
              textInputAction: TextInputAction.next,
            ),
            const VerticalSpace(0.02),
            _buildLabel("البريد الالكترونى"),
            const VerticalSpace(0.01),
            _buildTextField(
              controller: emailController,
              hintText: "البريد الالكترونى",
              icon: Icons.mail_outlined,
              validator: validateEmail,
              textInputAction: TextInputAction.next,
            ),
            const VerticalSpace(0.02),
            _buildLabel("رقم الهاتف"),
            const VerticalSpace(0.01),
            _buildTextField(
              controller: phoneNumberController,
              hintText: "رقم الهاتف",
              icon: Icons.phone_outlined,
              validator: validatePhoneNumber,
              textInputAction: TextInputAction.next,
            ),
            const VerticalSpace(0.02),
            _buildLabel("كلمة المرور"),
            const VerticalSpace(0.01),
            _buildPasswordField(
              controller: passwordController,
              hintText: "كلمة المرور",
              validator: validatePassword,
            ),
            const VerticalSpace(0.02),
            _buildLabel("تأكيد كلمة المرور"),
            const VerticalSpace(0.01),
            _buildPasswordField(
              controller: passwordConfirmationController,
              hintText: "تأكيد كلمة المرور",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                } else if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const VerticalSpace(0.03),
            CupertinoButton(
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromARGB(255, 119, 197, 134),
              child: const Text(
                "تسجيل حساب",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await authViewModel.register(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    phone: phoneNumberController.text.trim(),
                    password: passwordController.text.trim(),
                    passwordConfirmation:
                        passwordConfirmationController.text.trim(),
                    context: context,
                  );
                }
              },
            ),
            const VerticalSpace(0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.popAndPushNamed(context, RoutesManager.loginPage);
                  },
                  child: Text(
                    "تسجيل الدخول",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 119, 197, 134),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "لديك حساب؟",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
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
        textAlign: TextAlign.right,
        textInputAction: textInputAction,
        validator: validator,
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
        obscureText: _obscureText,
        textAlign: TextAlign.right,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          suffixIcon: Icon(
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
}
