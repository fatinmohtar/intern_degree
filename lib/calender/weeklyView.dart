import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

typedef DateSelectionCallback = void Function(String startDate, String endDate);

class DateRanges extends StatefulWidget {
  final DateSelectionCallback onDateSelected;

  const DateRanges({super.key, required this.onDateSelected});

  @override
  SelectedDateRange createState() =>SelectedDateRange(onDateSelected: onDateSelected);
}

class SelectedDateRange extends State<DateRanges> {
  late String _startDate, _endDate;
  // final DateRangePickerController _controller = DateRangePickerController();
  final DateSelectionCallback onDateSelected;

  SelectedDateRange({required this.onDateSelected});

  @override
  void initState() {
    final DateTime today = DateTime.now();
    _startDate = DateFormat('yyyy-MM-dd').format(today).toString();
    _endDate = DateFormat('yyyy-MM-dd')
        .format(today.add(const Duration(days: 6)))
        .toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'SelectedDate:' '$_startDate' ' to ' '$_endDate',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        Card(
          margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: SfDateRangePicker(
            onSelectionChanged: selectionChanged,
            view: DateRangePickerView.month,
            allowViewNavigation: true,
            navigationMode: DateRangePickerNavigationMode .scroll, //set the navigation mode whether to scroll or snap
            //showNavigationArrow: true,
            selectionMode: DateRangePickerSelectionMode.single,

            initialSelectedDate: DateTime.now(),
            maxDate: DateTime(DateTime.now().year, 12,
                31), // to allow pick until the current year only
            monthCellStyle: DateRangePickerMonthCellStyle(
              disabledDatesDecoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  border: Border.all(color: const Color(0xFF2B732F), width: 1),
                  shape: BoxShape.rectangle),
            ),
          ),
        )
      ],
    );
  }

//send week - report details
  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    final DateTime selectedDate = args.value ?? DateTime.now();
    final int selectedWeekDay = selectedDate.weekday;
    final DateTime startOfWeek =
        selectedDate.subtract(Duration(days: selectedWeekDay));
    final DateTime endOfWeek =
        selectedDate.add(Duration(days: 6 - selectedWeekDay));

    setState(() {
      _startDate = DateFormat('yyyy-MM-dd').format(startOfWeek).toString();
      _endDate = DateFormat('yyyy-MM-dd').format(endOfWeek).toString();
    });

    onDateSelected(_startDate, _endDate);
  }
}
