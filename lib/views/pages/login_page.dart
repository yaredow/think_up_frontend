import 'package:flutter/material.dart';
import 'package:think_up_frontend/views/widget_tree.dart';
import 'package:think_up_frontend/views/widgets/hero_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  bool isFormvalid = false;
  bool emailTouched = false;
  bool passwordTouched = false;

  @override
  void initState() {
    controllerEmail.addListener(() {
      if (!emailTouched) {
        setState(() {
          emailTouched = true;
        });
      }
      _validateForm();
    });

    controllerPassword.addListener(() {
      if (!passwordTouched) {
        setState(() {
          passwordTouched = true;
        });
      }
      _validateForm();
    });

    super.initState();
  }

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid != isFormvalid) {
      setState(() {
        isFormvalid = isValid;
      });
    }
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (!emailTouched) return null;
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (!passwordTouched) return null;
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  HeroWidget(title: widget.title),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: controllerEmail,
                    validator: _validateEmail,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    controller: controllerPassword,
                    validator: _validatePassword,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  FilledButton(
                    onPressed: isFormvalid
                        ? () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return WidgetTree();
                                },
                              ),
                              (route) => false,
                            );
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      minimumSize: Size(double.infinity, 40.0),
                    ),
                    child: Text("Get Started"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
