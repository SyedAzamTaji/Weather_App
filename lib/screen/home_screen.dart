import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/consts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  String _cityName = "London";

  TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getWeatherForCity(_cityName);
  }

  void _getWeatherForCity(String city) {
    _wf.currentWeatherByCityName(city).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _citySearchField(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
          _locationHeader(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.08),
          _dateTimeInfo(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
          _weatherIcon(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
          _currentTemp(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
          _extraInfo(),
        ],
      ),
    );
  }

  Widget _citySearchField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade600, Colors.teal.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 3)
        ],
      ),
      child: TextField(
        controller: _cityController,
        style: TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          hintText: "Enter City Name",
          hintStyle: TextStyle(color: Colors.black54),
          prefixIcon: Icon(Icons.search, color: Colors.black),
          border: InputBorder.none,
        ),
        onSubmitted: (city) {
          setState(() {
            _cityName = city;
            _getWeatherForCity(city);
          });
        },
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: TextStyle(
          fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm:a").format(now),
          style: TextStyle(fontSize: 40, color: Colors.black),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              "  ${DateFormat("d.m.y").format(now)}",
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    String iconCode = _weather?.weatherIcon ?? "01d";
    String imageUrl = "http://openweathermap.org/img/wn/$iconCode@4x.png";
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.25,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imageUrl), fit: BoxFit.contain),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: TextStyle(
          fontSize: 80, fontWeight: FontWeight.w600, color: Colors.black),
    );
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.12,
      width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade600, Colors.teal.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      padding: EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
