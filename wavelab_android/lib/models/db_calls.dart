import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/depth_data.dart';
import '../models/target_data.dart';

class dbCalls{
  static const ROOT = "http://192.168.1.19/WavelabDB/get_depth.php";
  static const _GET_CUR_DEPTH_DWB = "GET_CUR_DEPTH_DWB";
  static const _GET_CUR_DEPTH_LWF = "GET_CUR_DEPTH_LWF";
  static const _GET_T_DEPTH_DWB = "GET_T_DEPTH_DWB";
  static const _GET_T_DEPTH_LWF = "GET_T_DEPTH_LWF";

  static List<depthData> parseDepth(String responseBody){
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<depthData>((json) => depthData.fromJson(json)).toList();
  }

  static List<targetData> parseTarget(String responseBody){
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<targetData>((json) => targetData.fromJson(json)).toList();
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
}