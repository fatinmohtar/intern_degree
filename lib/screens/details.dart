import 'package:flutter/material.dart';
import '../constants/style.dart';
import '../DetailsModel/AlertDialogDetails.dart';
import '../Report/ReportDetails.dart';
import 'selectDays.dart';

class DetailsPage extends StatefulWidget {
  final String model;
  final String partNo;
  const DetailsPage({super.key, required this.model, required this.partNo});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int selectedOption = 0; //initalize selected button
  List<String> options = ['PDF','EXCEL',];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        flexibleSpace: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const FlexibleSpaceBar(
            title: Text('BACK'),
          ),
        ),
      ),
      body: Container(
        color: background,
        child: ListView(
          children: [
            //child:
            Column(
              children: [
                //this padding for the first row only
                Padding(
                  padding: const EdgeInsets.all(20),
                  //this row for the details and report
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //inside this have onTap() , two row for the icon and text details
                      InkWell(
                        // this function to make the image popUp
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DetailsAlertDialog(
                                model: widget.model,
                                partNo: widget.partNo,
                              ); //this will call the the Alert Dialog page for the details
                            },
                          );
                        },
                        //this row for the icon details
                        child: Row(
                          children: const [
                            Icon(
                              Icons.info_outline,
                              color: blue,
                              size: 20,
                            ),
                            Text(
                              'Details',
                              style: TextStyle(
                                fontSize: 15,
                                color: blue,
                              ),
                            ),
                          ],
                        ),
                      ), //for the details

                      //this part for report
                      InkWell(
                        // this function to make the image popUp
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ReportAlertDialog(
                                  model: widget.model,
                                  partNo: widget.partNo,
                              ); //this will call the Report Details Page
                            },
                          );
                        },
                        //this row for the report
                        child: Row(
                          children: const [
                            Icon(
                              Icons.system_update_alt,
                              color: blue,
                              size: 20,
                            ),
                            Text(
                              'Report',
                              style: TextStyle(
                                fontSize: 15,
                                color: blue,
                              ),
                            ),
                          ],
                        ),
                      ), // for the report
                    ],
                  ),
                ),
                // if we put the bottom pading 0 need to put sized box below
                // const SizedBox(height: 15),

                //padding for the 2 column
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 0, 20),
                  // row for the 2 element that have 3 container
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //the first box
                      Flexible(
                        child: Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(
                              color: blue,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),

                          //column for Req shift quantity and 0
                          child: Column(
                            children: [
                              //for the total
                              Flexible(
                                child: Container(
                                  width: 100,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: blue,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: const Text(
                                    "Req Shift Qty",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ), // for total
                              //const Expanded(
                              //  child:
                              const Text(
                                "0",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              //),
                            ],
                          ),
                        ),
                      ), //the first box

                      //option if we dont put the pading we need to put the MainAxisAlignment.center, and the const SizedBox(width: 20) for
                      //row that have 3 container()
                      const SizedBox(width: 15),

                      //second container box
                      Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(
                            color: blue,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),

                        //column for opening Stock
                        child: Column(
                          children: [
                            //container for stock
                            Container(
                              width: 100,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: blue,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                              ),
                              child: const Text(
                                "Opening Stock",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),

                            //part for update the value
                            const Center(
                              child: Text(
                                "0",
                                //textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            // ),
                          ],
                        ),
                      ), // second container

                      const SizedBox(width: 15),

                      // 3 container box
                      Flexible(
                        child: Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(
                              color: blue,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          //column for the total
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: blue,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                  ),
                                ),
                                child: const Text(
                                  "Total",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            
                             const Center(
                                child: Text(
                                  "0",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ), // for the 3 container box
                    ],
                  ),
                ), //for 2 column

                //next column function
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //to put the box with color
                    Container(
                        width: 15,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: blue,
                            width: 2,
                          ),
                          color: Colors.purpleAccent, //backgroud color
                        )),

                    const SizedBox(width: 3),

                    const Text(
                      'PLAN',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: blue),
                    ),

                    const SizedBox(width: 50),

                    //to put the  2 with color
                    Container(
                        width: 15,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: blue,
                            width: 2,
                          ),
                          color: Colors.yellowAccent, //backgroud color
                        )),

                    const SizedBox(width: 3),

                    //2 text
                    const Text(
                      'ACTUAL',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: blue,
                      ),
                    )
                  ],
                ),

                //this to call the week day calender 
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.72,
                    color: Colors.grey[100],
                    child: WeekDays(
                      model: widget.model,
                      partNo: widget.partNo,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
