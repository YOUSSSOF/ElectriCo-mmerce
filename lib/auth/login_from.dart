import 'dart:convert';
import 'package:book_ecommerce/models/user.dart';
import 'package:book_ecommerce/screens/profile_screen.dart';
import 'package:book_ecommerce/widgets/submit_button.dart';
import 'package:book_ecommerce/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _loginFormKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Future login(username, password) async {
    http.Response response = await http
        .post(Uri.parse('http://127.0.0.1:8001/api/auth/jwt/create'), body: {
      'username': username,
      'password': password,
    });
    if (response.statusCode == 200) return response.body;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          TextInput(placeholder: 'Username', controller: _userNameController),
          TextInput(
            placeholder: 'Password',
            controller: _passwordController,
          ),
          SubmitButton(
            title: "Login",
            onPressed: () async {
              var username = _userNameController.text;
              var password = _passwordController.text;
              var jwt = await login(username, password);
              if (jwt != null) {
                var access = jsonDecode(jwt)["access"];
                http.Response response = await http.get(
                    Uri.parse("http://127.0.0.1:8001/api/auth/users/me/"),
                    headers: {
                      'Content-Type': 'application/json',
                      'Accept': 'application/json',
                      'Authorization': 'JWT $access'
                    });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProfileScreen(
                        profile: User.fromJson(
                          jsonDecode(response.body),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
