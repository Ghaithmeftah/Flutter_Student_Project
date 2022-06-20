import 'package:eniso_project/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../SemestreFireStore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<FirebaseApp> initializeFireBase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

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
      body: FutureBuilder(
        future: initializeFireBase(),
        builder: (context, snapchot) {
          if (snapchot.connectionState == ConnectionState.done) {
            return const Log();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class Log extends StatefulWidget {
  const Log({Key? key}) : super(key: key);

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {
  //login function
  static Future<User?> loginUsingEmailPassword(@required String email,
      @required String password, @required BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      var errorCode = e.code;
      var errorMessage = e.message;
      if (e.code == "user-not-found") {
        print("No User found for that email");
      } else if (errorCode == 'auth/wrong-password') {
        print('Wrong Password.');
      } else {
        print(errorMessage);
      }
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    //create the texfield controller
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    String? _requiredValidator(String? text) {
      if (text == null || text.trim().isEmpty) {
        return 'this field is required';
      }
      return null;
    }

    return SizedBox(
        height: 800,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            const Text("Login",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Login to your account",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[700]),
                            )
                          ],
                        ),
                        Form(
                          key: _formkey,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                              child: Column(
                                children: <Widget>[
                                  inputFile(
                                      label: "Email",
                                      controller: _emailController,
                                      key: TextInputType.emailAddress,
                                      validator: _requiredValidator),
                                  inputFile(
                                      label: "Password",
                                      obscureText: true,
                                      key: TextInputType.visiblePassword,
                                      controller: _passwordController,
                                      validator: _requiredValidator),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  const Text(
                                    "D'ont remember your password ?",
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            child: Container(
                                padding: const EdgeInsets.only(top: 0, left: 0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: const Border(
                                        bottom: BorderSide(color: Colors.black),
                                        top: BorderSide(color: Colors.black),
                                        left: BorderSide(color: Colors.black),
                                        right:
                                            BorderSide(color: Colors.black))),
                                child: MaterialButton(
                                  minWidth: double.infinity,
                                  height: 60,
                                  onPressed: () async {
                                    if (_formkey.currentState != null &&
                                        _formkey.currentState!.validate()) {
                                      User? user =
                                          await loginUsingEmailPassword(
                                              _emailController.text,
                                              _passwordController.text,
                                              context);
                                      if (user != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SemestreFireStore()),
                                        );
                                      }
                                    } else {
                                      print("this field is required");
                                    }
                                  },
                                  color: const Color(0xff0095ff),
                                  //color: Colors.teal,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("Don't have an account ?"),
                            TextButton(
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpPage()),
                                    )),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 100),
                          height: 200,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "images/e-learning-concept-isometric-mobile-or-smartphone-pencil-book-and-cloud-computing-for-study-on-green-and-white-background-online-study-from-home-online-course-e-book-store-free-vector.jpg"),
                                  fit: BoxFit.fitHeight)),
                        )
                      ]),
                ))
          ],
        ));
  }
}

Widget inputFile({label, obscureText = false, controller, key, validator}) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          keyboardType: key,
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ]);
}
