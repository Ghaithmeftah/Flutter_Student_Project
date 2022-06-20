import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'loginpage.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formkey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  var loading = false;

  String? _requiredValidator(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'this field is required';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? confirmPasswordText) {
    if (confirmPasswordText == null || confirmPasswordText.trim().isEmpty) {
      return "this field is required";
    }

    if (_passwordController.text != confirmPasswordText) {
      return "passwords don't match";
    }
    return null;
  }

  void _handleSignUpError(FirebaseAuthException e) {
    String MessageToDisplay;
    switch (e.code) {
      case 'email-already-in-use':
        MessageToDisplay = 'this email is already in use ';
        break;
      case 'invalid-email':
        MessageToDisplay = 'The email you entered is invalid';
        break;
      case 'operation-not-allowed':
        MessageToDisplay = 'This operation is not allowed';
        break;
      case 'weak-password':
        MessageToDisplay = 'The password you entered is too weak';
        break;
      default:
        MessageToDisplay = 'an unknown error occured';
        break;
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Sign up failed'),
              content: Text(MessageToDisplay),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('ok'),
                )
              ],
            ));
  }

  Future _SignUp() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await FirebaseFirestore.instance.collection('users').add({
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Sign up succeeded'),
                content:
                    const Text('Your account was created ,you can now log in'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text('ok'))
                ],
              ));
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      _handleSignUpError(e);
      setState(() {
        loading = false;
      });
    }
  }

  String myField = 'EI';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
              color: Colors.black,
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Text("Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create an account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    )
                  ],
                ),
              ),
              Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    inputFile(
                        label: "Username",
                        controller: _nameController,
                        validator: _requiredValidator),
                    inputFile(
                        label: "Email",
                        Keyboardtype: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: _requiredValidator),
                    inputFile(
                      label: "Password",
                      obscureText: true,
                      controller: _passwordController,
                      validator: _requiredValidator,
                    ),
                    inputFile(
                        label: "Confirm Password",
                        obscureText: true,
                        validator: _confirmPasswordValidator,
                        controller: _confirmpasswordController),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "What's your field :",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        RadioListTile(
                          value: 'EI',
                          groupValue: myField,
                          onChanged: (value) {
                            setState(() {
                              myField = value.toString();
                            });
                          },
                          title: const Text("Electronique Industrielle"),
                        ),
                        RadioListTile(
                          value: 'MEC',
                          groupValue: myField,
                          onChanged: (value) {
                            setState(() {
                              myField = value.toString();
                            });
                          },
                          title: const Text("Mécatronique"),
                        ),
                        RadioListTile(
                          value: 'GMP',
                          groupValue: myField,
                          onChanged: (value) {
                            setState(() {
                              myField = value.toString();
                            });
                          },
                          title: const Text("Mécanique & Productique"),
                        ),
                        RadioListTile(
                          value: 'IA',
                          groupValue: myField,
                          onChanged: (value) {
                            setState(() {
                              myField = value.toString();
                            });
                          },
                          title: const Text("Informatique Appliquée"),
                        ),
                        RadioListTile(
                          value: 'GTE',
                          groupValue: myField,
                          onChanged: (value) {
                            setState(() {
                              myField = value.toString();
                            });
                          },
                          title: const Text("Telécommunications Embarquées"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              if (!loading) ...[
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: const Border(
                            bottom: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black))),
                    child: MaterialButton(
                      minWidth: 300,
                      height: 60,

                      onPressed: () {
                        if (_formkey.currentState != null &&
                            _formkey.currentState!.validate()) {
                          _SignUp();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        } else {
                          print("confirmer votre mot de passe");
                        }
                      },
                      color: const Color(0xff0095ff),
                      //color: Colors.teal,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    )),
              ],
              const SizedBox(height: 20)
            ],
          ),
        ));
  }
}

class inputFile extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? Keyboardtype;
  final FormFieldValidator<String?> validator;
  // ignore: use_key_in_widget_constructors
  const inputFile({
    required this.label,
    required this.controller,
    required this.validator,
    this.Keyboardtype,
    this.obscureText = false,
  });
  @override
  Widget build(BuildContext) {
    return SizedBox(
      height: 100.0,
      width: 300.0,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
              keyboardType: Keyboardtype,
              validator: validator,
            ),
            const SizedBox(
              height: 10,
            )
          ]),
    );
  }
}
