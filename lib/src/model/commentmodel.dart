import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String commentID;
  String userName;
  String userProfilePic;
  String userComment;


  CommentModel(
      {this.commentID,
        this.userName,
        this.userProfilePic,
        this.userComment,

      });

  CommentModel.fromJson(Map<String, dynamic> json) {
    commentID=json['commentID'];
    userName = json['userName'];
    userProfilePic = json['profilePic'];
    userComment = json['comment'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentID']=this.commentID;
    data['userName'] = this.userName;
    data['profilePic'] = this.userProfilePic;
    data['comment'] = this.userComment;

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
