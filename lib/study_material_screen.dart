import 'package:flutter/material.dart';
// Import the file reader package
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart'; // For accessing temporary directory
import 'dart:io';
import 'package:flutter/services.dart'; // For accessing assets

class StudyMaterialScreen extends StatefulWidget {
  final String courseName;

  const StudyMaterialScreen({super.key, required this.courseName});

  @override
  _StudyMaterialScreenState createState() => _StudyMaterialScreenState();
}

class _StudyMaterialScreenState extends State<StudyMaterialScreen> {
  List<String> filePaths = [];

  @override
  void initState() {
    super.initState();
    _loadStudyMaterials();
  }

  Future<void> _loadStudyMaterials() async {
    // Replace this with your actual logic to fetch files based on courseName
    // For now, we'll simulate loading files from assets based on the course name.
    // You might need a more structured way to organize your assets.

    List<String> filesForCourse = [];
    if (widget.courseName == 'Computational Modelling') {
      filesForCourse = [
        'assets/files/Computational Modelling.pdf',
        'assets/files/SCS2209_courseOutline.docx',
        'assets/files/calder-et-al-2018-computational-modelling-for-decision-making-where-why-what-who-and-how.pdf'
      ];
    } else if (widget.courseName == 'Mobile App development') {
      filesForCourse = [
        'assets/files/Lecture 1_Introduction to Mobile Platforms.pptx',
        'assets/files/Lecture 2_Principles of Mobile App Design & Dev.pptx',
        'assets/files/Lecture 3_Platform & Development Framework.pptx',
        'assets/files/Lecture 4_Dart Programming.pptx'
      ];
    } else if (widget.courseName == 'Advanced Mathematical') {
      filesForCourse = [
        'assets/files/Bayes Theorem1.ppt',
        'assets/files/Bayess Theorem  presentation.ppt',
        'assets/files/Probability and Uncertainty Lesson 1.pptx',
        'assets/files/logical connectives Lesson 7.pptx'
      ];
    }

    List<String> tempPaths = [];
    for (String assetPath in filesForCourse) {
      try {
        final byteData = await rootBundle.load(assetPath);
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/${assetPath.split('/').last}');
        await file.writeAsBytes(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        tempPaths.add(file.path);
      } catch (e) {
        print('Error loading asset: $assetPath - $e');
      }
    }

    setState(() {
      filePaths = tempPaths;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.courseName} Study Material'),
      ),
      body: ListView.builder(
        itemCount: filePaths.length,
        itemBuilder: (context, index) {
          final filePath = filePaths[index];
          final fileName = filePath.split('/').last;
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(fileName),
              onTap: () {
                // Use the FileReader package to open the file
                OpenFile.open(filePath);
              },
            ),
          );
        },
      ),
    );
  }
}
