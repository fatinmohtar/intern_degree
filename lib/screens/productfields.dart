import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/style.dart';

class Productfields extends StatefulWidget {
  final DateTime date;
  final String model;
  final String partNo;

  const Productfields(
      {super.key,  required this.date, required this.model, required this.partNo});

  @override
  State<Productfields> createState() => _ProductfieldsState();
}

class _ProductfieldsState extends State<Productfields> {
  final _formKey = GlobalKey<FormState>();

  //controller
  TextEditingController plan1Controller = TextEditingController();
  TextEditingController actual1Controller = TextEditingController();
  TextEditingController plan2Controller = TextEditingController();
  TextEditingController actual2Controller = TextEditingController();
  TextEditingController deliveryController = TextEditingController();
  TextEditingController fgController = TextEditingController();

//enable
  bool enable1 = false; //pmi 1
  bool enable2 = false; //stamping mi1
  bool enable3 = false; //pmi 2
  bool enable4 = false; //stamping mi2
  bool enable5 = false; //delivey
  bool enable6 = false; //fg stock 

//decelarartion
  String plan1 = '';
  String actual1 = '';
  String plan2 = '';
  String actual2 = '';
  String delivery = '';
  String fg = '';

  // Declare the variables at the class level
  bool isDateInRange = false;
  bool isDateAfterToday = false;

  @override
  void initState() {
    super.initState();
    enableFields();
  }

  void enableFields() {
    DateTime currentDate = DateTime.now();
    DateTime fourDaysAgo = currentDate.subtract(const Duration(days: 4));

    isDateInRange =
        widget.date.isAfter(fourDaysAgo) && widget.date.isBefore(currentDate);
    isDateAfterToday = widget.date.isAfter(currentDate);

    //isButtonEnabled = isDateInRange;
    if (isDateInRange) {
      enable1 = true;
      enable2 = true;
      enable3 = true;
      enable4 = true;
      enable5 = true;
      enable6 = true;
    } else if (isDateAfterToday) {
      enable1 = true;
      enable3 = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    //model&partno&date
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: blue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Model: ${widget.model}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    'Part No: ${widget.partNo}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    'Date: ${DateFormat('yyyy-MM-dd').format(widget.date)}',

                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    //form
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //stamping1
                            const Center(
                              child: Text(
                                'stamping_mi1 (D)',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: blue,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            //plan1&actual1
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //plan1 enable1
                                Expanded(
                                  child: Container(
                                    width: 120,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: enable1
                                          ? Colors.white
                                          : Colors.grey[350],
                                      border: Border.all(
                                        color: Colors.purple,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Plan',
                                          style: TextStyle(
                                            color: blue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: plan1Controller,
                                            enabled: enable1,
                                            onChanged: (value) {
                                              setState(() {
                                                plan1 = value;
                                              });
                                            },
                                            textAlign: TextAlign.center,
                                            decoration:const  InputDecoration(
                                              hintText: '0',
                                              hintStyle: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                            style:const  TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                               const  SizedBox(width: 30),
                                //actual1 enable2
                                Expanded(
                                  child: Container(
                                    width: 120,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: enable2
                                          ? Colors.white
                                          : Colors.grey[350],
                                      border: Border.all(
                                        color: Colors.lime,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            'Actual',
                                            style: TextStyle(
                                              color: blue,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: actual1Controller,
                                          enabled: enable2,
                                          onChanged: (value) {
                                            setState(() {
                                              actual1 = value;
                                            });
                                          },
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            hintText: '0',
                                            hintStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style:const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            //stamping2
                            const Center(
                              child: Text(
                                'stamping_mi2 (N)',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: blue,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            //plan2&actual2
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //plan2 enable3*
                                Expanded(
                                  child: Container(
                                    width: 120,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: enable3
                                          ? Colors.white
                                          : Colors.grey[350],
                                      border: Border.all(
                                        color: Colors.purple,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                       const Text(
                                          'Plan',
                                          style: TextStyle(
                                            color: blue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: plan2Controller,
                                            enabled: enable3,
                                            onChanged: (value) {
                                              setState(() {
                                                plan2 = value;
                                              });
                                            },
                                            textAlign: TextAlign.center,
                                            decoration:const InputDecoration(
                                              hintText: '0',
                                              hintStyle: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                            style:const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 30),
                                //actual2 enable4
                                Expanded(
                                  child: Container(
                                    width: 120,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: enable4
                                          ? Colors.white
                                          : Colors.grey[350],
                                      border: Border.all(
                                        color: Colors.lime,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            'Actual',
                                            style: TextStyle(
                                              color: blue,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: actual2Controller,
                                          enabled: enable4,
                                          onChanged: (value) {
                                            setState(() {
                                              actual2 = value;
                                            });
                                          },
                                          textAlign: TextAlign.center,
                                          decoration:const InputDecoration(
                                            hintText: '0',
                                            hintStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style:const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                           const SizedBox(height: 20),
                            //delivery
                            const Center(
                              child: Text(
                                'delivery',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: blue,
                                ),
                              ),
                            ),
                           const SizedBox(height: 20),
                            //delivery enable5
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: 120,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: enable5
                                          ? Colors.white
                                          : Colors.grey[350],
                                      border: Border.all(
                                        color: Colors.lime,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Actual',
                                          style: TextStyle(
                                            color: blue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          controller: deliveryController,
                                          enabled: enable5,
                                          onChanged: (value) {
                                            setState(() {
                                              delivery = value;
                                            });
                                          },
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            hintText: '0',
                                            hintStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            //fgstock
                            const Center(
                              child: Text(
                                'fg_stock',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: blue,
                                ),
                              ),
                            ),
                           const SizedBox(height: 20),
                            //fg enable6
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: 120,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: enable6
                                          ? Colors.white
                                          : Colors.grey[350],
                                      border: Border.all(
                                        color: Colors.lime,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                       const Text(
                                          'Actual',
                                          style: TextStyle(
                                            color: blue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          controller: fgController,
                                          enabled: enable6,
                                          onChanged: (value) {
                                            setState(() {
                                              fg = value;
                                            });
                                          },
                                          textAlign: TextAlign.center,
                                          decoration:const InputDecoration(
                                            hintText: '0',
                                            hintStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight
                                                .bold, // Apply bold style unconditionally
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //testing
                  ],
                ),
              ),
            ),
            BottomAppBar(
              height: 60,
              color: blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Navigate back to previous page
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(60, 50),
                      backgroundColor:
                          Colors.red, // Set red color for the button
                    ),
                    child:const Text(
                      'CANCEL',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Visibility(
                    visible: isDateInRange || isDateAfterToday,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title:const Text('Confirmation Required'),
                              content:const Text('Do you wish to save?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    print('Plan 1: $plan1');
                                    print('Actual 1: $actual1');
                                    print('Plan 2: $plan2');
                                    print('Actual 2: $actual2');
                                    print('delivery: $delivery');
                                    print('fg: $fg');
                                    Navigator.pop(context); //close the dialog
                                    Navigator.pop(
                                        context); //close the productfieds
                                  },
                                  child:const Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Text('No'),
                                )
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:const Size(60, 50),
                        backgroundColor: Colors.green,
                      ),
                      child:const Text(
                        'SAVE',
                        style: TextStyle(
                          //color: Colors.white,

                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

