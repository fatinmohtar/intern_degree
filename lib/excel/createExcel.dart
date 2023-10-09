//this createExcel will generate when selected the weekly
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

class createExcel extends StatefulWidget {
  final String model;
  final String partNo;
  final String startDate;
  final String endDate;
  final String calendarOptionName; // Declare calendarOptionName here

  const createExcel(
      {super.key, required this.model,
      required this.partNo,
      required this.startDate,
      required this.endDate,
      required this.calendarOptionName});

  @override
  State<createExcel> createState() => _createExcelState();
}

class _createExcelState extends State<createExcel> {
  @override
  void initState() {
    super.initState();
    _createExcel();
  }



  //fetch data
  Future<List<TableProductField>> fetchData() async {
    final String dataUrl =
        'http://lsftech2.ddns.net:8888/getrange/${widget.model}/${widget.partNo}/${widget.startDate}/${widget.endDate}/pmi1/stamping_mi1/pmi2/stamping_mi2/delivery/fg_stock/id';

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
  //create the excel
  Future<void> _createExcel() async {
    List<TableProductField> data = await fetchData();
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
    sheet.getRangeByName('B2:B2').cellStyle.fontSize = 15;

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
    // Insert the image into the Excel file
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
    final Range dataRange = sheet.getRangeByName('H4:N10');

    // Add values to columns 5 to 11
    DateTime currentDate = DateTime.parse(widget.startDate);
    for (int i = 7; i <= 13; i++) {
      if (currentDate.isBefore(DateTime.parse(widget.endDate)) ||
          currentDate.isAtSameMomentAs(DateTime.parse(widget.endDate))) {
        String formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
        sheet.getRangeByIndex(4, i + 1).setText(formattedDate);
      } else {
        sheet.getRangeByIndex(4, i + 1).setText('Column 13');
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Add data below the columns
    List<List<dynamic>> columnData = [];

    // Replace the column data with API data
    for (int i = 0; i < data.length; i++) {
      columnData.add([
        data[i].pmi1.toDouble(),
        data[i].stampingMi1.toDouble(),
        data[i].pmi2.toDouble(),
        data[i].stampingMi2.toDouble(),
        data[i].delivery.toDouble(),
        data[i].fgStock.toDouble(),
        // Add additional API data fields here
      ]);
    }

    for (int row = dataRange.row + 1; row <= dataRange.lastRow; row++) {
      for (int col = dataRange.column; col <= dataRange.lastColumn; col++) {
        // Update the loop condition here
        int dataRow = row - dataRange.row - 1; // Compute the data row index
        int dataCol = col - dataRange.column; // Compute the data column index
        sheet.getRangeByIndex(row, col).setValue(columnData[dataCol][dataRow]);
      }
    }

    // Calculate the sum for each field
    double pmi1Total = 0;
    double stampingMi1Total = 0;
    double pmi2Total = 0;
    double stampingMi2Total = 0;
    double deliveryTotal = 0;
    double fgStockTotal = 0;

    for (int i = 0; i < data.length; i++) {
      pmi1Total += data[i].pmi1.toDouble();
      stampingMi1Total += data[i].stampingMi1.toDouble();
      pmi2Total += data[i].pmi2.toDouble();
      stampingMi2Total += data[i].stampingMi2.toDouble();
      deliveryTotal += data[i].delivery.toDouble();
      fgStockTotal += data[i].fgStock.toDouble();
    }

// Set the "Total" text in the "Total" column
    sheet.getRangeByIndex(4, 15).setText('Total');

// Find the row index for the "Total" text
    int totalRowIndex = 4;

// Set the total sum values below the respective "Total" texts
    sheet.getRangeByIndex(totalRowIndex + 1, 15).setValue(pmi1Total);
    sheet.getRangeByIndex(totalRowIndex + 2, 15).setValue(stampingMi1Total);
    sheet.getRangeByIndex(totalRowIndex + 3, 15).setValue(pmi2Total);
    sheet.getRangeByIndex(totalRowIndex + 4, 15).setValue(stampingMi2Total);
    sheet.getRangeByIndex(totalRowIndex + 5, 15).setValue(deliveryTotal);
    sheet.getRangeByIndex(totalRowIndex + 6, 15).setValue(fgStockTotal);

    sheet.getRangeByName('B4:O10').autoFitColumns();
    final Style style1 = workbook.styles.add('style1');
    style1.borders.all.lineStyle = LineStyle.medium;
    style1.vAlign =VAlignType.center;
    style1.hAlign=HAlignType.center;
    sheet.getRangeByName('B4:O10').cellStyle = style1;


  

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

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
