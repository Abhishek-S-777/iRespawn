import 'package:cloud_firestore/cloud_firestore.dart';

// class OrderModel {
//   int totalAmount;
//
//   OrderModel(
//       {this.totalAmount
//       });
//
//   OrderModel.fromJson(Map<int, dynamic> json) {
//     totalAmount=json['totalAmount'];
//   }
//
//   Map<int, dynamic> toJson() {
//     final Map<int, dynamic> data = new Map<int, dynamic>();
//     data[totalAmount]=this.totalAmount;
//     return data;
//   }
// }
class OrderModel {
  var totalAmount;

  OrderModel(
      {this.totalAmount
      });

  OrderModel.fromJson(Map<String, dynamic> json) {
    totalAmount=json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalAmount']=this.totalAmount;
    return data;
  }
}

// class PublishedDate {
//   String date;
//
//   PublishedDate({this.date});
//
//   PublishedDate.fromJson(Map<String, dynamic> json) {
//     date = json['$date'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['$date'] = this.date;
//     return data;
//   }
// }
