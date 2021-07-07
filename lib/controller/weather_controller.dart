import 'dart:convert';

import 'package:weatherapp/constants/api/constant.dart';
import 'package:weatherapp/models/weather.dart';



class WeatherController {
  Future<WeatherAPi> getWeatherByCityName(String name) async {
    var response = await networkCall.loadWeatherByCityName(name);
    return WeatherAPi.fromJson(jsonDecode(response));
  }

  Future<WeatherAPi> getWeatherByLatLong(double lat, double lon) async {
    var response = await networkCall.loadWeatherByLatLon(lat,lon);
    return WeatherAPi.fromJson(jsonDecode(response));
  }
}