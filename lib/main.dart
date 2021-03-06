import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_weatherapp/pages/home_page.dart';
import 'package:provider_weatherapp/providers/temp_settings_provider.dart';
import 'package:provider_weatherapp/providers/theme_provider.dart';
import 'package:provider_weatherapp/providers/weather_provider.dart';
import 'package:provider_weatherapp/repositories/weather_repository.dart';
import 'package:provider_weatherapp/services/weather_api_services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<WeatherRepository>(
          create: (context) {
            final WeatherApiServices weatherApiServices =
                WeatherApiServices(httpClient: http.Client());
            return WeatherRepository(weatherApiServices: weatherApiServices);
          },
        ),
        ChangeNotifierProvider<WeatherProvider>(
          create: (context) => WeatherProvider(
              weatherRepository: context.read<WeatherRepository>()),
        ),
        
        ChangeNotifierProvider<TempSettingsProvider>(
          create: (context) => TempSettingsProvider(),
        ),

        ChangeNotifierProxyProvider<WeatherProvider, ThemeProvider>(
          create: (context) => ThemeProvider(),
          update: (
            BuildContext context,
            WeatherProvider weatherProvider,
            ThemeProvider? themeProvider,
          ) =>
              themeProvider!..update(weatherProvider),
        ),
        
      ],
      builder: (context, _) => MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme:  context.watch<ThemeProvider>().state.appTheme == AppTheme.light
            ? ThemeData.light()
            : ThemeData.dark(),

        home: const HomePage(),
      ),
    );
  }
}