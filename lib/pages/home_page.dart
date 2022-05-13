import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_weatherapp/constants/constants.dart';
import 'package:provider_weatherapp/pages/search_page.dart';
import 'package:provider_weatherapp/pages/settings_page.dart';
import 'package:provider_weatherapp/providers/weather_provider.dart';
import 'package:provider_weatherapp/repositories/weather_repository.dart';
import 'package:http/http.dart' as http;
import 'package:provider_weatherapp/services/weather_api_services.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;
  late final WeatherProvider _weatherProv;

  @override
  void initState() {
    super.initState();
    _weatherProv = context.read<WeatherProvider>();
    _weatherProv.addListener(_registerListener);

    WeatherRepository(weatherApiServices: 
    WeatherApiServices(httpClient: http.Client())).fetchWeather('lahore');
    
  }

  @override
  void dispose() {
    _weatherProv.removeListener(_registerListener);
    super.dispose();
  }

  void _registerListener() {
    final WeatherState ws = context.read<WeatherProvider>().state;

    // if (ws.status == WeatherStatus.error) {
    //   errorDialog(context, ws.error.errMsg);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              _city = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SearchPage();
                }),
              );
              print('city: $_city');
              if (_city != null) {
                context.read<WeatherProvider>().fetchWeather(_city!);
              }
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SettingsPage();
                }),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: _showWeather(),
    );
  }

  String showTemperature(double temperature) {
    // final tempUnit = context.watch<TempSettingsProvider>().state.tempUnit;

    // if (tempUnit == TempUnit.fahrenheit) {
    //   return ((temperature * 9 / 5) + 32).toStringAsFixed(2) + '℉';
    // }

    return temperature.toStringAsFixed(2) + '℃';
  }

  Widget showIcon(String abbr) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.gif',
      image: 'https://${StringData.kHost}/static/img/weather/png/64/$abbr.png',
      width: 64,
      height: 64,
    );
  }

  Widget _showWeather() {
    final weatherState = context.watch<WeatherProvider>().state;

    if (weatherState.status == WeatherStatus.initial) {
      return Center(
        child: Text(
          'Select a city',
          style: TextStyle(fontSize: 20.0),
        ),
      );
    }

    if (weatherState.status == WeatherStatus.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (weatherState.status == WeatherStatus.error &&
        weatherState.weather.title == '') {
      return Center(
        child: Text(
          'Select a city',
          style: TextStyle(fontSize: 20.0),
        ),
      );
    }

    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 6),
        Text(
          weatherState.weather.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          TimeOfDay.fromDateTime(weatherState.weather.lastUpdated)
              .format(context),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.0),
        ),
        SizedBox(height: 60.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              showTemperature(weatherState.weather.theTemp),
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 20.0),
            Column(
              children: [
                Text(
                  showTemperature(weatherState.weather.maxTemp),
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  showTemperature(weatherState.weather.minTemp),
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 40.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(),
            showIcon(weatherState.weather.weatherStateAbbr),
            SizedBox(width: 20.0),
            Text(
              weatherState.weather.weatherStateName,
              style: TextStyle(fontSize: 32.0),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}