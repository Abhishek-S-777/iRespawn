/*
 * QR.Flutter
 * Copyright (c) 2019 the QR.Flutter authors.
 * See LICENSE for distribution and usage details.
 */

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

//// This is the screen that you'll see when the app starts...

class QRcode extends StatefulWidget {
  final String msg;


  QRcode({this.msg});

  @override
  _QRcodeState createState() => _QRcodeState();
}

class _QRcodeState extends State<QRcode> {
  @override
  Widget build(BuildContext context) {
    final message = widget.msg;
        // ignore: lines_longer_than_80_chars

    final qrFutureBuilder = FutureBuilder<ui.Image>(
      future: _loadOverlayImage(),
      builder: (ctx, snapshot) {
        final size = 280.0;
        if (!snapshot.hasData) {

          return Text("no QR");
        }
        return CustomPaint(
          size: Size.square(size),
          painter: QrPainter(
            data: message,
            version: QrVersions.auto,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Color(0xff128760),
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.circle,
              color: Color(0xff1a5441),
            ),
            // size: 320.0,
            // embeddedImage: snapshot.data,
            // embeddedImageStyle: QrEmbeddedImageStyle(
            //   size: Size.square(60),
            // ),
          ),
        );
      },
    );

    return Material(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Container(
                    width: 280,
                    child: qrFutureBuilder,
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40)
              //       .copyWith(bottom: 40),
              //   child: Text(message),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40)
                    .copyWith(bottom: 40),
                child: Text("1. Show this qr code to the delivery guy to receive your product!\n\n2. After successful scan, please redirect to the previous page where you can download your invoice and a copy of the same will be sent to your registered mail",style: TextStyle(fontSize: 17),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<ui.Image> _loadOverlayImage() async {
    final completer = Completer<ui.Image>();
    final byteData = await rootBundle.load('assets/images/ab5.jpg');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }
}
