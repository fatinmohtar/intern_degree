import 'package:flutter/material.dart';
import '../constants/style.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,

          //this for button back function
        flexibleSpace: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const FlexibleSpaceBar(
            title: Text('BACK'),
          ),
        ),
      ),
      body: Stack(
        children: [Container()],
      ),
    );
}
}
