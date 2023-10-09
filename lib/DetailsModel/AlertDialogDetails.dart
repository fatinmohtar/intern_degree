//used for the report part at the details page only
import 'package:flutter/material.dart';

class DetailsAlertDialog extends StatefulWidget {

  final String model;
  final String partNo;
  const DetailsAlertDialog ({super.key,required this.model,required this.partNo});

  @override
  State<DetailsAlertDialog> createState() => _DetailsAlertDialogState();
}

class _DetailsAlertDialogState extends State<DetailsAlertDialog> {
  @override
  Widget build(BuildContext context) {
    final imageUrl =
        'http://lsftech2.ddns.net:8888/img/${widget.model}/${widget.partNo}.png';
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.grey[300],
      content: SizedBox(
        //height: MediaQuery.of(context).size.height * 0.36,
        //width: MediaQuery.of(context).size.width * 0.65,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8),
              child: Text(
                'Model: ${widget.model}',
                style:const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8),
              child: Text(
                'Part No: ${widget.partNo}',
                style:const TextStyle(
                  fontSize: 15,
                  color: Colors.blueGrey,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            const SizedBox(height: 10),
              //color: Colors.amber,
            Image.network(imageUrl, 
              fit:BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(6), // Set the desired border radius
                  child: Image.asset(
                        'assets/images/error-image-key.png',
                    fit: BoxFit.cover,
                  ),
                              ),
                );
              },
              ),
            
          ],
        ),
      ),
      actions: [
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.purple),
              minimumSize: MaterialStateProperty.all<Size>(
                  const Size(double.infinity, 55)),
            ),
            child:const Text('Close'),
          ),
        ),
      ],
    );
  }
}
