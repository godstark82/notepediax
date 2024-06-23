import 'package:course_admin/constants/styles/outline_button_style.dart';
import 'package:course_admin/functions/login_fun.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          height: context.height * 0.5,
          width: context.height * 0.5,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Login', style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 25),
                TextFormField(
                  validator: (value) {
                    if (value?.endsWith('@gmail.com') != true) {
                      return 'Enter a valid Email';
                    } else {
                      return null;
                    }
                  },
                  controller: _emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Admin Email'),
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email)),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  validator: (password) => password!.length >= 6
                      ? null
                      : 'Password should be atleast 6 letters',
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(),
                    label: Text('Admin Password'),
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 30),
                OutlinedButton.icon(
                    clipBehavior: Clip.hardEdge,
                    style: outlineButtonStyle,
                    onPressed: () async => _formKey.currentState!.validate()
                        ? LoginFunctions.loginAdmin(
                            _emailController.text, _passwordController.text)
                        : null,
                    icon: const Icon(Icons.login),
                    label: const Text('Login'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
