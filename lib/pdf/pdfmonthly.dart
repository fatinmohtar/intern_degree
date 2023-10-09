//package
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as Pdf;
import 'dart:convert';
import 'package:http/http.dart' as http;

//local file;
import '../device/mobile.dart' if (dart.library.html) '../device/web.dart';

//convert data
List<TableProductField> tableProductFieldFromJson(String str) =>
    List<TableProductField>.from(
        json.decode(str).map((x) => TableProductField.fromJson(x)));

String tableProductFieldToJson(List<TableProductField> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//convertdata
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

class pdfmonthly extends StatefulWidget {
  final String model;
  final String partNo;
  final int selectedMonthPass;
  final int selectedYearPass;
  final String calendarOptionName;

  const pdfmonthly(
      {super.key,
      required this.model,
      required this.partNo,
      required this.selectedMonthPass,
      required this.selectedYearPass,
      required this.calendarOptionName});

  @override
  State<pdfmonthly> createState() => pdfmonthlyState();
}

class pdfmonthlyState extends State<pdfmonthly> {
  List<List<DateTime>> calculateWeeks(int year, int month) {
    final firstDayOfMonth = DateTime(year, month, 1);
    final lastDayOfMonth = DateTime(year, month + 1, 0);

    List<List<DateTime>> weeks = [];
    DateTime startDate = firstDayOfMonth;
    DateTime endDate = firstDayOfMonth
        .add(Duration(days: 6 - firstDayOfMonth.weekday)); //start with sunday

    while (endDate.isBefore(lastDayOfMonth)) {
      weeks.add([startDate, endDate]);
      startDate = endDate.add(const Duration(days: 1));
      endDate = startDate.add(const Duration(days: 6));
    }

    weeks.add([startDate, lastDayOfMonth]);

    return weeks;
  }

  //fetch data
  Future<List<TableProductField>> fetchData(
      DateTime startDate, DateTime endDate) async {
    final String dataUrl =
        'http://lsftech2.ddns.net:8888/getrange/${widget.model}/${widget.partNo}/${startDate}/${endDate}/pmi1/stamping_mi1/pmi2/stamping_mi2/delivery/fg_stock/id';

    try {
      final response = await http.get(Uri.parse(dataUrl));
      if (response.statusCode == 200) {
        List<TableProductField> tableProductFields =
            tableProductFieldFromJson(response.body);
        return tableProductFields;
      } else {
        print('cannot load data');
        Navigator.pop(context, "failure");
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
       Navigator.pop(context, "failure");
      throw Exception('Error: $e');
    }
  }

  Future<http.Response> httpGet(String getUrl) async {
    http.Response response;
    var url = Uri.parse(getUrl);
    response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        // "Origin": "http://localhost:65121/",
      },
    );
    return response;
  }

  // Function to fetch the image using http.get
Future<Uint8List> fetchImage(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to fetch image');
  }
}

  @override
  void initState() {
    super.initState();
    _createP();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void> _createP() async {
    // Create a new PDF document.
    final PdfDocument document = PdfDocument();

    // Adds page settings.
    document.pageSettings.orientation = PdfPageOrientation.landscape;
    document.pageSettings.margins.all = 50;

    // Add a new page to the document.
    final PdfPage page = document.pages.add();

    // Report Summary
    PdfGraphics graphics = page.graphics;
    graphics.drawString(
      'Report Details ${widget.calendarOptionName}ly Summary',
      PdfStandardFont(PdfFontFamily.timesRoman, 30, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(
        0,
        0,
        page.getClientSize().width,
        page.getClientSize().height,
      ),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
      ),
    );

    // Calculate the weeks for the selected month and year.
    List<List<DateTime>> weeks =
        calculateWeeks(widget.selectedYearPass, widget.selectedMonthPass);
    final List<TableProductField> data = await fetchData(
        weeks.first.first, weeks.last.last); //(weeks.1stweek,1stday)

    List week = [];
    int n = 0; //for calculate data week length
    for (int i = 0; i < weeks.length; i++) {
      week.add(data.sublist(
          n, weeks[i].last.difference(weeks[i].first).inDays + 1 + n));
      n = n + weeks[i].last.difference(weeks[i].first).inDays + 1;
    }
    // Create a new table for API data
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 11); // Specify the number of columns in the table.

    // Add columns to the grid
    grid.columns[0].width = 20;
    grid.columns[1].width = 130;
    grid.columns[2].width = 100;
    grid.columns[3].width = 70;
    grid.columns[4].width = 50;
    for (int i = 5; i < 11; i++) {
      grid.columns[i].width = 60;
    }

    // Add column headers.
    grid.headers.add(1);
    grid.headers[0].cells[0].value = ' bil';
    grid.headers[0].cells[1].value = ' Pic Part';
    grid.headers[0].cells[2].value = ' Model';
    grid.headers[0].cells[3].value = ' field';
    grid.headers[0].cells[4].value = '';
    grid.headers[0].cells[10].value = ' Total';

    // Add date header
    for (int i = 0; i < weeks.length; i++) {
      final List<DateTime> week = weeks[i];
      final DateTime startDate = week[0];
      final DateTime endDate = week[1];

      final String startDateFormatted =
          DateFormat('dd/MM/yy').format(startDate);
      final String endDateFormatted = DateFormat('dd/MM/yy').format(endDate);
      grid.headers[0].cells[i + 5].value =
          ' ' + startDateFormatted + '\n ~\n' + ' ' + endDateFormatted;
    }

    final PdfGridRow row1 = grid.rows.add();
    final PdfGridRow row2 = grid.rows.add();
    final PdfGridRow row3 = grid.rows.add();
    final PdfGridRow row4 = grid.rows.add();
    final PdfGridRow row5 = grid.rows.add();
    final PdfGridRow row6 = grid.rows.add();

    int i = 0;
    int Total1 = 0;
    int Total2 = 0;
    int Total3 = 0;
    int Total4 = 0;
    int Total5 = 0;
    int Total6 = 0;
    for (List<TableProductField> item1 in week) {
      int pmi1Total = 0;
      int stampingMi1Total = 0;
      int pmi2Total = 0;
      int stampingMi2Total = 0;
      int deliveryTotal = 0;
      int fgStockTotal = 0;
      for (TableProductField item2 in item1) {
        pmi1Total += item2.pmi1;
        stampingMi1Total += item2.stampingMi1;
        pmi2Total += item2.pmi2;
        stampingMi2Total += item2.stampingMi2;
        deliveryTotal += item2.delivery;
        fgStockTotal += item2.fgStock;
      }
      row1.cells[5 + i].value = '  ' + pmi1Total.toString();
      row2.cells[5 + i].value = '  ' + stampingMi1Total.toString();
      row3.cells[5 + i].value = '  ' + pmi2Total.toString();
      row4.cells[5 + i].value = '  ' + stampingMi2Total.toString();
      row5.cells[5 + i].value = '  ' + deliveryTotal.toString();
      row6.cells[5 + i].value = '  ' + fgStockTotal.toString();

      Total1 += pmi1Total;
      Total2 += stampingMi1Total;
      Total3 += pmi2Total;
      Total4 += stampingMi2Total;
      Total5 += deliveryTotal;
      Total6 += fgStockTotal;

      i++;
    }
    row1.cells[10].value = '  ' + Total1.toString();
    row2.cells[10].value = '  ' + Total2.toString();
    row3.cells[10].value = '  ' + Total3.toString();
    row4.cells[10].value = '  ' + Total4.toString();
    row5.cells[10].value = '  ' + Total5.toString();
    row6.cells[10].value = '  ' + Total6.toString();

    //fetch image
    final imageUrl =
        'http://lsftech2.ddns.net:8888/img/${widget.model}/${widget.partNo}.png';

    try {
    final Uint8List imageData = await fetchImage(imageUrl);
    // ... code to insert the image ...
    print('Image inserted successfully');
    PdfBitmap image = PdfBitmap(imageData);

      PdfGridCell cell1 = row1.cells[1];
      //Sets the image alignment type of the PdfGridCell image
      cell1.imagePosition = PdfGridImagePosition.stretch;
      cell1.style.backgroundImage = image;
 
  } catch (e) {
    print('Error fetching or inserting image: $e');
     //Replace the text "1" with the image
      PdfGridCell cell1 = row1.cells[1];
        cell1.value='Failed to fetch image url: ${imageUrl}';
  }
  

    //Add table data.
    //row1
    row1.cells[0].value = ' 1';
    row1.cells[0].rowSpan = 6;
    //row1.cells[1].value = image;
    row1.cells[1].rowSpan = 6;
    row1.cells[2].value = ' ' + widget.partNo;
    row1.cells[2].rowSpan = 6;
    row1.cells[3].value = ' stamping pmi 1';
    row1.cells[3].rowSpan = 2;
    row1.cells[4].value = ' plan';

    //row2
    row2.cells[3].value = 'merge';
    row2.cells[4].value = ' actual';

    //row3
    row3.cells[3].value = ' stamping pmi 2';
    row3.cells[3].rowSpan = 2;
    row3.cells[4].value = ' plan';

    //row4
    row4.cells[3].value = 'merge';
    row4.cells[4].value = ' actual';

    //row5
    row5.cells[3].value = ' delivery';
    row5.cells[4].value = ' actual';

    //row6
    row6.cells[3].value = ' fg_stock';
    row6.cells[4].value = ' actual';

    // Draw the table on the page.
    grid.draw(page: page, bounds: const Rect.fromLTRB(10, 50, 0, 0));

    Future.delayed(Duration.zero, () async {
      // Save the document
      List<int> bytes = await document.save();

      // Generate the file name with the current date and time
      final String currentDateTime =
          DateFormat('yyMMdd_HHmmss').format(DateTime.now());
      final String fileName = 'Jarvis_$currentDateTime.pdf';

      // Launch the PDF
      saveAndLaunchFile(bytes, fileName, context);

      // Close the page
      Navigator.pop(context, "success");
    });
  }
}
