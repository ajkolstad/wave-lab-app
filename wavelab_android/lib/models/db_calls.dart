import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'depth_data.dart';
import 'target_data.dart';
import 'user_data.dart';

class dbCalls{
  static const ROOT = "http://192.168.1.28/WavelabDB/get_depth.php";
  static const _GET_CUR_DEPTH_DWB = "GET_CUR_DEPTH_DWB";
  static const _GET_CUR_DEPTH_LWF = "GET_CUR_DEPTH_LWF";
  static const _GET_ALL_DEPTH_DWB = "GET_ALL_DEPTH_DWB";
  static const _GET_ALL_DEPTH_LWF = "GET_ALL_DEPTH_LWF";
  static const _GET_T_DEPTH_DWB = "GET_T_DEPTH_DWB";
  static const _GET_T_DEPTH_LWF = "GET_T_DEPTH_LWF";
  static const _GET_PREV_T_DWB = "GET_PREV_T_DWB";
  static const _GET_PREV_T_LWF = "GET_PREV_T_LWF";
  static const _ADD_T_DEPTH = "ADD_T_DEPTH";
  static const _LOGIN_USER = "LOGIN_USER";

  static List<depthData> parseDepth(String responseBody){
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<depthData>((json) => depthData.fromJson(json)).toList();
  }

  static List<targetData> parseTarget(String responseBody){
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<targetData>((json) => targetData.fromJson(json)).toList();
  }

  static List<userData> parseUser(String responseBody){
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<userData>((json) => userData.fromJson(json)).toList();
  }

  static Future<List<depthData>> getCurDepthDwb() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = _GET_CUR_DEPTH_DWB;
      final response = await http.post(ROOT, body: map);
      print('Get Depth DWB Response: ${response.body}');
      if (200 == response.statusCode) {
        List<depthData> list = parseDepth(response.body);
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

  static Future<List<depthData>> getCurDepthLwf() async {
    try{
      print("in again");
      var map = Map<String, dynamic>();
      map['action'] = _GET_CUR_DEPTH_LWF;
      final response = await http.post(ROOT, body: map);
      print('Get Depth LWF Response: ${response.body}');
      if (200 == response.statusCode) {
        List<depthData> list = parseDepth(response.body);
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

  static Future<List<depthData>> getAllDepthDwb() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_DEPTH_DWB;
      final response = await http.post(ROOT, body: map);
      print('Get Depth DWB Response: ${response.body}');
      if (200 == response.statusCode) {
        List<depthData> list = parseDepth(response.body);
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

  static Future<List<depthData>> getAllDepthLwf() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_DEPTH_LWF;
      final response = await http.post(ROOT, body: map);
      print('Get Depth LWF Response: ${response.body}');
      if (200 == response.statusCode) {
        List<depthData> list = parseDepth(response.body);
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

  static Future<List<targetData>> getTDepthDwb() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = _GET_T_DEPTH_DWB;
      final response = await http.post(ROOT, body: map);
      print('Get Target DWB Response: ${response.body}');
      if (200 == response.statusCode) {
        List<targetData> list = parseTarget(response.body);
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

  static Future<List<targetData>> getTDepthLwf() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = _GET_T_DEPTH_LWF;
      final response = await http.post(ROOT, body: map);
      print('Get Target LWF Response: ${response.body}');
      if (200 == response.statusCode) {
        List<targetData> list = parseTarget(response.body);
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

  static Future<List<targetData>> getPreviousTargetDwb() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = _GET_PREV_T_DWB;
      final response = await http.post(ROOT, body: map);
      print('Get Previous Target DWB Response: ${response.body}');
      if (200 == response.statusCode) {
        List<targetData> list = parseTarget(response.body);
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

  static Future<List<targetData>> getPreviousTargetLwf() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = _GET_PREV_T_LWF;
      final response = await http.post(ROOT, body: map);
      print('Get Previous Target LWF Response: ${response.body}');
      if (200 == response.statusCode) {
        List<targetData> list = parseTarget(response.body);
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

  static Future<String> addTarget(double Tdepth, int fName, DateTime Tdate, String uName, int isComplete) async{
    try{
      var map = Map<String, dynamic>();
      map['action'] = _ADD_T_DEPTH;
      map['Tdepth'] = Tdepth.toString();
      map['fName'] = fName.toString();
      map['Tdate'] = Tdate.toString();
      map['uName'] = uName.toString();
      map['isComplete'] = isComplete.toString();
      final response = await http.post(ROOT, body: map);
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

  static Future<List<userData>> loginUser(String username, String password) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _LOGIN_USER;
      map['username'] = username;
      map['password'] = password;
      final response = await http.post(ROOT, body: map);
      print('LoginUser Response: ${response.body}');
      if (200 == response.statusCode) {
        List<userData> list = parseUser(response.body);
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