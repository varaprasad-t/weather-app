import 'package:flutter/material.dart';

class WeatherDisplay extends StatelessWidget {
  final String name;
  final String temperature;
  final String weather;
  final String iconcode;
  final List<Map<String, String>> forecasts;
  final String humidity;
  final String pressure;
  final String wind;

  const WeatherDisplay({
    super.key,
    required this.name,
    required this.temperature,
    required this.weather,
    required this.iconcode,
    required this.forecasts,
    required this.humidity,
    required this.pressure,
    required this.wind,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              color: const Color.fromARGB(255, 122, 33, 26),
            ),
            Text('$name', style: const TextStyle(fontSize: 20)),
          ],
        ),

        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            width: double.infinity,
            child: Card(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.blueGrey[500]
                  : const Color.fromARGB(255, 205, 220, 247),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      temperature,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                  iconcode.isNotEmpty
                      ? Image.network(
                          'https://openweathermap.org/img/wn/${iconcode}@2x.png',
                          width: 200,
                          height: 100,
                        )
                      : CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(weather, style: const TextStyle(fontSize: 21)),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Weather forecast',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: forecasts.map((forecast) {
                return SizedBox(
                  height: 130,
                  width: 120,
                  child: Card(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.blueGrey[700]
                        : const Color.fromARGB(255, 208, 221, 246),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(forecast['time'] ?? ''),
                        ),
                        forecast['icon'] != null
                            ? Image.network(
                                'https://openweathermap.org/img/wn/${forecast['icon']}@2x.png',
                                width: 50,
                                height: 50,
                              )
                            : const Icon(Icons.cloud),
                        Text('${forecast['temp']}°C'),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
          child: Padding(
            padding: EdgeInsets.zero,
            child: Text(
              'Additional Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Icon(Icons.water_drop, size: 40),
                  const SizedBox(height: 4),
                  const Text('Humidity'),
                  Text(
                    humidity,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.air, size: 40),
                  const SizedBox(height: 4),
                  const Text('Wind Speed'),
                  Text(
                    wind,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.umbrella, size: 40),
                  const SizedBox(height: 4),
                  const Text('Pressure'),
                  Text(
                    pressure,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
