// User data class used to when mapping data from sql call to get data from the user table
class userData{
  String Name;
  String Username;
  String Password;

  userData({this.Name, this.Username, this.Password});

  factory userData.fromJson(Map<String, dynamic> json){
    return userData(
        Name: json['Name'] as String,
        Username: json['Username'] as String,
        Password: json['Password'] as String,
    );
  }
}