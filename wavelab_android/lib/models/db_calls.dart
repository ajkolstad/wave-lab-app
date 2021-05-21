/***********************************************************
 * This file maps all of the data that will be used in the sql query call and
 * sends the maped information to the get_depth.php file that communicates with
 * the database.
 **********************************************************/
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'depth_data.dart';
import 'target_data.dart';
import 'user_data.dart';

class dbCalls{
  static const ROOT = "http://192.168.1.19/WavelabDB/get_depth.php"; // The address in the database where the php file is stored

  // Calls for the php file to use
  static const _GET_CUR_DEPTH_DWB = "GET_CUR_DEPTH_DWB";
  static const _GET_CUR_DEPTH_LWF = "GET_CUR_DEPTH_LWF";
  static const _GET_ALL_DEPTH_DWB = "GET_ALL_DEPTH_DWB";
  static const _GET_ALL_DEPTH_LWF = "GET_ALL_DEPTH_LWF";
  static const _GET_T_DEPTH_DWB = "GET_T_DEPTH_DWB";
  static const _GET_T_DEPTH_LWF = "GET_T_DEPTH_LWF";
  static const _GET_PREV_T_DWB = "GET_PREV_T_DWB";
  static const _GET_PREV_T_LWF = "GET_PREV_T_LWF";
  static const _ADD_T_DEPTH = "ADD_T_DEPTH";
  static const _STOP_FILLING = "STOP_FILLING";
  static const _LOGIN_USER = "LOGIN_USER";

  // map the depth data grabbed from the database
  static List<depthData> parseDepth(String responseBody){
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<depthData>((json) => depthData.fromJson(json)).toList();
  }

  // Map the target data grabbed from the database
  static List<targetData> parseTarget(String responseBody){
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<targetData>((json) => targetData.fromJson(json)).toList();
  }

  // Map the user data grabbed from the database
  static List<userData> parseUser(String responseBody){
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<userData>((json) => userData.fromJson(json)).toList();
  }

  // Call to grab and map the most recent depth in the DWB
  static Future<List<depthData>> getCurDepthDwb() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = _GET_CUR_DEPTH_DWB;
      final response = await http.post(ROOT, body: map); // Calls the php file
      print('Get Depth DWB Response: ${response.body}');
      if (200 == response.statusCode) {
        List<depthData> list = parseDepth(response.body); // Maps data grabbed
        return list;
      }
      else {
        return List<depthData>();
      }
    } catch (e){
      print("error: ${e}");
      return List<depthData>();
    }
  }

  // Call to grab and map the most recent depth in the LWF
  static Future<List<depthData>> getCurDepthLwf() async {
    try{
      print("in again");
      var map = Map<String, dynamic>();
      map['action'] = _GET_CUR_DEPTH_LWF;
      final response = await http.post(ROOT, body: map); // Calls php file
      print('Get Depth LWF Response: ${response.body}');
      if (200 == response.statusCode) {
        List<depthData> list = parseDepth(response.body); // Maps data grabbed
        return list;
      }
      else {
        return List<depthData>();
      }
    } catch (e){
      print("error: ${e}");
      return List<depthData>();
    }
  }

  // Gets all of the depth data for the graph in DWB
  static Future<List<depthData>> getAllDepthDwb() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_DEPTH_DWB;
      final response = await http.post(ROOT, body: map); // Calls php file
      print('Get Depth DWB Response: ${response.body}');
      if (200 == response.statusCode) {
        List<depthData> list = parseDepth(response.body); // Maps data grabbed
        return list;
      }
      else {
        return List<depthData>();
      }
    } catch (e){
      print("error: ${e}");
      return List<depthData>();
    }
  }

  // Gets all of the depth data for the graph in LWF
  static Future<List<depthData>> getAllDepthLwf() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_DEPTH_LWF;
      final response = await http.post(ROOT, body: map); // Calls php file
      print('Get Depth LWF Response: ${response.body}');
      if (200 == response.statusCode) {
        List<depthData> list = parseDepth(response.body); // Maps data grabbed
        return list;
      }
      else {
        return List<depthData>();
      }
    } catch (e){
      print("error: ${e}");
      return List<depthData>();
    }
  }

  // Gets the current target data in DWB from the database
  static Future<List<targetData>> getTDepthDwb() async {
    try{
      var map = Map<String, dynamic>();
      DateTime now = new DateTime.now();
      map['action'] = _GET_T_DEPTH_DWB;
      map['curDate'] = now.toString();
      final response = await http.post(ROOT, body: map); // Calls php file
      print('Get Target DWB Response: ${response.body}');
      if (200 == response.statusCode) {
        List<targetData> list = parseTarget(response.body); // Maps data grabbed
        return list;
      }
      else {
        return List<targetData>();
      }
    } catch (e){
      print("error: ${e}");
      return List<targetData>();
    }
  }

  // Gets the current target data in LWF from the database
  static Future<List<targetData>> getTDepthLwf() async {
    try{
      var map = Map<String, dynamic>();
      DateTime now = new DateTime.now();
      map['action'] = _GET_T_DEPTH_LWF;
      map['curDate'] = now.toString();
      final response = await http.post(ROOT, body: map); // Calls php file
      print('Get Target LWF Response: ${response.body}');
      if (200 == response.statusCode) {
        List<targetData> list = parseTarget(response.body); // Maps data grabbed
        return list;
      }
      else {
        return List<targetData>();
      }
    } catch (e){
      print("error: ${e}");
      return List<targetData>();
    }
  }

  // Grab the previous target depth that was completed in DWB from the database
  static Future<List<targetData>> getPreviousTargetDwb() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = _GET_PREV_T_DWB;
      final response = await http.post(ROOT, body: map); // Calls php file
      print('Get Previous Target DWB Response: ${response.body}');
      if (200 == response.statusCode) {
        List<targetData> list = parseTarget(response.body); // Maps data grabbed
        return list;
      }
      else {
        return List<targetData>();
      }
    } catch (e){
      print("error: ${e}");
      return List<targetData>();
    }
  }

  // Grab the previous target depth that was completed in LWF from the database
  static Future<List<targetData>> getPreviousTargetLwf() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = _GET_PREV_T_LWF;
      final response = await http.post(ROOT, body: map); // Calls php file
      print('Get Previous Target LWF Response: ${response.body}');
      if (200 == response.statusCode) {
        List<targetData> list = parseTarget(response.body); // Maps data grabbed
        return list;
      }
      else {
        return List<targetData>();
      }
    } catch (e){
      print("error: ${e}");
      return List<targetData>();
    }
  }

  // Adds a target depth to the database
  static Future<String> addTarget(double Tdepth, int fName, DateTime Tdate, String uName, int isComplete) async{
    try{
      var map = Map<String, dynamic>();
      map['action'] = _ADD_T_DEPTH;
      map['Tdepth'] = Tdepth.toString();
      map['fName'] = fName.toString();
      map['Tdate'] = Tdate.toString();
      map['uName'] = uName.toString();
      map['isComplete'] = isComplete.toString();
      final response = await http.post(ROOT, body: map); // Calls php file
      print('addTarget Response: ${response.body}');
      if(200 == response.statusCode) {
        return response.body;
      }
      else {
        return "error";
      }
    }
    catch(e) {
      print("Error: ${e}");
      return "error";
    }
  }

  // stops filling process to the database
  static Future<String> stopFilling(int flume_name) async{
    try{
      var map = Map<String, dynamic>();
      DateTime now = new DateTime.now();
      map['action'] = _STOP_FILLING;
      map['fName'] = flume_name.toString();
      map['curDate'] = now.toString();
      final response = await http.post(ROOT, body: map); // Calls php file
      print('stopFilling Response: ${response.body}');
      if(200 == response.statusCode) {
        return response.body;
      }
      else {
        return "error";
      }
    }
    catch(e) {
      print("Error: ${e}");
      return "error";
    }
  }

  // Grabs user from the database if the user information matches what the user entered
  static Future<List<userData>> loginUser(String username, String password) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _LOGIN_USER;
      map['username'] = username;
      map['password'] = password;
      final response = await http.post(ROOT, body: map); // Calls php file
      print('LoginUser Response: ${response.body}');
      if (200 == response.statusCode) {
        List<userData> list = parseUser(response.body); // Maps data grabbed
        return list;
      }
      else {
        return List<userData>();      }
    }
    catch (e) {
      print("Error: ${e}");
      return List<userData>();    }
  }
}