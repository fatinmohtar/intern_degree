import 'package:flutter/material.dart';
import 'home.dart';
import 'forgot_pass.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _rememberMe = false;

  void _onRememberMeChanged(bool newValue) {
    setState(() {
      _rememberMe = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            //the top-left picture
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset(
                'assets/images/top-left-triangle.png',
                width: MediaQuery.of(context).size.height * 0.25,
                height: MediaQuery.of(context).size.height * 0.25,
              ),
            ),

            //the background picture
            Positioned(
              top: MediaQuery.of(context).size.height / 2 -
                  (MediaQuery.of(context).size.height * 0.75) / 2,
              right: 0,
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/background.png',
                  width: MediaQuery.of(context).size.height * 0.33,
                  height: MediaQuery.of(context).size.height * 0.72,
                  fit: BoxFit.fill,
                ),
              ),
            ),

            //For triangle at bottom
            Align(
                alignment: Alignment.bottomLeft,
                child: Image.asset(
                  'assets/images/bottom-left-triangle.png',
                  width: MediaQuery.of(context).size.height * 0.25,
                  height: MediaQuery.of(context).size.height * 0.25,
                )),

            //position for lsf-logo
            Positioned(
              left: MediaQuery.of(context).size.width * 0.02,
              top: MediaQuery.of(context).size.height * 0.02,
              child: Image.asset(
                'assets/images/lsf_logo.png',
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.18,
              ),
            ),
            //position  for jarvis logo
            Positioned(
              left: MediaQuery.of(context).size.width * 0.25,
              top: MediaQuery.of(context).size.height * 0.10,
              child: Image.asset(
                'assets/images/jarvis_title.png',
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.35,
              ),
            ),

            //user form login
            //use singleChildScrollView to solve the softkeyboard bottom overflow issue
            SingleChildScrollView(
              child: Padding(
                //this code below use to make sure the padding will follow the device size
                padding: EdgeInsets.fromLTRB(
                  0.05 * MediaQuery.of(context).size.width,
                  0.35 * MediaQuery.of(context).size.height,
                  0.05 * MediaQuery.of(context).size.width,
                  0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //style welcome back
                      Text(
                        'WELCOME BACK !',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[900],
                        ),
                      ),
                      const SizedBox(height: 16),

                      //text for log in
                      Text(
                        'Log In to Your Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),

                      const SizedBox(height: 16),

                      //username part
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "username",
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          
                        ),
                      ),

                      const SizedBox(height: 16.0),
                      //enter password part
                      TextFormField(
                        obscureText: !_passwordVisible,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),

                      const SizedBox(height: 6.0),

                      // row that have 3 child: checkbox, text remember me and forgot password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (newValue) {
                              setState(() {
                                _rememberMe = newValue!;
                              });
                              _onRememberMeChanged(newValue!);
                            },
                          ),
                          const SizedBox(width: 0),
                          const Text(
                            "Remember Me",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // TODO: Implement forgot password functionality
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPass()),
                                  );
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14.0),

                      //button for login part
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // All form fields are valid, perform login action
                            String username = _usernameController.text;
                            String password = _passwordController.text;

                            if (username == 'admin' && password == 'admin') {
                              // Correct username and password, navigate to next page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );
                            } else {
                              // Incorrect username or password
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Login Failed'),
                                  content: const Text(
                                      'Please enter a valid username/password.'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.amber),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(double.infinity, 50)),
                        ),
                        child:const  Text("LOGIN"),
                      ),

                      //row that have 2 element : text and signUP pressed
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("New User?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()),
                              );
                            },
                            child: const Text(
                              "SIGN UP HERE",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
