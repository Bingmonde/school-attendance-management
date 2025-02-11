class CegepUser {
  String email;
  String imageUrl;
  int matricule;
  String userFamilyName;
  String userName;
  String role;

  CegepUser({
    required this.email,
    required this.imageUrl,
    required this.matricule,
    required this.userFamilyName,
    required this.userName,
    required this.role,
  });

  factory CegepUser.fromJson(Map<String, dynamic> json) {
    return CegepUser(
      email: json['email'],
      imageUrl: json['image_url'],
      matricule: json['matricule'],
      userFamilyName: json['user_familyname'],
      userName: json['user_name'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'image_url': imageUrl,
      'matricule': matricule,
      'user_familyname': userFamilyName,
      'user_name': userName,
      'role': role,
    };
  }
}

class Prof {
  String profId;
  String profName;
  String profFamilyName;

  Prof({
    required this.profId,
    required this.profName,
    required this.profFamilyName,
  });
}

class Etudiant {
  String etudiantId;
  String etudiantName;
  String etudiantFamilyName;

  Etudiant({
    required this.etudiantId,
    required this.etudiantName,
    required this.etudiantFamilyName,
  }); 


}
