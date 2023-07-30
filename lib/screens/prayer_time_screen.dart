import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_time.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  PrayerTime time = PrayerTime();
  bool _showsearchBar = false;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getPrayerTime();
    });
    getPrayerTime();
    super.initState();
  }

  Future<void> getPrayerTime({String? city = 'karachi'}) async {
    showDialog(
        // display the loading dialog as returning the CircularProgressIndicator()
        /// while while waiting for the API response.
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    http.Response response = await http
        .get(Uri.parse("https://dailyprayer.abdulrcs.repl.co/api/$city"));
    print(response.statusCode);
    print(response.body);

    setState(() {
      time = PrayerTime.fromJson(jsonDecode(response.body));
    });
    // dismisses the previously shown loading
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/bg.png",
                ),
                fit: BoxFit.cover)),
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _showsearchBar
                ? Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      children: [
                        Expanded(child: _showTextField()),
                        _showIconButton(),
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Text(
                          'Prayer Time',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 30),
                        ),
                      ),
                      _showIconButton(),
                    ],
                  ),
            const SizedBox(
              height: 80,
            ),
            Text(
              time.city == null ? "--/--/--" : "${time.city}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              time.city == null ? "--:--" : "${time.date}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Spacer(),
            _timeCard(
                "Fajr", time.city == null ? "--:--" : "${time.today?.fajr}"),
            _timeCard("Sunrise",
                time.city == null ? "--:--" : "${time.today?.sunrise}"),
            _timeCard(
                "Dhuhr", time.city == null ? "--:--" : "${time.today?.dhuhr}"),
            _timeCard(
                "Asr", time.city == null ? "--:--" : "${time.today?.asr}"),
            _timeCard("Maghrib",
                time.city == null ? "--:--" : "${time.today?.maghrib}"),
            _timeCard(
                "Isha", time.city == null ? "--:--" : "${time.today?.ishaA}"),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }

  Widget _timeCard(String name, String time) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black.withOpacity(0.4)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            const Icon(
              Icons.timer_outlined,
              color: Colors.white,
              size: 25,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        Text(
          time,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ]),
    );
  }

  Widget _showTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextField(
          cursorColor: Colors.deepPurple,
          autofocus: true,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
          decoration: InputDecoration(
            fillColor: Colors.grey.withOpacity(0.2),
            hintText: 'Search any city name',
            hintStyle: TextStyle(
              fontSize: 17,
              color: Colors.white60.withOpacity(0.3),
            ),
            border: InputBorder.none,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white60,
            ),
          ),
          onSubmitted: (value) {
            _showsearchBar = false;
            getPrayerTime(city: value.toLowerCase());
          },
        ),
      ),
    );
  }

  Widget _showIconButton() {
    return IconButton(
        onPressed: () {
          setState(() {
            _showsearchBar = !_showsearchBar;
          });
        },
        icon: _showsearchBar
            ? Icon(
                Icons.cancel,
                color: Theme.of(context).iconTheme.color,
              )
            : Icon(
                Icons.search_rounded,
                color: Theme.of(context).iconTheme.color,
                size: 30,
              ));
  }
}
