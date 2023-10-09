import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/style.dart';
import '../screens/details.dart';
import 'line.dart';

class ModelPartContainer {
  String model;
  String part;
  StatefulBuilder widget;

  ModelPartContainer(
      {required this.model, required this.part, required this.widget});
}

class Mp extends StatefulWidget {
  //const apiJ({super.key});
  final String data;

  const Mp({super.key, required this.data});

  @override
  State<Mp> createState() => _MpState();
}

class _MpState extends State<Mp> {
  List<Line> lines = [];

  List<ModelPartContainer> modelPartContainers =[]; // List of ModelPartContainer objects

  List<bool> containerExpanded = [];

  List<ModelPartContainer> filteredModelPartContainers =[]; // Declaration outside the function

  int containerIndex = 0; // Define the containerIndex variable

  bool isSearchVisible = false; // Track the visibility of the search field
  String searchQuery = ''; // Track the search query

  List<ModelPartContainer> originalModelPartContainers = [];
  List<bool> originalContainerExpanded = [];

  List<Line> filteredLines = []; // Declare and initialize the variable

  String? selectedValue;

  bool _isLoading = true; // Add a boolean variable for loading state

  @override
  void initState() {
    super.initState();
    fetchLineData();
  }

  void toggleSearchVisibility() {
    setState(() {
      isSearchVisible = !isSearchVisible;
      if (!isSearchVisible) {
        searchQuery = ''; // Clear the search query when hiding the search field
      }
    });
  }

  void fetchLineData() async {
    setState(() {
      _isLoading = true; // Set isLoading to true before making the API request
    });
    try {
      String url = 'http://lsftech2.ddns.net:8888/getline/${widget.data}';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as List<dynamic>;
        final List<ModelPartContainer> modelPartContainersTemp = [];
        final List<bool> containerExpandedTemp = [];

        for (var item in jsonResponse) {
          final model = item['model'];
          final part = item['part'];
          final imageUrl = 'http://lsftech2.ddns.net:8888/img/$model/$part.png';
          final image = Image.network(
            imageUrl,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return ClipRRect(
                borderRadius:
                    BorderRadius.circular(6), // Set the desired border radius
                child: Image.asset(
                      'assets/images/error-image-key.png',
                  fit: BoxFit.cover,
                ),
              );
            },
          );

          final modelText = TextSpan(
            text: 'Model: \n',
            style: const TextStyle(
              color: blue,
            ),
            children: <TextSpan>[
              TextSpan(
                text: model,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )
            ],
          );
          final partText = TextSpan(
            text: 'Part No: \n',
            style:const TextStyle(
              color: blue,
            ),
            children: <TextSpan>[
              TextSpan(
                text: part,
                style:const  TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          );
          final partName = TextSpan(
            text: 'Part Name: \n',
            style: const TextStyle(
              color: blue,
            ),
            children: <TextSpan>[
              TextSpan(
                text: part,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          );
          final StatefulBuilder modelPartContainerWidget = StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsPage(
                              model: model,
                              partNo: part,
                            )),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  height: containerExpandedTemp[containerIndex] ? 170 : 100,
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 100,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: blue,
                                  width: 3,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                               clipBehavior: Clip.antiAlias,
                               child: image
                              ),
                      ),
                           const SizedBox(width: 5.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(text: partText),
                                  RichText(text: modelText),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon: Icon(
                                  containerExpandedTemp[containerIndex]
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                ),
                                onPressed: () {
                                  setState(() {
                                    // Toggle the containerExpanded value
                                    containerExpandedTemp[containerIndex] =
                                        !containerExpandedTemp[containerIndex];
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        if (containerExpandedTemp[containerIndex])
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(text: partName),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Machine:',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
          modelPartContainersTemp.add(
            ModelPartContainer(
              model: model,
              part: part,
              widget: modelPartContainerWidget,
            ),
          );
          containerExpandedTemp.add(false);
        }
        setState(() {
          modelPartContainers = modelPartContainersTemp;
          containerExpanded = containerExpandedTemp;
          originalModelPartContainers = List.from(modelPartContainers);
          originalContainerExpanded = List.from(containerExpanded);
          _isLoading = false; // Set isLoading to false after fetching the data
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        _isLoading = false; // Set isLoading to false in case of an error
      });
    }
  }

  void filterData() {
    if (searchQuery.isEmpty) {
      // Search query is empty, return original data without filtering
      setState(() {
        modelPartContainers = List.from(originalModelPartContainers);
        containerExpanded = List.from(originalContainerExpanded);
      });
      return;
    }

    setState(() {
      modelPartContainers = originalModelPartContainers
          .where((container) =>
              container.model
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              container.part.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
      containerExpanded = List<bool>.filled(modelPartContainers.length, false);
    });
  }

  void sortDataByModel() {
    setState(() {
      modelPartContainers.sort((a, b) => a.part.compareTo(b.part));
    });
  }

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
        actions: [
          IconButton(
            icon: Icon(isSearchVisible ? Icons.close : Icons.search),
            onPressed: toggleSearchVisibility,
          ),
        ],
      ),
      body: Container(
        color: background,
        child: _isLoading
            ? const Center(
                child:
                    CircularProgressIndicator()) // Show loading indicator while fetching data

            : ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  //Text(widget.data),
                  Column(
                    children: [
                      const SizedBox(height: 5),
                      Visibility(
                        visible: isSearchVisible,
                        child: TextField(
                          onChanged: (String value) {
                            setState(() {
                              searchQuery = value;
                            });
                            filterData();
                          },
                          decoration: InputDecoration(
                              prefixIcon: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              setState(() {
                                isSearchVisible = false;
                                searchQuery = '';
                              });
                              filterData();
                            },
                          )
                              //labelText: 'Search by Model or Part No',
                              ),
                        ),
                      ),
                    ],
                  ),
                  //text
                  const Center(
                    child: Text(
                      'TOTAL REQUIRED STROKE/SLIDE',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //2 box
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 65,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border.all(
                                color: blue,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 65,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: blue,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: const Text(
                                    "JOB",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    "0",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 50),
                          Container(
                            width: 65,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border.all(
                                color: blue,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 65,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: blue,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: const Text(
                                    "PART",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    "0",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  //mostrecent&sort
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        ' Most Recent',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: blue,
                        ),
                      ),
                      Row(
                        children: [
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.sort,
                                  color: blue,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Stack(
                                        children: [
                                          Positioned(
                                            top: 180,
                                            right: 0,
                                            child: SizedBox(
                                              width: 250, // Set the desired width for the dialog

                                              child: AlertDialog(
                                                contentPadding: EdgeInsets.zero,
                                                content: Container(
                                                  decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: blue,
                                                    width: 4.0,
                                                  )),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Theme(
                                                        data: ThemeData(
                                                          radioTheme:RadioThemeData(
                                                            fillColor:
                                                                MaterialStateColor.resolveWith((states) {
                                                              if (states.contains(
                                                                  MaterialState.selected)) {
                                                                return blue; // Color when radio button is selected
                                                              }
                                                              return blue; // Color before radio button is selected
                                                            }),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            RadioListTile<String>(
                                                              title: const Text(
                                                                "Today's Plan",
                                                                style: TextStyle(
                                                                    color: blue),
                                                              ),
                                                              value:"Today's Plan",
                                                              groupValue:selectedValue,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  selectedValue = value;
                                                                });
                                                                print(
                                                                    'Selected: $value');
                                                                Navigator.pop( context);
                                                              },
                                                            ),
                                                            RadioListTile<String>(
                                                              title: const Text(
                                                                "Model",
                                                                style: TextStyle(
                                                                    color: blue),
                                                              ),
                                                              value: "Model",
                                                              groupValue:selectedValue,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  selectedValue =value;
                                                                });
                                                                print('Selected: $value');
                                                                sortDataByModel(); // sort the part no in ascending

                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                            RadioListTile<String>(
                                                              title: const Text(
                                                                "Alert",
                                                                style: TextStyle(
                                                                    color: blue),
                                                              ),
                                                              value: "Alert",
                                                              groupValue: selectedValue,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  selectedValue =value;
                                                                });
                                                                print(
                                                                    'Selected: $value');
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          const Text(
                            'Sort',
                            style: TextStyle(
                              fontSize: 15,
                              color: blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  //loop all the item container based on api length 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: modelPartContainers
                        .map((container) => container.widget)
                        .toList(),
                  ),
                ],
              ),
      ),
    );
  }
}
