
import 'package:weatherapp/constants/api/api.dart';
import 'package:weatherapp/constants/api/constant.dart';

class NetworkCall {
  //weather
  Future<String> loadWeatherByCityName(String name) async {
    String apiName = ApiConstant.GET_WEATHER + '/weather?q=$name&appid=${ApiConstant.API_KEY}&units=metric';
    var api = Uri.parse(apiName);
    var response = await client.get(api);
    return response.body;
  }

  //weather-by-lat-lon
  Future<String> loadWeatherByLatLon(double lat, double lon) async {

    String apiName = ApiConstant.GET_WEATHER + '/weather?lat=$lat&lon=$lon&appid=${ApiConstant.API_KEY}&units=metric';
    var api = Uri.parse(apiName);
    var response = await client.get(api);
    return response.body;
  }
}
