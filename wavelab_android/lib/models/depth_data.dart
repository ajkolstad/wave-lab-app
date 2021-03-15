// Depth data class used to when mapping data from sql call to get data from the depth table
class depthData{
  String depth;
  String depth_flume_name;
  String dDate;

  depthData({this.depth, this.depth_flume_name, this.dDate});

  factory depthData.fromJson(Map<String, dynamic> json){
    return depthData(
      dDate: json['Ddate'] as String,
      depth: json['Depth'] as String,
      depth_flume_name: json['Depth_Flume_Name'] as String,
    );
  }
}