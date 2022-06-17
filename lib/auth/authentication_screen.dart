import 'package:book_ecommerce/auth/login_from.dart';
import 'package:book_ecommerce/auth/register_form.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

enum FormMode {
  login,
  register,
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  FormMode currentForm = FormMode.login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentForm == FormMode.register ? 'Register' : 'Login',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 10),
            if (currentForm == FormMode.register) const RegisterForm(),
            if (currentForm == FormMode.login) const LoginForm(),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  if (currentForm == FormMode.register) {
                    currentForm = FormMode.login;
                  } else {
                    currentForm = FormMode.register;
                  }
                });
              },
              child: Text(
                currentForm == FormMode.register
                    ? 'Already have an account ? '
                    : 'Are you new ?',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
