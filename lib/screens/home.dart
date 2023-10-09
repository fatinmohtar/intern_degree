import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//local file 
import '../constants/style.dart';
import '../model/MediumPress.dart';
import '../widgets/sidebar_menu.dart';

class HomePage extends StatefulWidget {
  //const APIline({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _apiData = []; // List to store the fetched API data
  bool _isLoading = true; // New variable to track loading state

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response =
        await http.get(Uri.parse('http://lsftech2.ddns.net:8888/showline'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> lines = jsonData as List<dynamic>;

      setState(() {
        _apiData = lines.map((line) => line['line'] as String).toList();
        _isLoading = false; // Set loading state to false after data is fetched

        print(_apiData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        title: const Text('Line Production'),
      ),
      drawer: const SidebarMenu(),
      body: Container(
        color: background,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            const Center(
              child: Text(
                'Category :',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w100,
                  fontFamily: 'Roboto',
                  color: blue,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: _isLoading // Check loading state
                  ? _buildLoadingIndicator() // Show loading indicator
                  : _buildDataList(), // Show data list
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildDataList() {
    return ListView.builder(
      itemCount: _apiData.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Mp(data: _apiData[index]),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  70,
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Medium Press  ' + _apiData[index],
                    style: textMP,
                  ),
                  const Flexible(
                    child: Icon(
                      Icons.chevron_right,
                      color: blue,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
