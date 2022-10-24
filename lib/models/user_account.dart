class UserAccount {
  String? email;

  UserAccount({
    this.email,
  });

  UserAccount.fromJson(Map<String, dynamic> json) {
    email = json['email'];
  }

  Map<String, dynamic> toJson() => {
        'email': email,
      };
}
