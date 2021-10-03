import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/models/weather.dart';
import 'package:weatherapp/models/weather_brain.dart';
import 'package:weatherapp/utilities/constants.dart';
import 'package:weatherapp/view_model/weather_controller.dart';

import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherController _weatherController;
  WeatherModel _weatherModel;
  bool _isLoadingForLocation;
  bool _isLoadingWeather;
  WeatherAPi _weather;

  @override
  void initState() {
    super.initState();
    _isLoadingForLocation = true;
    _isLoadingWeather = true;
    _weatherController = WeatherController();
    _weatherModel = WeatherModel();
    getLocation();
  }

  void _getWeatherByLatLon(double lat, double lon) async {
    try {
      var weather = await _weatherController.getWeatherByLatLong(lat, lon);
      setState(() {
        _weather = weather;
        _isLoadingWeather = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        _isLoadingWeather = false;
      });
    }
  }

  void _getWeatherCityName(String name) async {
    try {
      var weather = await _weatherController.getWeatherByCityName(name);
      setState(() {
        _weather = weather;
        _isLoadingWeather = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        _isLoadingWeather = false;
      });
    }
  }

  void getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      setState(() {
        _isLoadingForLocation = false;
      });

      if (position.latitude != null && position.longitude != null) {
        _getWeatherByLatLon(position.latitude, position.longitude);
      }
      print(position.latitude);
      print(position.longitude);
    } catch (e) {
      _isLoadingForLocation = false;
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoadingForLocation == false &&
              _weather != null &&
              _isLoadingWeather == false
          ? Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/location_background.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.8), BlendMode.dstATop),
                ),
              ),
              constraints: BoxConstraints.expand(),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            print('click');
                            setState(() {
                              _isLoadingForLocation = true;
                              _isLoadingWeather = true;
                            });
                            getLocation();
                          },
                          child: Icon(
                            Icons.near_me,
                            size: 50.0,
                          ),
                        ),
                        FlatButton(
                          onPressed: () async {
                            String cityName = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CityScreen();
                            }));
                            if (cityName != null) {
                              setState(() {
                                _isLoadingWeather = true;
                              });
                              _getWeatherCityName(cityName);
                            }
                          },
                          child: Icon(
                            Icons.location_city,
                            size: 50.0,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _weather.main.temp.round().toString(),
                            textAlign: TextAlign.center,
                            style: kTempTextStyle,
                          ),
                          Text(
                            _weatherModel
                                .getWeatherIcon(_weather.weather[0].id),
                            style: kConditionTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Text(
                        _weatherModel.getMessage(_weather.main.temp.round()) +
                            '\n  ${_weather.name}',
                        textAlign: TextAlign.center,
                        style: kMessageTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
    );
  }
}
