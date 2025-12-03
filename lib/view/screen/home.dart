import 'dart:convert';
import 'dart:developer';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:live_translate/services/audio_service.dart';
import 'package:live_translate/services/speech_service.dart';
import 'package:live_translate/view/screen/widgets/my_text_title.dart';
import 'package:live_translate/view/screen/widgets/my_textfield.dart';
import 'package:live_translate/view/screen/widgets/sizebox_square.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController originTextController = TextEditingController();
  final TextEditingController translateTextcontroller = TextEditingController();
  
  
  bool isRecording = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Row(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: SpeechService.instance.startStream(AudioService.instance.audioStream),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasData) {
                    originTextController.text = asyncSnapshot.data ?? "";
                    // log("data: ${asyncSnapshot.data.toString()}");
                  }
                  return SidePanel(
                    panelName: "Original",
                    controller: originTextController,
                  );
                }
              ),
            ),
            SizeboxSquare(size: 20),
            Expanded(
              child: SidePanel(
                panelName: "Translated",
                controller: translateTextcontroller,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        isRecording: isRecording,
        onTap: (value) {
          isRecording = value;

          if(isRecording)
          {
            AudioService.instance.startRecording();
          }else
          {
            AudioService.instance.stopRecording();
          }

          setState(() {});
        },
      ),
    );
  }
}

class FloatingActionButton extends StatelessWidget {
  bool isRecording;
  final ValueChanged<bool> onTap;
  FloatingActionButton({
    super.key,
    required this.isRecording,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // return ImageIcon(AssetImage("assets/icons/static/microphone.png"));
    return isRecording
        ? GestureDetector(
            onTap: () {
              onTap(!isRecording);
            },
            child: AnimateGradient(
              primaryBegin: Alignment.topLeft,
              primaryEnd: Alignment.bottomLeft,
              secondaryBegin: Alignment.bottomLeft,
              secondaryEnd: Alignment.topRight,
              primaryColors: const [
                Colors.pink,
                Colors.pinkAccent,
                Colors.white,
              ],
              secondaryColors: const [
                Colors.white,
                Colors.blueAccent,
                Colors.blue,
              ],
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                width: 50,
                height: 50,
              ),
            ),
          )
        : IconButton.outlined(
            onPressed: () {
              onTap(!isRecording);
            },
            icon: Icon(Icons.mic, size: 30,),
            
          );
  }
}

class SidePanel extends StatelessWidget {
  final String panelName;
  final TextEditingController controller;
  const SidePanel({
    super.key,
    required this.panelName,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextTitle(text: panelName),
        MyTextfield(controller: controller),
      ],
    );
  }
}
