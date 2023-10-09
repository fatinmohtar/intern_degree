import 'package:flutter/material.dart';
import '../constants/style.dart';
import '../screens/home.dart';
class ErrorPage extends StatelessWidget {
  final String errorMessage;
  final String apiUrl;
  final VoidCallback onRefresh; // New callback for refreshing

  const ErrorPage({super.key, required this.errorMessage,required this.apiUrl, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pop(context);// Go back to the previous screen
            // Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        title: const Text('Back HomePage'),
      ),
       body: Container(
        color: background,
         child: Padding(
           padding: const EdgeInsets.all(12.0),
           child: Column(
            children: [ 
             const Center(
                child:  Text('Failed to fetch API',
                style: textMP,
                ),
              ),
              const SizedBox(height: 10),

              Text('$errorMessage',
               style:const TextStyle(
                 fontFamily: 'Roboto',
                fontSize: 14,
                        )),
              const SizedBox(height: 10),
              Text('$apiUrl'),
                const SizedBox(height: 10),
              ElevatedButton(
                onPressed: onRefresh, // Call the refresh callback
                style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.lightBlue,
                  textStyle:const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                
                child: const Text('Refresh'),
              ),
            
            ],
               ),
         ),
       ),
    );
  }
}
