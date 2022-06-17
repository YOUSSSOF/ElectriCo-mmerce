import 'dart:convert';

import 'package:book_ecommerce/widgets/submit_button.dart';
import 'package:book_ecommerce/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../screens/profile_screen.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future register(username, password, email) async {
    http.Response response = await http.post(
        Uri.parse('http://127.0.0.1:8001/api/auth/users/'),
        body: {'username': username, 'password': password, 'email': email});
    if (response.statusCode == 200) return response.body;
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          TextInput(
            placeholder: 'Useranem',
            controller: _nameController,
          ),
          TextInput(
            placeholder: 'Email',
            controller: _emailController,
          ),
          TextInput(
            placeholder: 'Password',
            controller: _passwordController,
          ),
          SubmitButton(
            title: "Register",
            onPressed: () async {
              var username = _nameController.text;
              var password = _passwordController.text;
              var email = _emailController.text;

              var jwt = await register(username, password, email);
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
          )
        ],
      ),
    );
  }
}
