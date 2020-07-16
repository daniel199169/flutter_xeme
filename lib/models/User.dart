enum Gender { MALE, FEMALE }

String genderToString(Gender gender) {
  if (gender == Gender.FEMALE) return 'female';
  return 'male';
}

Gender genderFromString(String genderStr) {
  if (genderStr == 'female') return Gender.FEMALE;
  return Gender.MALE;
}

class User {
  String uid;
  String tellusname;
  String email;
  String image;
  Gender gender;
  String birthday;
  String description;
  String fullname;
  String website;
  String otherlink;
  String professional;
  String permission;
  // String pushToken;

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'tellusname': tellusname,
    'email': email,
    'image': image,
    'gender': genderToString(gender),
    'birthday': birthday,
    'description': description,
    'fullname': fullname,
    'website': website,
    'otherlink': otherlink,
    'professional': professional,
    'permission': permission,
    // 'pushToken': pushToken,
  };

  User(
      this.uid,
      this.tellusname,
      this.email,
      this.image,
      this.gender,
      this.birthday,
      this.description,
      this.fullname,
      this.website,
      this.otherlink,
      this.professional,
      this.permission,
      // this.pushToken
      );

  User._internalFromJson(Map jsonMap)
      : uid = jsonMap['uid']?.toString() ?? '',
        tellusname = jsonMap['tellusname']?.toString() ?? '',
        email = jsonMap['email']?.toString() ?? '',
        image = jsonMap['image']?.toString() ?? '',
        gender = genderFromString(jsonMap['gender']?.toString() ?? 'male'),
        birthday = jsonMap['birthday']?.toString() ?? '',
        description = jsonMap['description']?.toString() ?? '',
        fullname = jsonMap['fullname']?.toString() ?? '',
        website = jsonMap['website']?.toString() ?? '',
        otherlink = jsonMap['otherlink']?.toString() ?? '',
        professional = jsonMap['professional'].toString() ?? '',
        permission = jsonMap['permission'].toString() ?? '';
        // pushToken = jsonMap['pushToken'].toString() ?? '';

  factory User.fromJson(Map jsonMap) => User._internalFromJson(jsonMap);
}
