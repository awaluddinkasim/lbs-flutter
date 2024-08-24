import 'package:dio/dio.dart';

class DirectionService {
  static const String _baseUrl = "https://api.openrouteservice.org/v2/directions/driving-car";
  static const String _apiKey = "5b3ce3597851110001cf624860616935406341a196fc449bf2374dc8";

  static Future<List> getDirection(String startPoint, String endPoint) async {
    Dio dio = Dio();
    final response = await dio.get("$_baseUrl?&api_key=$_apiKey&start=$startPoint&end=$endPoint");

    return response.data['features'][0]['geometry']['coordinates'];
  }
}
