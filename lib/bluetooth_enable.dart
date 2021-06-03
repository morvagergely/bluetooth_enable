import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BluetoothEnable {
  static const MethodChannel _channel = const MethodChannel('bluetooth_enable');

  static Future<String> get platformVersion async {
    return (await _channel.invokeMethod<String>('getPlatformVersion'))!;
  }

  static Future<String> get enableBluetooth async {
    return (await _channel.invokeMethod<String>('enableBluetooth'))!;
  }

  static Future<String> customBluetoothRequest(
      BuildContext context,
      String dialogTitle,
      bool displayDialogContent,
      String dialogContent,
      String cancelBtnText,
      String acceptBtnText,
      double dialogRadius,
      bool barrierDismissible) async {
    String dialogRet = await showAlertDialog(
        context,
        dialogTitle,
        displayDialogContent,
        dialogContent,
        cancelBtnText,
        acceptBtnText,
        dialogRadius,
        barrierDismissible);
    return dialogRet;
  }

  static Future<String> showAlertDialog(
      BuildContext context,
      String dialogTitle,
      bool displayDialogContent,
      String dialogContent,
      String cancelBtnText,
      String acceptBtnText,
      double dialogRadius,
      bool barrierDismissible) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(dialogRadius))),
          title: Text(dialogTitle),
          content: (displayDialogContent)
              ? SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(dialogContent),
                    ],
                  ),
                )
              : null,
          actions: <Widget>[
            TextButton(
              child: Text(cancelBtnText),
              onPressed: () {
                Navigator.of(context).pop("false");
              },
            ),
            TextButton(
              child: Text(acceptBtnText),
              onPressed: () async {
                String bluetoothState = await (_channel
                    .invokeMethod('customEnable') as FutureOr<String>);
                Navigator.of(context).pop(bluetoothState);
              },
            ),
          ],
        );
      },
    ).then((value) => value!);
  }
}
