//package
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
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


class ExcelMonth extends StatefulWidget {
   final String model;
  final String partNo;
  final int selectedMonthPass;
  final int selectedYearPass;
  final String calendarOptionName; // Declare calendarOptionName here

  const ExcelMonth({super.key,required this.model,
      required this.partNo,
      required this.selectedMonthPass,
      required this.selectedYearPass,
      required this.calendarOptionName
      
      });

  @override
  State<ExcelMonth> createState() => _ExcelMonthState();
}

class _ExcelMonthState extends State<ExcelMonth> {

   List<List<DateTime>> calculateWeeks(int year, int month) {
    final firstDayOfMonth = DateTime(year, month, 1);
    final lastDayOfMonth = DateTime(year, month + 1, 0);

    print(firstDayOfMonth);
    print(lastDayOfMonth);

    List<List<DateTime>> weeks = [];
    DateTime startDate = firstDayOfMonth;
    DateTime endDate = firstDayOfMonth.add(Duration(days: 6 - firstDayOfMonth.weekday));

    while (endDate.isBefore(lastDayOfMonth)) {
      weeks.add([startDate, endDate]);
      startDate = endDate.add(const Duration(days: 1));
      endDate = startDate.add(const Duration(days: 6));
    }

    weeks.add([startDate, lastDayOfMonth]);

    return weeks;
  }

    //fetch data
  Future<List<TableProductField>> fetchData(DateTime startDate, DateTime endDate) async {
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
        // If the download fails, resolve with the value "failure"
        Navigator.pop(context, "failure");
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
      // If the download fails, resolve with the value "failure"
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
    _createExcel();
  }

  @override
  Widget build(BuildContext context) {
   
    return Container();
  }

  
Future <void> _createExcel()  async {

// Create a new Excel Document.
    final Workbook workbook = Workbook();

    // Accessing worksheet via index.
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'JARVIS';
    //sheet.showGridlines = false; this function to close the sheet line

    // Set page settings
    sheet.pageSetup.orientation = ExcelPageOrientation.landscape;
    sheet.pageSetup.fitToPagesWide;

    //title
    sheet.getRangeByName('B2').setText('Report Details ${widget.calendarOptionName}ly Summary');
    
    // Apply font styles to specific cells
    sheet.getRangeByName('B2:B2').cellStyle.bold = true;
    sheet.getRangeByName('B2:B2').cellStyle.fontName = 'Helvetica';
    sheet.getRangeByName('B2:B2').cellStyle.fontSize = 14;

    final Range headerRange = sheet.getRangeByName('B4:G4');
    headerRange.cellStyle.fontSize = 12;

    //bil
    sheet.getRangeByIndex(4, 2).setText('Bil');
    sheet.getRangeByIndex(5, 2).number = 1;
    sheet.getRangeByIndex(5, 2, 10, 2).merge();
    sheet.getRangeByIndex(5, 2).columnWidth = 4.09;
    
    //image
    final Range imageRange = sheet.getRangeByName('C4:D4');
    imageRange.merge();
    sheet.getRangeByIndex(4, 3).setText('Pic Part');
    sheet.getRangeByIndex(5, 3, 10, 4).merge();
    sheet.getRangeByIndex(5, 3,10,4).columnWidth = 15;

    // Fetch the image from the API
    final imageUrl = 'http://lsftech2.ddns.net:8888/img/${widget.model}/${widget.partNo}.png';
  try {
    final Uint8List imageData = await fetchImage(imageUrl);
    // Insert the image into the Excel file
    // ... code to insert the image ...
    print('Image inserted successfully');
     final Picture picture = sheet.pictures.addStream(5,3, imageData);
      picture.lastRow = 11;
      picture.lastColumn = 5;
      // Re-size an image
        picture.height = 100;
        picture.width = 100;
  } catch (e) {
    print('Error fetching or inserting image: $e');
     //Replace the text "1" with the image
        sheet.getRangeByIndex(5, 3).setText('Failed to fetch image for this:  \n $imageUrl');
        // Enable text wrapping for the cell
        final Style cellStyle = sheet.getRangeByIndex(5, 3).cellStyle;
        cellStyle.wrapText = true;

        

  }

    //model
    sheet.getRangeByIndex(4, 5).setText('MODEL');
    sheet.getRangeByIndex(5, 5, 10, 5).merge();
    sheet.getRangeByIndex(5, 5).text = '${widget.partNo}';
    sheet.getRangeByIndex(5, 5).columnWidth = 20;

    //field
    sheet.getRangeByIndex(4, 6).setText('Field');
    sheet.getRangeByIndex(5, 6, 6, 6).merge();
    sheet.getRangeByIndex(5, 6).text = 'Stamping Mi1';
    sheet.getRangeByIndex(7, 6, 8, 6).merge();
    sheet.getRangeByIndex(7, 6).text = 'Stamping Mi2';
    sheet.getRangeByIndex(9, 6).text = 'Delivery';
    sheet.getRangeByIndex(10, 6).text = 'Fg Stock';

    //data type:
    sheet.getRangeByIndex(4, 7).setText('');
    sheet.getRangeByIndex(5, 7).setText('Plan');
    sheet.getRangeByIndex(6, 7).setText('Actual');
    sheet.getRangeByIndex(7, 7).setText('Plan');
    sheet.getRangeByIndex(8, 7).setText('Actual');
    sheet.getRangeByIndex(9, 7).setText('Actual');
    sheet.getRangeByIndex(10, 7).setText('Actual');
    sheet.getRangeByName('F4:G10').columnWidth = 9;



    // Specify the data range
   List<List<DateTime>> weeks = calculateWeeks(widget.selectedYearPass, widget.selectedMonthPass);
    final List<TableProductField> data = await fetchData(weeks.first.first, weeks.last.last);
    const int startRow = 4; // Starting row for data
    const int startColumn = 8; // Starting column for data

    //to get data length for each week
    List dataWeek= [];
    int n =0;

    //weeks.length is get based in the calculateWeeks function 
     for (int i = 0; i < weeks.length; i++) {
      dataWeek.add(data.sublist( n, weeks[i].last.difference(weeks[i].first).inDays + 1 + n));
      n = n + weeks[i].last.difference(weeks[i].first).inDays + 1;
    }

    //iterate over each week header date 
     for (int i = 0; i < weeks.length; i++) {
    final List<DateTime> week = weeks[i];
    final DateTime startDate = week[0];
    final DateTime endDate = week[1];
    final int column = startColumn + i; // Increment column for each week
    final String startDateFormatted = DateFormat('dd/MM/yy').format(startDate);
    final String endDateFormatted = DateFormat('dd/MM/yy').format(endDate);

   sheet.getRangeByIndex(startRow, column).setText(' $startDateFormatted ~ $endDateFormatted');

    // Adjust the data range for each week
    final Range dataRange = sheet.getRangeByIndex(startRow, column + 1, startRow + 1, column + 6);
    dataRange.cellStyle.numberFormat = 'General';   
  }

  //to calculate total for each field and all weeks 
  int i =0;
  // Calculate the sum for all weeks
    double pmi1TotalAllWeeks = 0;
    double stampingMi1TotalAllWeeks = 0;
    double pmi2TotalAllWeeks = 0;
    double stampingMi2TotalAllWeeks = 0;
    double deliveryTotalAllWeeks = 0;
    double fgStockTotalAllWeeks= 0;

  for(List<TableProductField> item1 in dataWeek){
      double pmi1Total = 0;
      double stampingMi1Total = 0;
      double pmi2Total = 0;
      double stampingMi2Total = 0;
      double deliveryTotal = 0;
      double fgStockTotal = 0;
     final int column = startColumn + i; // Increment column for each week
      //total for each field for a week 
      for(TableProductField item2 in item1){
        pmi1Total += item2.pmi1;
        stampingMi1Total += item2.stampingMi1;
        pmi2Total += item2.pmi2;
        stampingMi2Total += item2.stampingMi2;
        deliveryTotal += item2.delivery;
        fgStockTotal += item2.fgStock;
      }
    
    sheet.getRangeByIndex(startRow+1,column).setNumber(pmi1Total);
    sheet.getRangeByIndex(startRow + 2, column ).setNumber(stampingMi1Total);
    sheet.getRangeByIndex(startRow + 3, column ).setNumber(pmi2Total);
    sheet.getRangeByIndex(startRow + 4, column ).setNumber(stampingMi2Total);
    sheet.getRangeByIndex(startRow + 5, column ).setNumber(deliveryTotal);
    sheet.getRangeByIndex(startRow + 6, column ).setNumber(fgStockTotal);
    i++;
  // Calculate the sum for all weeks

    pmi1TotalAllWeeks += pmi1Total;
    stampingMi1TotalAllWeeks += stampingMi1Total;
    pmi2TotalAllWeeks += pmi2Total;
    stampingMi2TotalAllWeeks += stampingMi2Total;
    deliveryTotalAllWeeks += deliveryTotal;
    fgStockTotalAllWeeks += fgStockTotal;

  }


  // Adjust the data range for the total column
final int totalColumn = startColumn + weeks.length;
final Range totalRange = sheet.getRangeByIndex(startRow, totalColumn, startRow + 1, totalColumn);
totalRange.cellStyle.numberFormat = 'General';

// Set the "Total" text in the "Total" column
    sheet.getRangeByIndex(4, totalColumn).setText('Total');

// Set the total value for all weeks in the total column
sheet.getRangeByIndex(startRow + 1, totalColumn).number = pmi1TotalAllWeeks;
sheet.getRangeByIndex(startRow + 2, totalColumn).number = stampingMi1TotalAllWeeks;
sheet.getRangeByIndex(startRow + 3, totalColumn).number = pmi2TotalAllWeeks;
sheet.getRangeByIndex(startRow + 4, totalColumn).number = stampingMi2TotalAllWeeks;
sheet.getRangeByIndex(startRow + 5, totalColumn).number = deliveryTotalAllWeeks;
sheet.getRangeByIndex(startRow + 6, totalColumn).number = fgStockTotalAllWeeks;

   // sheet.getRangeByName('B4:totalColumn').autoFitColumns();
    sheet.getRangeByIndex(4,2,10,totalColumn).autoFitColumns();
    final Style style1 = workbook.styles.add('style1');
    style1.borders.all.lineStyle = LineStyle.medium;
    style1.vAlign =VAlignType.center;
    style1.hAlign=HAlignType.center;
   // sheet.getRangeByName('B4:totalColumn').cellStyle = style1;
   sheet.getRangeByIndex(4,2,10,totalColumn ).cellStyle = style1;


  Future.delayed(Duration.zero, () async {
      // Save and dispose the document.
      // final List<int> bytes = workbook.saveSync();
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      
      // Generate the file name with the current date and time
      final String currentDateTime = DateFormat('yyMMdd_HHmmss').format(DateTime.now());
      final String fileName = 'Jarvis_$currentDateTime.xlsx';

      // launch the Excel
      saveAndLaunchFile(bytes, fileName, context);

      // close the page
        // If the download is successful, resolve with the value "success"
        Navigator.pop(context, "success");
    });

}
}

