import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../screens/ErrorFetch.dart';
import 'dart:convert';
import '../constants/style.dart';

List<TableProductField> tableProductFieldFromJson(String str) =>
    List<TableProductField>.from(
        json.decode(str).map((x) => TableProductField.fromJson(x)));

String tableProductFieldToJson(List<TableProductField> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TableProductField {
  int pmi1;
  int stampingMi1;
  int pmi2;
  int stampingMi2;
  int delivery;
  int fgStock;
  int id;

  TableProductField({
    required this.pmi1,
    required this.stampingMi1,
    required this.pmi2,
    required this.stampingMi2,
    required this.delivery,
    required this.fgStock,
    required this.id,
  });

  factory TableProductField.fromJson(Map<String, dynamic> json) =>
      TableProductField(
        pmi1: json["pmi1"],
        stampingMi1: json["stamping_mi1"],
        pmi2: json["pmi2"],
        stampingMi2: json["stamping_mi2"],
        delivery: json["delivery"],
        fgStock: json["fg_stock"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "pmi1": pmi1,
        "stamping_mi1": stampingMi1,
        "pmi2": pmi2,
        "stamping_mi2": stampingMi2,
        "delivery": delivery,
        "fg_stock": fgStock,
        "id": id,
      };
}

class TableProduct extends StatefulWidget {
  //call the data from selectedDay page
  final String model;
  final String partNo;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime currentDate;

  const TableProduct({
    Key? key,
    required this.model,
    required this.partNo,
    required this.startDate,
    required this.endDate,
    required this.currentDate,
  }) : super(key: key);
  @override
  _TableProductState createState() => _TableProductState();
}

class _TableProductState extends State<TableProduct> {
  bool isPastDate = false;
  String _errorMessage = '';
  bool showError = false; // New variable to track error state



  //api for the product field
  Future<List<TableProductField>> fetchData(
    String model, String partNo, DateTime startDate, DateTime endDate) async {
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
    String apiUrl =
        'http://lsftech2.ddns.net:8888/getrange/$model/$partNo/$formattedStartDate/$formattedEndDate/pmi1/stamping_mi1/pmi2/stamping_mi2/delivery/fg_stock/id';

    try {
      // Make the API call
      final response = await http.get(Uri.parse(apiUrl));

      // Check the response status code
      if (response.statusCode == 200) {
        // Decode the JSON response into a list of Table objects
        List<TableProductField> tableProductFields =
            tableProductFieldFromJson(response.body);
        return tableProductFields;
      } else {
        print('responseError');
        _errorMessage='Failed to load data';
      throw Exception('Failed to load data');
      }
    } catch (e) {

      _errorMessage='Error: $e ';
        print('catch fetchData');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ErrorPage(
            errorMessage:_errorMessage,
            apiUrl: apiUrl,
            onRefresh: () {
              setState(() {
                showError = false; // Hide error page
              });
            },
          ),
        ),
     );
    throw Exception('Error: $e \n\n Url : $apiUrl');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: showError // Show error page if there's an error
      ?ErrorPage(
        errorMessage: 'Test message', // Pass error message here
        apiUrl: 'apiUrl',
              onRefresh: () {
                        print('errorpageincontainer');
                setState(() {
                  showError = false; // Hide error page
                });
              },
            )
      :FutureBuilder<List<TableProductField>>(
        future: fetchData(
            widget.model, 
            widget.partNo, 
            widget.startDate, 
            widget.endDate
            ),
            builder: (context, snapshot) {
          if (snapshot.hasData) {
            // API call completed successfully
            List<TableProductField> tableProductFields = snapshot.data!;
            print('success fetchdata');
            return Padding(
                padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  stampingMi1Table(
                    ' stamping_mi1 (D)',
                    tableProductFields,
                  ),
                  stampingMi2Table(
                    ' stamping_mi2 (D)',
                    tableProductFields,
                  ),
                  deliveryTable(
                    ' delivery',
                    tableProductFields,
                  ),
                  fgStockTable(
                    ' fg_Stock',
                    tableProductFields,
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
             showError = true; // Set error state to true
            print('inside the snapshot error');

             return Container(); // Return an empty container for now
          }
          else if (snapshot.connectionState == ConnectionState.waiting) {
              // API call is in progress
          return const Center(
            child: CircularProgressIndicator(),
          );
          }
         return const Center(
            child: CircularProgressIndicator(),);
        },
      ),
    );
  }

//text and for the pmi1 and stamping1 table called
  Widget stampingMi1Table(String title, List<TableProductField> data) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style:const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: blue),
              ),
                         
                  
             //SizedBox(width: MediaQuery.of(context).size.width * 0.06),       
             const SizedBox(width: 30),
              //need to update the value here !!!
              const Text(
                'Min: 0',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

              // SizedBox(width: MediaQuery.of(context).size.width * 0.2),
              const SizedBox(width: 32),
              //need to update the value here !!!
              const Text(
                'Max: 0',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 5.0),
        SizedBox(
          //this container for all the table display
          width: MediaQuery.of(context).size.width,
          height: 87,
          child: Row(
            children: data
                .asMap()
                .entries
                .map((entry) => stampingMi1TableItem(entry.value, entry.key))
                .toList(),
          ),
          // ),
        ),
      ],
    );
  }

//table  pmi and stamping 1

  Widget stampingMi1TableItem(TableProductField table, int index) {
  // Condition for the pmi1 if it has a value, it will change to greenColor.
  Color containerColor;
  if (index > 0) {
    containerColor = table.pmi1 != 0 ? conditionGreenColor : Colors.purpleAccent;
  } else {
    containerColor = table.pmi1 != 0 ? conditionGreenColor: conditionGrey;
  }

  // Table stampingMi1 condition color is date is past date it will change to yellow
  DateTime date = widget.startDate.add(Duration(days: index));
  bool isPastDate = date.isBefore(DateTime.now());
  bool hasValue = table.stampingMi1 != 0; // Additional condition for value check
  //bool hasValue = table.stampingMi1 == 0;
  Color? pastdateColor = (index > 0 && isPastDate && hasValue)
      ? blueNeon // Change to blue if pastDate and value exist
      : ((index > 0 && isPastDate) || (index == 0))
          ? Colors.yellowAccent
          : conditionGrey;

  if (index == 0 ) {

    pastdateColor = table.stampingMi1 != 0 ? blueNeon: conditionGrey;  }

  return Column(
    children: [
      // pmi1 table
      Container(
      width: MediaQuery.of(context).size.width * 0.118,
        height: 42,
        //width: 46,
        decoration: BoxDecoration(
          color: containerColor,
          border: Border.all(
            color: Colors.black,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Text(
            ' ${table.pmi1}',
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              
            ),
          ),
        ),
      ),
      // stamping_1 value table
      Container(
        width: MediaQuery.of(context).size.width * 0.118,
        height: 42,
        //width: 46,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: pastdateColor,
        ),
        child: Center(
          child: Text(
            ' ${table.stampingMi1}',
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    ],
  );
}

//text and for the pmi2 and stamping2 table called
  Widget stampingMi2Table(String title, List<TableProductField> data) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: blue),
              ),

            // SizedBox(width: MediaQuery.of(context).size.width * 0.04),   
            const SizedBox(width: 30),    
                const Text(
                  'Min: 0',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),

              // SizedBox(width: MediaQuery.of(context).size.width * 0.2),
              const SizedBox(width: 32),
              //need to update the value here !!!
             const Text(
                'Max: 0',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5.0),
        SizedBox(
          //container for all the table display
          width: MediaQuery.of(context).size.width,
          height: 87,
          // color: Colors.grey,
          child: Row(
            children: data
                .asMap()
                .entries
                .map((entry) => stampingMi2TableItem(entry.value, entry.key))
                .toList(),
          ),
          // ),
        ),
      ],
    );
  }

//table  pmi2 and stamping2

  Widget stampingMi2TableItem(TableProductField table, int index) {
    //condition for the pmi1 if have value it will change to greenColor.fromARGB(255, 152, 255, 35)
    Color containerColor;
    if (index > 0) {
      containerColor =
          table.pmi2 != 0 ? conditionGreenColor : Colors.purpleAccent;
    } else {
      containerColor = table.pmi2 != 0 ? conditionGreenColor: conditionGrey;
    }

  DateTime date = widget.startDate.add(Duration(days: index));
  bool isPastDate = date.isBefore(DateTime.now());
  bool hasValue = table.stampingMi2 != 0; // Additional condition for value check

  Color? pastdateColor = (index > 0 && isPastDate && hasValue)
      ? blueNeon // Change to blue if pastDate and value exist
      : ((index > 0 && isPastDate) || index == 0)
          ? Colors.yellowAccent
          : conditionGrey;

        if (index == 0) {
        pastdateColor = table.stampingMi2 != 0 ? blueNeon: conditionGrey;  
        }

    return Column(
      children: [
        //pmi2 table
        Container(
        //  width: 46,
          width: MediaQuery.of(context).size.width * 0.118,
          height: 42,
          decoration: BoxDecoration(
            color: containerColor,
            border: Border.all(
              color: Colors.black,
              style: BorderStyle.solid,
            ),
          ),
          child: Center(
            child: Text(
              ' ${table.pmi2}',
              style:const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
        //stamping_2 value table
        Container(
         //  width: 46,
          width: MediaQuery.of(context).size.width * 0.118,
          height: 42,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black), 
              color: pastdateColor),
          child: Center(
            child: Text(
              ' ${table.stampingMi2}',
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

   //delivery text and api tables
  Widget deliveryTable(String title, List<TableProductField> data) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: blue),
                ),
              ),

              //need to update the value here !!!
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.23),
                child:  const Text(
                  'Min: 0',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),

              const SizedBox(width: 30),
              //need to update the value here !!!
              const Text(
                'Max: 0',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5.0),
        SizedBox(
          //container for all the table display
          width: MediaQuery.of(context).size.width,
           height: 45,

          // color: Colors.grey,
          child: Row(
            children: data
                .asMap()
                .entries
                .map((entry) => deliveryItemTable(entry.value, entry.key))
                .toList(),
          ),
          // ),
        ),
      ],
    );
  }

//table delivery
  Widget deliveryItemTable(TableProductField table, int index) {
    DateTime date = widget.startDate.add(Duration(days: index));
  bool isPastDate = date.isBefore(DateTime.now());
  bool hasValue = table.delivery != 0; // Additional condition for value check
  Color? pastdateColor = (index > 0 && isPastDate && hasValue)
      ? blueNeon // Change to blue if pastDate and value exist
      : ((index > 0 && isPastDate) || index == 0)
          ? Colors.yellowAccent
          : conditionGrey;

  if (index == 0) {
    pastdateColor =table.delivery != 0?  blueNeon:conditionGrey;}
    return Column(
      children: [
        //pmi2 table
        Container(
          //  width: 46,
           width: MediaQuery.of(context).size.width * 0.118,
          height: 42,
          decoration: BoxDecoration(
            color: pastdateColor,
            border: Border.all(
              color: Colors.black,
              style: BorderStyle.solid,
            ),
          ),
          child: Center(
            child: Text(
              ' ${table.delivery}',
              style:const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

// //fgStock text and api tables
  Widget fgStockTable(String title, List<TableProductField> data) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold, color: blue),
                ),
              ),

              SizedBox( width: MediaQuery.of(context).size.width * 0.24),
              //need to update the value here !!!
             const Text(
               'Min: 400',
               style: TextStyle(
                 fontSize: 14,
                 fontWeight: FontWeight.bold,
                 color: Colors.red,
               ),
             ),

               //SizedBox(width: MediaQuery.of(context).size.width * 0.2),
              const SizedBox(width: 14),
              //need to update the value here !!!
             const Text(
               'Max: 1200',
               textAlign: TextAlign.left,

               style: TextStyle(
                 fontSize: 14,
                 fontWeight: FontWeight.bold,
                 color: Colors.blue,
               ),
             ),
            ],
          ),
        ),
        const SizedBox(height: 5.0),
        SizedBox(
          //container for all the table display
          width: MediaQuery.of(context).size.width ,
          height: 45,
          // color: Colors.grey,
          child: Row(
            children: data
                .asMap()
                .entries
                .map((entry) => fgStockItemTable(entry.value, entry.key))
                .toList(),
          ),
        ),
      ],
    );
  }

//fgStockTable 
  Widget fgStockItemTable(TableProductField table, int index) {
   DateTime date = widget.startDate.add(Duration(days: index));
  bool isPastDate = date.isBefore(DateTime.now());
  bool hasValue = table.fgStock != 0; // Additional condition for value check
  bool minValue=  table.fgStock < 400;

  Color? pastdateColor;

  if(index>0)
  {
    pastdateColor = (isPastDate && hasValue && minValue)? Colors.red
      :(hasValue && table.fgStock >= 400)? Colors.white
      :(index > 0 && isPastDate)  ? Colors.yellowAccent
      : conditionGrey;
  }

  if (index == 0) {
    pastdateColor = (hasValue && minValue)? Colors.red: (hasValue && table.fgStock > 400)? blueNeon :conditionGrey;}

    return Column(
      children: [
        // fgStock table
        Container(
            //  width: 46,
          width: MediaQuery.of(context).size.width * 0.118,
          height: 42,
          decoration: BoxDecoration(
            color: pastdateColor,
            border: Border.all(
              color: Colors.black,
              style: BorderStyle.solid,
            ),
          ),
          child: Center(
            child: Text(
              ' ${table.fgStock}',
              style:const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
