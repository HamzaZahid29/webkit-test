import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meina to bola tha backend ka issue h',
      home: ImageDisplayPage(),
    );
  }
}

class ImageDisplayPage extends StatefulWidget {
  @override
  _ImageDisplayPageState createState() => _ImageDisplayPageState();
}

class _ImageDisplayPageState extends State<ImageDisplayPage> {
  List<String> imageUrls = []; // List to hold image URLs
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchImages(); // Fetch images on initialization
  }

  Future<void> fetchImages() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/images'));

      if (response.statusCode == 200) {
        List<dynamic> imageList = jsonDecode(response.body);
        setState(() {
          imageUrls = imageList.map((url) => url.toString()).toList(); // Convert dynamic to String
          isLoading = false; // Update loading state
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Stop loading
        errorMessage = error.toString(); // Capture the error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meina to bola tha backend ka issue h'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : errorMessage.isNotEmpty
            ? Text('Error: $errorMessage')
            : ListView.builder(
          itemCount: imageUrls.length, // Count of images
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(8.0), // Margin for each
              child: Image.network(
                imageUrls[index],
                width:MediaQuery.of(context).size.width, // Set desired width
                height: 400, // Set desired height
              ),
            );
          },
        ),
      ),
    );
  }
}
