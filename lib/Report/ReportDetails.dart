//used for the report part at the details page only
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/style.dart';
import '../calender/weeklyView.dart';
import '../calender/spinner.dart';
import '../excel/excelMonth.dart';
import '../pdf/createPDF.dart';
import '../excel/createExcel.dart';
import 'package:intl/intl.dart';

import '../device/mobile.dart' if (dart.library.html) '../device/web.dart';
import '../pdf/pdfmonthly.dart';

enum SelectedOption { PDF, EXCEL }

enum CalenderOption { Week, Month }

class ReportAlertDialog extends StatefulWidget {
  final String model;
  final String partNo;
  const ReportAlertDialog(
      {super.key, required this.model, required this.partNo});

  @override
  State<ReportAlertDialog> createState() => _ReportAlertDialogState();
}

class _ReportAlertDialogState extends State<ReportAlertDialog> {
  SelectedOption? _selectedOption = SelectedOption.PDF;
  CalenderOption? _calenderOption = CalenderOption.Week;

  String _startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _endDate = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(const Duration(days: 6)));

  int selectedMonthPass = DateTime.now().month;
  int selectedYearPass = DateTime.now().year;

  int passvaluemonth = DateTime.now().month;
  int passvalueyear = DateTime.now().year;

  void handleDateSelection(String startDate, String endDate) {
    setState(() {
      _startDate = startDate;
      _endDate = endDate;
    });
    print('Selected Start Date: $startDate');
    print('Selected End Date: $endDate');
    // Process the selected dates as needed
  }

  void navigateToMonthlyPDF(int passvaluemonth, int passvalueyear) {
    print('Pass value Selected Month: $passvaluemonth');
    print('Pass value Selected Year: $passvalueyear');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.95,
        width: MediaQuery.of(context).size.width * 0.95,
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //container for the details part
                  Container(
                    height: 65,
                    width: MediaQuery.of(context).size.width * 0.85,
                    color: Colors.grey[300],
                    child: Padding(
                      //padding for text only
                      padding: const EdgeInsets.only(top: 8.0, left: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            //must have function api to call display the details
                            'Model: ${widget.model}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          const SizedBox(
                              height:
                                  3), // Add some spacing between the two texts
                          Text(
                            //must have function api to call the details
                            'Part No: ${widget.partNo}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //text for report type
                  const Text(
                    'Report Type:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: blue,
                    ),
                  ),

                  const SizedBox(height: 10),

                  //the selection button
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    color: Colors.grey[300],
                    child: Padding(
                      //padding for text only
                      padding: const EdgeInsets.only(top: 10.0, left: 2),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RadioListTile<CalenderOption>(
                              value: CalenderOption.Week,
                              groupValue: _calenderOption,
                              title: Text(CalenderOption.Week.name),
                              onChanged: (value) {
                                setState(() {
                                  _calenderOption = value;
                                });
                              }),
                          const SizedBox(height: 3),
                          RadioListTile<CalenderOption>(
                              value: CalenderOption.Month,
                              groupValue: _calenderOption,
                              title: Text(CalenderOption.Month.name),
                              onChanged: (value) {
                                setState(() {
                                  _calenderOption = value;
                                });
                              }),
                        ],
                      ),
                    ),
                  ),

                  // SizedBox(height: 10),
                  //text for date Range type
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      'Date Range: ${_calenderOption?.name.toUpperCase() ?? ''}'
                      'LY',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: blue,
                      ),
                    ),
                  ),
                  //the date range button will display based on report type
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    color: Colors.grey[300],
                    child: Padding(
                      //padding for text only
                      padding:
                          const EdgeInsets.only(top: 8.0, left: 2, bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // create a function to handle the user's selection
                          if (_calenderOption == CalenderOption.Week) ...[
                            DateRanges(
                              onDateSelected: handleDateSelection,
                            ), //weekly view
                          ] else if (_calenderOption ==
                              CalenderOption.Month) ...[
                            MonthYearPicker(
                              onMonthChanged: (int month) {
                                print(
                                    'Selected Month: $month'); //get from spinner
                                passvaluemonth = month;
                                navigateToMonthlyPDF(
                                    passvaluemonth, passvalueyear); //pass value
                                print(passvaluemonth);
                              },
                              onYearChanged: (int year) {
                                print(
                                    'Selected Year: $year'); //get from spinner
                                passvalueyear = year;
                                navigateToMonthlyPDF(
                                    passvaluemonth, passvalueyear); //pass value
                                print(passvalueyear);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  //gap for report type
                  const SizedBox(height: 10),
                  //text for file type
                  const Text(
                    //must have function api to call display the details
                    'File Type: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),

                  const SizedBox(height: 10),

                  //the selection file type button
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    color: Colors.grey[300],
                    child: Padding(
                      //padding for text only
                      padding:
                          const EdgeInsets.only(top: 8.0, left: 2, bottom: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RadioListTile<SelectedOption>(
                              value: SelectedOption.PDF,
                              groupValue: _selectedOption,
                              title: Text(SelectedOption.PDF.name),
                              onChanged: (value) {
                                setState(() {
                                  _selectedOption = value;
                                  //need to put some action about the file need to be download
                                });
                              }),
                          const SizedBox(height: 3),
                          RadioListTile<SelectedOption>(
                              value: SelectedOption.EXCEL,
                              groupValue: _selectedOption,
                              title: Text(SelectedOption.EXCEL.name),
                              onChanged: (value) {
                                setState(() {
                                  _selectedOption = value;
                                });
                              }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  //  row for  button close and dw
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //button for the CLOSE PART
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.redAccent),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(25, 40)),
                        ),
                        child: const Text('CANCEL'),
                      ),
                      const SizedBox(width: 5),
                      //button for the DOWNLOAD PART
                      TextButton(
                        onPressed: () {
                          if (_selectedOption == SelectedOption.PDF) {
                            //week
                            if (_calenderOption == CalenderOption.Week) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => createPDF(
                                    model: widget.model,
                                    partNo: widget.partNo,
                                    startDate: _startDate,
                                    endDate: _endDate,
                                    calendarOptionName:
                                        _calenderOption?.name ?? '',
                                  ),
                                ),
                              ).then((value) {
                                if (value != null && value == "success") {
                                  Fluttertoast.showToast(
                                  msg: "PDF successfully downloaded.",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: Colors.black54,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                      webBgColor: "linear-gradient(black)");
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Failed to download the PDF.",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.SNACKBAR,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: Colors.black54,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                    webBgColor: "linear-gradient(black)",
                                  );
                                }
                                Navigator.pop(context);
                              });
                            } //month
                            else if (_calenderOption == CalenderOption.Month) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => pdfmonthly(
                                    selectedMonthPass:
                                        passvaluemonth, //pass$month
                                    selectedYearPass: passvalueyear, //pass$year
                                    model: widget.model,
                                    partNo: widget.partNo,
                                    calendarOptionName:
                                        _calenderOption?.name ?? '',
                                  ),
                                ),
                              ).then((value) {
                                 if (value != null && value == "success") {
                                  Fluttertoast.showToast(
                                  msg: "PDF successfully downloaded.",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: Colors.black54,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                      webBgColor: "linear-gradient(black)");
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Failed to download the PDF.",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.SNACKBAR,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: Colors.black54,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                    webBgColor: "linear-gradient(black)",
                                  );
                                }

                                Navigator.pop(context);
                              });
                            } //else if for pdf
                          } else if (_selectedOption == SelectedOption.EXCEL) {
                            if (_calenderOption == CalenderOption.Week) {
                              //perform for the weekly excel download action
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => createExcel(
                                    model: widget.model,
                                    partNo: widget.partNo,
                                    startDate: _startDate,
                                    endDate: _endDate,
                                    calendarOptionName:
                                        _calenderOption?.name ?? '',
                                  ),
                                ),
                              ).then((value) {
                                if (value != null && value == "success") {
                                  Fluttertoast.showToast(
                                      msg: "Excel successfully downloaded.",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: Colors.black54,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                      webBgColor: "linear-gradient(black)");
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Failed to download the Excel.",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.SNACKBAR,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: Colors.black54,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                    webBgColor: "linear-gradient(black)",
                                  );
                                }
                                Navigator.pop(context);
                              });
                            } else if (_calenderOption ==
                                CalenderOption.Month) {
                              //perform for the month excel download action
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExcelMonth(
                                    model: widget.model,
                                    partNo: widget.partNo,
                                    selectedMonthPass:
                                        passvaluemonth, //pass$month
                                    selectedYearPass: passvalueyear, //pass$year
                                    calendarOptionName:
                                        _calenderOption?.name ?? '',
                                  ),
                                ),
                              ).then((value) {
                                 if (value != null && value == "success") {
                                  Fluttertoast.showToast(
                                  msg: "Excel successfully downloaded.",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: Colors.black54,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                      webBgColor: "linear-gradient(black)");
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Failed to download the Excel.",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.SNACKBAR,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: Colors.black54,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                    webBgColor: "linear-gradient(black)",
                                  );
                                }

                                Navigator.pop(context);
                              });
                            } //else if for calender
                          } //selectedOption=excel
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blueAccent),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(30, 40)),
                        ),
                        child: const Text('DOWNLOAD'),
                      ),
                    ],
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
