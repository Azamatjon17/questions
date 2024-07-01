import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lesson66/services/AuthUserFairbases.dart';


class RegistPage extends StatefulWidget {
  const RegistPage({super.key});

  @override
  State<RegistPage> createState() => _RegistPageState();
}

class _RegistPageState extends State<RegistPage> {
  Authuserfairbases authuserfairbases = Authuserfairbases();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? email;
  String? password;

  submit() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      await authuserfairbases.register(email: email!, password: password!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.abc,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "email",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'email kriting';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    email = newValue;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "password",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'password kriting';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    password = newValue;
                  },
                ),
                FilledButton(
                  onPressed: submit,
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("register"),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("login page"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
