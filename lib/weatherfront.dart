import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'buildweather.dart';

class Weatherfront extends StatefulWidget {
  final void Function(String)? onThemeChanged;
  const Weatherfront({super.key, this.onThemeChanged});
  @override
  State<Weatherfront> createState() => _Weatherfront();
}

class _Weatherfront extends State<Weatherfront> {
  bool _isLoading = false;
  ThemeMode _themeMode = ThemeMode.light;
  TextEditingController _cityController = TextEditingController();
  String _temperature = '';
  String _weather = '';
  String city = '';
  String? _selectedvalue = 'light';
  String _humidity = '';
  String _pressure = '';
  String _wind = '';
  String _iconcode = '';
  List<Map<String, String>> _nextForecasts = [];
  String _name = '';

  Future<void> fetchWeather(String city) async {
    debugPrint('start');
    setState(() {
      _isLoading = true;
    });
    final apikey = '72932122188c5a423cee462e4c37f91d';
    final urlc = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apikey&units=metric',
    );
    final urlf = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apikey&units=metric',
    );
    debugPrint('parsed');
    try {
      final response = await http.get(urlc);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _temperature = '${data['main']['temp']} °C';
          _weather = data['weather'][0]['description'];
          _humidity = '${data['main']['humidity']}%';
          _pressure = '${data['main']['pressure']} hPa';
          _wind = '${data['wind']['speed']} m/s';
          _iconcode = data['weather'][0]['icon'];
          _name = data['name'];
        });
      } else {
        setState(() {
          _temperature = '';
          _weather = 'Failed to load weather';
        });
      }
    } catch (e) {
      setState(() {
        _temperature = '';
        _weather = 'error occured:$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    try {
      final responsef = await http.get(urlf);
      if (responsef.statusCode == 200) {
        final dataf = jsonDecode(responsef.body);
        final forecastList = dataf['list'];
        setState(() {
          _nextForecasts = [];

          final now = DateTime.now();

          final filteredList = forecastList
              .where((result) {
                final forecastTime = DateTime.parse(result['dt_txt']);
                return forecastTime.isAfter(now);
              })
              .take(5);

          for (final result in filteredList) {
            final time = result['dt_txt'];
            final temp = result['main']['temp'].toString();
            final iconcode = result['weather'][0]['icon'];
            _nextForecasts.add({'time': time, 'temp': temp, 'icon': iconcode});
          }
        });
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    _cityController.addListener(() {
      // Scroll cursor into view on every text change
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final value = _cityController.text;
        _cityController.selection = TextSelection.fromPosition(
          TextPosition(offset: value.length),
        );
      });
    });
    super.initState();
    fetchWeather('hyderabad');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.blueGrey[900]
          : Color.fromARGB(255, 151, 169, 215),
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.blueGrey[900]
            : Color.fromARGB(255, 151, 169, 215),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedvalue,
              items: const [
                DropdownMenuItem(value: 'light', child: Text('☀️')),
                DropdownMenuItem(value: 'dark', child: Icon(Icons.dark_mode)),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedvalue = value!;
                });
                widget.onThemeChanged?.call(value!);
              },
              icon: const SizedBox.shrink(), // Removes the default arrow icon
              selectedItemBuilder: (context) => const [
                Icon(Icons.wb_sunny, color: Colors.amber),
                Icon(Icons.nightlight_round, color: Colors.indigo),
              ],
              dropdownColor: Colors.white,
              isDense: true,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Material(
              shape: CircleBorder(),
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.blueGrey,

                customBorder: CircleBorder(),
                onTap: () {
                  final city = _cityController.text.trim();
                  if (city.isNotEmpty) {
                    fetchWeather(city);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.refresh, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
        title: Center(
          child: Text(
            'Weather App',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: _isLoading
              ? Padding(
                  padding: const EdgeInsets.only(top: 300),
                  child: const CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(width: 80),
                        SizedBox(
                          width: 200,
                          height: 40,
                          child: TextField(
                            controller: _cityController,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            scrollPhysics:
                                const BouncingScrollPhysics(), // enables horizontal scroll
                            textAlign: TextAlign.left,
                            enableInteractiveSelection: false,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'Enter a city name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              isDense: true, // makes it compact
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            style: const TextStyle(
                              overflow: TextOverflow.visible, // just to be safe
                            ),
                            // this makes sure text scrolls when long
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            debugPrint('pressed');
                            FocusScope.of(context).unfocus();
                            if (_cityController.text.trim().isNotEmpty) {
                              fetchWeather(_cityController.text.trim());
                            }
                          },
                          child: Text('search'),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    if (_temperature.isEmpty && _weather.isEmpty)
                      WeatherDisplay(
                        name: _name,
                        temperature: _temperature,
                        weather: _weather,
                        iconcode: _iconcode,
                        forecasts: _nextForecasts,
                        humidity: _humidity,
                        pressure: _pressure,
                        wind: _wind,
                      ),

                    if (_temperature.isNotEmpty && _weather.isNotEmpty)
                      WeatherDisplay(
                        name: _name,
                        temperature: _temperature,
                        weather: _weather,
                        iconcode: _iconcode,
                        forecasts: _nextForecasts,
                        humidity: _humidity,
                        pressure: _pressure,
                        wind: _wind,
                      ),
                    if (_weather == 'Failed to load weather')
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 60,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "No results found.\nPlease check the city name 🌍❓",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_weather.startsWith('error occured'))
                      SizedBox(
                        height:
                            MediaQuery.of(context).size.height *
                            0.5, // adjust if needed
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.wifi_off,
                                size: 80,
                                color: Colors.black,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Network error!\nPlease check your internet connection.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
