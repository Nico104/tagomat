import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../custom_input_formatter.dart';
import '../utils.dart';

class CreateTagInfo extends StatefulWidget {
  const CreateTagInfo({super.key, required this.file});

  final Uint8List file;

  @override
  State<CreateTagInfo> createState() => _CreateTagInfoState();
}

class _CreateTagInfoState extends State<CreateTagInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _activationCode = TextEditingController();
  final TextEditingController _collarTagId = TextEditingController();

  String? tagIdErrorText;

  int activationCodeLength = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Tag"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                        // activationCodeLength +
                        //     (activationCodeLength / 4).round() -
                        //     1,
                        activationCodeLength,
                      ),
                      // CustomInputFormatter(),
                    ],
                    decoration: const InputDecoration(
                      labelText: "ActivationCode",
                    ),
                    controller: _activationCode,
                    validator: (value) {
                      if (value != null) {
                        if (value.length == activationCodeLength) {
                          return null;
                        }
                      }
                      return "Activiton Code must consist of 12 Symbols";
                    },
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                    onPressed: () {
                      _activationCode.text =
                          generateActivationCode(activationCodeLength);
                    },
                    icon: const Icon(Icons.celebration_rounded)),
              ],
            ),
            const SizedBox(height: 28),
            TextFormField(
              decoration: InputDecoration(
                labelText: "CollarTag Id",
                errorText: tagIdErrorText,
              ),
              controller: _collarTagId,
              validator: (value) {
                if (value != null) {
                  if (value.isNotEmpty) {
                    return null;
                  }
                }
                return "CollarTagID must be given";
              },
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (await isTagIdAvailable(_collarTagId.text)) {
                    setState(() {
                      tagIdErrorText = null;
                    });

                    uploadPicture(widget.file).then((picturePath) {
                      print("PicturePath: " + picturePath.toString());
                      if (picturePath != null) {
                        createNewPetProfile(
                          _activationCode.text,
                          _collarTagId.text,
                          picturePath,
                        ).then((value) {
                          Navigator.pop(context);
                        });
                      }
                    });
                  } else {
                    setState(() {
                      tagIdErrorText = "TagId already in Use";
                    });
                  }
                }
              },
              child: const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }
}
