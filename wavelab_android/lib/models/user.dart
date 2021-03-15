// User class holding name and username when user signs into app
class User{
  String Name;
  String Username;

  // Set User class object when creating the new User class object
  User(String initName, String initUser) {
    this.Name = initName;
    this.Username = initUser;
  }
}