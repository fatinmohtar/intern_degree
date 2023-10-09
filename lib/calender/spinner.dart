import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class MonthYearPicker extends StatefulWidget {
  final Function(int) onMonthChanged;
  final Function(int) onYearChanged;

  const MonthYearPicker({super.key, required this.onMonthChanged, required this.onYearChanged});

  @override
  _MonthYearPickerState createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<MonthYearPicker> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Selected Month: ${DateFormat('MMMM yyyy').format(DateTime(_selectedYear, _selectedMonth))}',
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Month picker
            Expanded(
              child: SizedBox(
                height: 200.0,
                child: CupertinoPicker(
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      _selectedMonth = index + 1;
                      widget.onMonthChanged(_selectedMonth);
                    });
                  },
                  // Set the initial selected month index
                  scrollController: FixedExtentScrollController(
                      initialItem: DateTime.now().month - 1),
                  children: List<Widget>.generate(12, (int index) {
                    final month = DateFormat('MMMM')
                        .format(DateTime(_selectedYear, index + 1));
                    return Center(
                      child: Text(
                        month,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }),
                ),
              ),
            ),
            //yearpicker
            Expanded(
              child: SizedBox(
                height: 200.0,
                child: CupertinoPicker(
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      final now = DateTime.now();
                      _selectedYear = now.year - index;
                      widget.onYearChanged(_selectedYear);
                    });
                  },
                  children: List<Widget>.generate(100, (int index) {
                    final now = DateTime.now();
                    final year = now.year - index;
                    return Center(
                      child: Text(
                        '$year',
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
