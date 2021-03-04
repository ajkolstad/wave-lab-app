class userData{
  String Name;
  String Username;
  String Password;
  /*User(String initName, String initUser, ) {
    this.Name = initName;
    this.Username = initUser;
  }*/
  userData({this.Name, this.Username, this.Password});

  factory userData.fromJson(Map<String, dynamic> json){
    return userData(
        Name: json['Name'] as String,
        Username: json['Username'] as String,
        Password: json['Password'] as String,
    );
  }
}