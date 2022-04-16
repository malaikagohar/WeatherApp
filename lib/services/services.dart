import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherapp/model/weather_details.dart';
import 'package:weatherapp/screens/errorscreen.dart';

Future<WeatherDetails?> getCityWeather([String? city]) async {
  final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=b8a72d0d52ebd260a32513d92f89a869'));

  if (response.statusCode == 404) {
    error = "City Not Found!";
    return DefaultWeather();
  }
  if (response.statusCode == 200) {
    error = "";
    return WeatherDetails.fromJson(jsonDecode(response.body));
  } else {
    print("Throw block");
    return DefaultWeather();
  }
}

Future<WeatherDetails> DefaultWeather() async {
  final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=Karachi&appid=b8a72d0d52ebd260a32513d92f89a869'));

  if (response.statusCode == 200) {
    return WeatherDetails.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to add user");
  }
}
