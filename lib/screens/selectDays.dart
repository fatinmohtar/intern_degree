//this code use to called the calender at the details page rename the file from 7Days->selectDays
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jarvis_login/screens/productFieldTable.dart';
import '../constants/style.dart';
import 'productfields.dart';

//triangle design 
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0); // Move to the top-left corner
    path.lineTo(size.width, 0); // Draw a line to the top-right corner
    path.lineTo(
        size.width / 2, size.height); // Draw a line to the bottom-center corner
    path.close(); // Close the path to form a triangle
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}

class WeekDays extends StatefulWidget {
  final String model;
  final String partNo;
  const WeekDays({super.key, required this.model, required this.partNo});

  //WeekDays({Key? key}) : super(key: key);

  @override
  _WeekDaysState createState() => _WeekDaysState();
}

class _WeekDaysState extends State<WeekDays> {
  late DateTime _selectedDate;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _calculateDates();
  }

  void _calculateDates() {
    _startDate = _selectedDate.subtract(Duration(days: _selectedDate.weekday));
    _endDate = _startDate.add(const Duration(days: 6));
  }

  void _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null && selected != _selectedDate) {
      setState(() {
        _selectedDate = selected;
        _calculateDates();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //row for the calender
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectDate(context),
                    //row for the icon and calender function
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.arrow_drop_down,
                          color: blue,
                          size: 30,
                        ), // Add icon here
                    
                        Text(
                          '${DateFormat('dd MMMM').format(_startDate)} - ${DateFormat('dd MMMM').format(_endDate)}',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.0,
                            color: blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            //text
            const Center(
              child: Text(
                'Select Day: ',
                style: TextStyle(
                  fontSize: 14,
                  color: blue,
                ),
              ),
            ),
      
            //container to display the 7 days that we select inside the calander
            Container(
              height: 65,
              decoration: const BoxDecoration(
                color:  Colors.white,
      
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 5),
                child: Row(
                  //row to loop all the circle shape and calender days
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //list generate will loop 7 times
                  children: List.generate(7, (index) {
                    DateTime date = _startDate.add(Duration(days: index));
                    return Expanded(
                      child: Column(
                        children: [
                          //selected date a week
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Container(
                              height: 50.0, // set the height to 50.0
                              width: 50.0, // set the width to 50.0
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  //Navigate to the next page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Productfields(
                                        date: date,
                                        model: widget.model,
                                        partNo: widget.partNo,
                                      ),
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    '${DateFormat('dd').format(date)}',
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14.0,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
      
            //triangle shape
            ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                height: 25,
                //width: 100,
                //color: Colors.amber,
                color:  Colors.white,
              ),
            ),
      
            //TableProduct()
          const SizedBox(height: 10),// Add some spacing between the ClipPath and TableProduct
      
        TableProduct(
             model: widget.model,
              partNo: widget.partNo,
              startDate: _startDate,
              endDate: _endDate,
              currentDate: _selectedDate,), 
          ],
        ),
      ),
    );
  }
}
