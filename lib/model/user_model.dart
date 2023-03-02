// class UserModel {
//   int? id;
//   String? name;
//   String? address;
//   String? email;
//   int? rollId;
//   String? profilePic;

//   UserModel({
//     this.address,
//     this.email,
//     this.id,
//     this.name,
//     this.rollId,
//     this.profilePic,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       address: json['address'] as String?,
//       email: json['email'] as String?,
//       id: json['id'],
//       name: json['name'],
//       rollId: int.parse(json['role_id'].toString()),
//       profilePic: json['photo'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "address": address,
//       "email": email,
//       "id": id,
//       "name": name,
//       "role_id": rollId,
//       "photo": profilePic,
//     };
//   }
// }

// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    this.name,
    this.roleId,
    this.email,
    this.address,
    this.dob,
    this.father,
    this.doj,
    this.photo,
    this.resume,
    this.tradeLicense,
    this.driversLicense,
    this.sinNo,
    this.mobile,
  });

  int? id;
  String? name;
  int? roleId;
  String? email;
  String? address;
  String? dob;
  String? father;
  String? doj;
  String? photo;
  String? resume;
  String? tradeLicense;
  String? driversLicense;
  String? mobile;
  String? sinNo;
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        address: json["address"],
        dob: json["dob"],
        father: json["father"],
        doj: json["doj"],
        photo: json["photo"],
        mobile: json["mobile"].toString(),
        resume: json["resume"],
        tradeLicense: json["trade_license"],
        driversLicense: json["drivers_license"],
        sinNo: json["sin_no"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role_id": roleId,
        "email": email,
        "address": address,
        "dob": dob,
        "father": father,
        "doj": doj,
        "photo": photo,
        "resume": resume,
        "trade_license": tradeLicense,
        "drivers_license": driversLicense,
        "sin_no": sinNo,
      };
}
