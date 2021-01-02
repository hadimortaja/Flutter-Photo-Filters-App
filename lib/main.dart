import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_filters_app/filters.dart';
import 'dart:ui' as ui;

import 'package:photo_filters_app/second_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _globalKey = GlobalKey();
  final List<List<double>> filters = [
    NO_FILTER,
    SEPIA_MATRIX,
    GREYSCALE_MATRIX,
    VINTAGE_MATRIX,
    SWEET_MATRIX
  ];
  void convertWidgetToImage() async {
    RenderRepaintBoundary repaintBoundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image boxImage = await repaintBoundary.toImage(pixelRatio: 1);
    ByteData byteData =
        await boxImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8list = byteData.buffer.asUint8List();
    Navigator.of(_globalKey.currentContext).push(MaterialPageRoute(
        builder: (context) => SecondScreen(
              imageData: uint8list,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text("Image Filters"),
          actions: [
            IconButton(icon: Icon(Icons.check), onPressed: convertWidgetToImage)
          ],
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: RepaintBoundary(
            key: _globalKey,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: size.height,
                maxWidth: size.width,
              ),
              child: PageView.builder(
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    return ColorFiltered(
                      colorFilter: ColorFilter.matrix(filters[index]),
                      child: Image.asset(
                        "images/breakfast1.png",
                        width: size.width,
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
            ),
          ),
        ));
  }
}
