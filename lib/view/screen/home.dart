import 'dart:developer';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:live_translate/provider/translate_model.dart';
import 'package:live_translate/services/audio_service.dart';
import 'package:live_translate/services/speech_service.dart';
import 'package:live_translate/services/translate_service.dart';
import 'package:live_translate/view/screen/widgets/my_dropdown_btn.dart';
import 'package:live_translate/view/screen/widgets/my_text_title.dart';
import 'package:live_translate/view/screen/widgets/my_textfield.dart';
import 'package:live_translate/view/screen/widgets/sizebox_square.dart';
import 'package:toastification/toastification.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController originTextController = TextEditingController();
  final TextEditingController translateTextcontroller = TextEditingController();
  final List<String> listLang = ["vi-VN", "en-US", "cmn-Hans-CN"];

  Stream<String>? _speechStream;

  int origLngIdx = 0;
  int transLngIdx = 0;
  bool isRecording = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.blueAccent,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
      themeMode: ThemeMode.system, // Automatically switch based on system theme
      home: ChangeNotifierProvider(
        create: (context) => TranslateModel.instance,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: Row(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: _speechStream,
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.hasError) {
                        showSnackBar(asyncSnapshot);
                      }
                      if (asyncSnapshot.hasData) {
                        originTextController.text = asyncSnapshot.data!;

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          translateTextcontroller.text =
                              originTextController.text;
                          final myModel = Provider.of<TranslateModel>(
                            context,
                            listen: false,
                          );
                          myModel.setState();
                        });
                      } else {
                        log("data empty: ${asyncSnapshot.data}");
                      }
                      log("data: ${asyncSnapshot.data}");
                      // orig
                      return SidePanel(
                        listLang: listLang,
                        idx: origLngIdx,
                        onTap: (value) {
                          origLngIdx = listLang.indexOf(value);
                          setState(() {});
                        },
                        panelName: "Original",
                        controller: originTextController,
                      );
                    },
                  ),
                ),
                SizeboxSquare(size: 20),
                Expanded(
                  // trans
                  child: Consumer<TranslateModel>(
                    builder: (context, value, child) {
                      return FutureBuilder(
                        future: TranslateService.instance.translate(
                          // origLang: listLang[origLngIdx],
                          transLang: listLang[transLngIdx],
                          text: translateTextcontroller.text,
                        ),
                        builder: (context, asyncSnapshot) {
                          log("translated: ${asyncSnapshot.data}");
                          if (asyncSnapshot.hasData) {
                            translateTextcontroller.text =
                                asyncSnapshot.data ?? "";
                          }

                          return SidePanel(
                            listLang: listLang,
                            idx: transLngIdx,
                            onTap: (value) {
                              transLngIdx = listLang.indexOf(value);
                            },
                            panelName: "Translated",
                            controller: translateTextcontroller,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            isRecording: isRecording,
            onTap: (value) {
              setState(() {
                isRecording = value;
              });

              if (isRecording) {
                _startListening();
              } else {
                AudioService.instance.stopRecording();
                SpeechService.instance.stopStream();
                // Clear the stream when recording stops
                _speechStream = null;
                originTextController.clear();
              }
            },
          ),
        ),
      ),
    );
  }

  void _startListening() async {
    // 1. Await the stream from AudioService
    final audioStream = await AudioService.instance.startRecording();

    // SpeechService.instance.init();
    // 2. Pass the obtained stream to SpeechService and update the state
    setState(() {
      _speechStream = SpeechService.instance.startStream(
        audioStream: audioStream,
        languageCode: listLang[origLngIdx],
      );
    });
  }

  void showSnackBar(AsyncSnapshot<String> asyncSnapshot) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      toastification.show(
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: Text("Error!"),
        description: Text(asyncSnapshot.error.toString()),
        alignment: Alignment.topLeft,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: lowModeShadow,
      );
    });
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
                  borderRadius: BorderRadius.circular(50), // Adapt to theme
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
            icon: Icon(
              Icons.mic,
              size: 30,
              color: Theme.of(context).primaryColor, // Adapt to theme
            ),
          );
  }
}

class SidePanel extends StatelessWidget {
  final String panelName;
  final TextEditingController controller;
  final List<String> listLang;
  final ValueChanged<String> onTap;
  final int idx;

  SidePanel({
    super.key,
    required this.panelName,
    required this.controller,
    required this.onTap,
    required this.idx,
    required this.listLang,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyTextTitle(text: panelName),
            MyDropdownBtn(
              idx: idx,
              items: listLang,
              onTap: (value) {
                onTap(value);
              },
            ),
          ],
        ),
        MyTextfield(controller: controller),
      ],
    );
  }
}
