//create pdf is the pdf format went we choose the weekly report 

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as Pdf;
import 'package:http/http.dart' as http;
import 'dart:convert';

// local file
import '../device/mobile.dart' if (dart.library.html) '../device/web.dart';

class createPDF extends StatefulWidget {
  final String model;
  final String partNo;
  final String startDate;
  final String endDate;
  final String calendarOptionName; // Declare calendarOptionName here

  const createPDF(
      {super.key,
      required this.model,
      required this.partNo,
      required this.startDate,
      required this.endDate,
      required this.calendarOptionName});

  @override
  _createPDFState createState() => _createPDFState();
}

class _createPDFState extends State<createPDF> {
  List<String> dateHeaders = []; // List to store the date headers

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

    // Create a new PDF document.
    final PdfDocument document = PdfDocument();

    // Adds page settings.
    document.pageSettings.orientation = PdfPageOrientation.landscape;
    document.pageSettings.margins.all = 50;

    // Add a new page to the document.
    final PdfPage page = document.pages.add();

    // Calculate the range of dates
    DateTime startDate = DateFormat('yyyy-MM-dd').parse(widget.startDate);
    DateTime endDate = DateFormat('yyyy-MM-dd').parse(widget.endDate);

    int difference = endDate.difference(startDate).inDays;

    // Generate the date headers
    for (int i = 0; i <= difference; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      String formattedDate = DateFormat('  dd/MM/yy').format(currentDate);
      dateHeaders.add(formattedDate);
    }

    // Report Summary
    PdfGraphics graphics = page.graphics;
    graphics.drawString(
        'Report Details ${widget.calendarOptionName}ly Summary  ',
        PdfStandardFont(PdfFontFamily.timesRoman, 30, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        format: Pdf.PdfStringFormat(
          alignment: Pdf.PdfTextAlignment.center,
        ));

    // Make API request and populate table cells
    String apiUrl =
        'http://lsftech2.ddns.net:8888/getrange/${widget.model}/${widget.partNo}/${widget.startDate}/${widget.endDate}/pmi1/stamping_mi1/pmi2/stamping_mi2/delivery/fg_stock/id';
    http.get(Uri.parse(apiUrl)).then((response) async {
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);

            // Create a new table for API data
            final PdfGrid apiDataTable = PdfGrid();
            apiDataTable.columns
                .add(count: 13); // Specify the number of columns in the table.

            // Add columns to the grid
            apiDataTable.columns.add(count: 13);
            apiDataTable.columns[0].width = 20;
            apiDataTable.columns[1].width = 100;
            apiDataTable.columns[2].width = 80;
            apiDataTable.columns[3].width = 70;
            apiDataTable.columns[4].width = 70;
            for (int i = 5; i < 13; i++) {
              apiDataTable.columns[i].width = 50;
            }

            // Add table headers
            apiDataTable.headers.add(1);
            apiDataTable.headers[0].cells[0].value = 'bil';
            apiDataTable.headers[0].cells[0].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.center,
            );
            apiDataTable.headers[0].cells[1].value = 'Pic Part';
            apiDataTable.headers[0].cells[1].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.center,
            );
            apiDataTable.headers[0].cells[2].value = 'model';
            apiDataTable.headers[0].cells[2].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.center,
            );
            apiDataTable.headers[0].cells[3].value = 'field';
            apiDataTable.headers[0].cells[3].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.center,
            );
            apiDataTable.headers[0].cells[4].value = '';
            apiDataTable.headers[0].cells[4].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.center,
            );
            apiDataTable.headers[0].cells[12].value = 'Total';
            apiDataTable.headers[0].cells[12].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.center,
            );

            // Add date headers
            for (int i = 0; i < dateHeaders.length; i++) {
              apiDataTable.headers[0].cells[i + 5].value = dateHeaders[i];
              apiDataTable.headers[0].cells[i + 5].stringFormat =
                  PdfStringFormat(
                alignment: PdfTextAlignment.center,
              );
            }

            //Add table data.
            //row1
            final PdfGridRow row = apiDataTable.rows.add();
            row.cells[0].value = ' 1';
            row.cells[0].rowSpan = 6;
            //row.cells[1].value = image;
            row.cells[1].rowSpan = 6;
            row.cells[2].value = ' ' + widget.partNo;
            row.cells[2].rowSpan = 6;
            row.cells[3].value = ' stamping pmi 1';
            row.cells[3].rowSpan = 2;
            row.cells[4].value = ' plan';


            //fetch image 
            final imageUrl ='http://lsftech2.ddns.net:8888/img/${widget.model}/${widget.partNo}.png';

              try{
                    final Uint8List imageData = await fetchImage(imageUrl);
                     print('Image inserted successfully');
                     PdfBitmap image = PdfBitmap(imageData);
                    PdfGridCell cell1 = row.cells[1];
                    //Sets the image alignment type of the PdfGridCell image
                    cell1.imagePosition = PdfGridImagePosition.stretch;
                    cell1.style.backgroundImage = image;
              } catch (e){

                      print('Error fetching or inserting image: $e');
                  //Replace the text "1" with the image
                    PdfGridCell cell1 = row.cells[1];
                    cell1.value='Failed to fetch image url: ${imageUrl}';
            }

           
            num totalValue = 0;
            for (int i = 0; i < responseData.length; i++) {
              row.cells[i + 5].value = '  ' + responseData[i]['pmi1'].toString();
              totalValue += responseData[i]['pmi1'];
            }
            row.cells[12].value = totalValue.toString();

            //row2
            final PdfGridRow row2 = apiDataTable.rows.add();
            row2.cells[3].value = 'merge';
            row2.cells[4].value = ' actual';

            num totalValue2 = 0;
            for (int i = 0; i < responseData.length; i++) {
              row2.cells[i + 5].value ='  ' + responseData[i]['stamping_mi1'].toString();
              totalValue2 += responseData[i]['stamping_mi1'];
            }
            row2.cells[12].value = totalValue2.toString();

            //row3
            final PdfGridRow row3 = apiDataTable.rows.add();
            row3.cells[3].value = ' stamping pmi 2';
            row3.cells[3].rowSpan = 2;
            row3.cells[4].value = ' plan';

            num totalValue3 = 0;

            for (int i = 0; i < responseData.length; i++) {
              row3.cells[i + 5].value ='  ' + responseData[i]['pmi2'].toString();
              totalValue3 += responseData[i]['pmi2'];
            }
            row3.cells[12].value = totalValue3.toString();

            //row4
            final PdfGridRow row4 = apiDataTable.rows.add();
            row4.cells[3].value = 'merge';
            row4.cells[4].value = ' actual';

            num totalValue4 = 0;

            for (int i = 0; i < responseData.length; i++) {
              row4.cells[i + 5].value = '  ' + responseData[i]['stamping_mi2'].toString();
              totalValue4 += responseData[i]['stamping_mi2'];
            }
            row4.cells[12].value = totalValue4.toString();

            //row5
            final PdfGridRow row5 = apiDataTable.rows.add();
            row5.cells[3].value = ' delivery';
            row5.cells[4].value = ' actual';

            num totalValue5 = 0;

            for (int i = 0; i < responseData.length; i++) {
              row5.cells[i + 5].value ='  ' + responseData[i]['delivery'].toString();
              totalValue5 += responseData[i]['delivery'];
            }
            row5.cells[12].value = totalValue5.toString();

            //row6
            final PdfGridRow row6 = apiDataTable.rows.add();
            row6.cells[3].value = ' fg_stock';
            row6.cells[4].value = ' actual';

            num totalValue6 = 0;

            for (int i = 0; i < responseData.length; i++) {
              row6.cells[i + 5].value ='  ' + responseData[i]['fg_stock'].toString();
              totalValue6 += responseData[i]['fg_stock'];
            }
            row6.cells[12].value = totalValue6.toString();

            // Draw the grid in PDF document page
            apiDataTable.draw(
                page: page, bounds: const Rect.fromLTRB(10, 50, 0, 0));

            // Save the PDF to the device
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
      else {
        print('API request failed with status code: ${response.statusCode}');
          Navigator.pop(context, "failure");

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
