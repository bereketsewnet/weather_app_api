import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app_api/services/weather_service.dart';

import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('e934e4ad0d8e5e1818d3a2aa7d39f676');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get Weather for city

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  // weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null)
      return 'assets/weather3.json'; // default to sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/weather4.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/weather2.json';
      case 'thunderstorm':
        return 'assets/weather1.json';
      case 'clear':
        return 'assets/weather3.json';
      default:
        return 'assets/weather3.json';
    }
  }

  // init state
  @override
  void initState() {
    _fetchWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city Name
            const Icon(
              Icons.location_pin,
              color: Colors.redAccent,
              size: 25,
            ),
            Text(
              _weather?.cityName ?? 'loading city...',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),

            // animation
            SizedBox(
              height: 300,
              child: Lottie.asset(
                getWeatherAnimation(
                  _weather?.mainCondition,
                ),
              ),
            ),

            // Temperature
            Text(
              '${_weather?.temperature.round()} \u00B0C',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            // weather condition
            Text(
              _weather?.mainCondition ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
