import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:irespawn/src/model/addressmodel.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfApi {
  static Future<File> saveDocument({
    String name,
    Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    //mycode.....
    // storage permission ask
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    // the downloads folder path
    Directory tempDir = await DownloadsPathProvider.downloadsDirectory;
    String tempPath = tempDir.path;
    var filePath = tempPath + '/$name';
    // the data

    var bytes1 = ByteData.view(bytes.buffer);
    final buffer = bytes1.buffer;
    // save the data in the path
    // Fluttertoast.showToast(msg: "Invoice saved at location: $filePath");
    return File(filePath).writeAsBytes(buffer.asUint8List(bytes1.offsetInBytes, bytes1.lengthInBytes));

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }


  //to send the Invoice pdf through mail...
  static Future sendMail(File file, String orderID) async{
    String username = 'irespawn777@gmail.com';
    String password = 'power is power@777';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Hii, Abhishek from iRespawn')
      ..recipients.add(respawn.sharedPreferences.getString(respawn.userEmail).toString())
      // ..recipients.add('abhishek.sa780@gmail.com')
    // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Purchase Invoice ${DateTime.now()}'
      ..text = 'Dear Customer,\nWe express our heartfelt gratitude for being a part of the iRespawn family. Enjoy your purchase.\n\nKindly find the purchase invoice attached below for the Order ID: $orderID\n\nThank you,\nAbhishek S,\nTeam iRespawn '
      .. attachments.add(FileAttachment(file));
    // ..attachments = [
    // FileAttachment(File('exploits_of_a_mom.png'))
    //   ..location = Location.inline
    //   ..cid = '<myimg@3.141>'
    // ];
    // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    // DONE


    // Let's send another message using a slightly different syntax:
    //
    // Addresses without a name part can be set directly.
    // For instance `..recipients.add('destination@example.com')`
    // If you want to display a name part you have to create an
    // Address object: `new Address('destination@example.com', 'Display name part')`
    // Creating and adding an Address object without a name part
    // `new Address('destination@example.com')` is equivalent to
    // adding the mail address as `String`.
    // final equivalentMessage = Message()
    //   ..from = Address(username, 'Your name 😀')
    //   ..recipients.add(Address('destination@example.com'))
    //   ..ccRecipients.addAll([Address('destCc1@example.com'), 'destCc2@example.com'])
    //   ..bccRecipients.add('bccAddress@example.com')
    //   ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
    //   ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    //   ..html = '<h1>Test</h1>\n<p>Hey! Here is some HTML content</p><img src="cid:myimg@3.141"/>';
    // ..attachments = [
    // FileAttachment(File('exploits_of_a_mom.png'))
    //   ..location = Location.inline
    //   ..cid = '<myimg@3.141>'
    // ];

    // final sendReport2 = await send(equivalentMessage, smtpServer);

    // Sending multiple messages with the same connection
    //
    // Create a smtp client that will persist the connection
    var connection = PersistentConnection(smtpServer);

    // Send the first message
    await connection.send(message);

    // send the equivalent message
    // await connection.send(equivalentMessage);

    // close the connection
    await connection.close();
  }

  //to send user notification....
  //to send notification mail to user after order shipped...

  static Future sendMailUser(String email, String orderID, AddressModel addressModel) async{
    String username = 'irespawn777@gmail.com';
    String password = 'power is power@777';

    String name= addressModel.name;
    String flatNumber= addressModel.flatNumber;
    String street= addressModel.street;
    String landmark= addressModel.landmark;
    String city= addressModel.city;
    String pincode= addressModel.pincode;


    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Hii, Abhishek from iRespawn')
      ..recipients.add(email)
    // ..recipients.add('abhishek.sa780@gmail.com')
    // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Order Shipped At: ${DateTime.now()}'
      ..text = 'Dear Customer,\nWe express our heartfelt gratitude for being a part of the iRespawn family.\n\nYour order with the Order ID: $orderID has been shipped successfully, and will be delivered shortly to the below address \n\n'+name+','+'\n'+flatNumber+','+street+','+'\n'+landmark+','+'\n'+city+' - '+pincode+'\n\n'+'Thank you,\nAbhishek S,\nTeam iRespawn ';
    // ..attachments = [
    // FileAttachment(File('exploits_of_a_mom.png'))
    //   ..location = Location.inline
    //   ..cid = '<myimg@3.141>'
    // ];
    // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    // Sending multiple messages with the same connection
    //
    // Create a smtp client that will persist the connection
    var connection = PersistentConnection(smtpServer);

    // Send the first message
    await connection.send(message);

    // send the equivalent message
    // await connection.send(equivalentMessage);

    // close the connection
    await connection.close();
  }

}
