/**************************************************************
 * Target data class used to when mapping data from sql call to get data from the target_depth table
 *************************************************************/
class targetData{
  String Tdepth;
  String target_flume_name;
  String tDate;
  String username;
  String isComplete;

  targetData({this.Tdepth, this.target_flume_name, this.tDate, this.username, this.isComplete});

  factory targetData.fromJson(Map<String, dynamic> json){
    return targetData(
      Tdepth: json['Tdepth'] as String,
      target_flume_name: json['Target_Flume_Name'] as String,
      tDate: json['Tdate'] as String,
      username: json['Username'] as String,
      isComplete: json['isComplete'] as String
    );
  }
}