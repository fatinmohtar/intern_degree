import 'package:flutter/material.dart';
//import 'loginPage.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
   bool _showTextField = false;
  final _formKey = GlobalKey<FormState>(); // Add a GlobalKey for the form
   final _idController =TextEditingController();
    TextEditingController _verificationCodeController = TextEditingController();

  @override

   void dispose() {
    _idController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2c538b),
        flexibleSpace: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const FlexibleSpaceBar(
            title: Text('Forgot Password'),
          ),
        ),
      ),
      body: Container(
        //container use to set the background color
        color: Colors.grey[300], // background color

        //use to set the padding  from the text
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            0.08 * MediaQuery.of(context).size.width,
            0.15 * MediaQuery.of(context).size.height,
            0.08 * MediaQuery.of(context).size.width,
            0,
          ),
         
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //text form field for the user to enter the id
                TextFormField(
                   controller: _idController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "Enter your user ID",
                    labelStyle: TextStyle(
                      color: Colors.grey, // set the label color
                      fontSize: 18,
                    ),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                      size: 34.0,
                    ),
          
                    // set the text style for the input when it is not in focus
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
          
                    // set the text style for the input when it is in focus
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 196, 35, 23)),
                    ),
                  ),
                 validator: (value) {
                    if (value!.isEmpty) {
                      // Return an error message if the text field is empty
                      return 'Please enter your user ID';
                    }
                    return null;
                  }, 
                ),
          
                const SizedBox(height: 16),
              
                  Visibility(
                      visible: _showTextField,
                         child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Verification code',
                        ),
                      ),
                    ),
          
                  const SizedBox(height: 16),
                //button for submit part
             ElevatedButton(
                  onPressed: () {
                   // validate the form
                  //we use if else statement because to display error when user did not put any username
                  if(_formKey.currentState!.validate()){
                        setState(() {
                        _showTextField = true;
                      });
                  }else{
   // Display a popup error message if the form is not valid
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content: Text('Please enter your user ID'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                  }
                     
                  },
                  child: const Text("SUBMIT"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 53, 126, 187)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(double.infinity, 50)),
                  ),
                ),
          
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
