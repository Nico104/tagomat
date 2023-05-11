import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'creat_info.dart';

class TagCreationMenu extends StatefulWidget {
  const TagCreationMenu({Key? key}) : super(key: key);

  @override
  State<TagCreationMenu> createState() => _TagCreationMenuState();
}

class _TagCreationMenuState extends State<TagCreationMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Tag"),
      ),
      body: ElevatedButton(
        onPressed: () {
          pickFile().then(
            (value) {
              if (value != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateTagInfo(
                      file: value,
                    ),
                  ),
                );
              }
            },
          );
        },
        child: const Text("Choose Picture"),
      ),
    );
  }
}

Future<Uint8List?> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    withData: true,
    type: FileType.custom,
    // allowedExtensions: ["jpg", "jpeg", 'png', 'pdf', 'doc', 'mp3', 'm4a'],
    allowedExtensions: ['png'],
    allowMultiple: false,
  );

  if (result != null && result.files.isNotEmpty) {
    Uint8List fileBytes = result.files.first.bytes!;
    return fileBytes;
  }
  return null;
}
