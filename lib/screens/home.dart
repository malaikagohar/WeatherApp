import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/model/weather_details.dart';
import 'package:weatherapp/services/services.dart';
import 'package:weatherapp/screens/errorscreen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? city = "Karachi";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){ 
        FocusManager.instance.primaryFocus?.unfocus();
       
        },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<WeatherDetails?>(
            future: getCityWeather(city),
            builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              }
              if (asyncSnapshot.hasError) {
  
                print(asyncSnapshot.error);
                 return Error();
                
              } else {
                List<List<String>> items = [
                  ["Wind", "${asyncSnapshot.data.wind.speed}", "m/s"],
                  ["Humidity", "${asyncSnapshot.data.main.humidity}", "%"],
                  ["Pressure", "${asyncSnapshot.data.main.pressure}", "hPA"]
                ];

                DateTime tz = DateTime.now().add(Duration(
                    seconds: asyncSnapshot.data.timezone! -
                        DateTime.now().timeZoneOffset.inSeconds));

                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/${asyncSnapshot.data.weather![0].main!.toLowerCase()}.jpg'),
                            fit: BoxFit.cover,
                            colorFilter: const ColorFilter.mode(
                                Colors.black38, BlendMode.luminosity)),
                      ),
                    ),
                    SingleChildScrollView(
                      child: SafeArea(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Container(
                                height: 55,
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: TextField(
                                  cursorColor: Colors.white,
                                  onSubmitted: (value) {
                                    setState(() {
                                      city = value;
                                    });
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    hintStyle: TextStyle(color: Colors.white70),
                                    labelStyle: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                error,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    letterSpacing: 0.5),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${asyncSnapshot.data.name}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 33),
                                      ),
                                      Text(
                                        '  ${asyncSnapshot.data.sys!.country!}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    " ${DateFormat('MMMMEEEEd').format(tz)} ― ${DateFormat('jm').format(tz)}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                  const SizedBox(
                                    height: 300,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${(asyncSnapshot.data.main!.temp! - 273.15).round()}°C",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 70,
                                            fontWeight: FontWeight.w200),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.arrow_upward,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              Text(
                                                "${(asyncSnapshot.data.main!.tempMax! - 273.15).round()}°C",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.arrow_downward,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              Text(
                                                "${(asyncSnapshot.data.main!.tempMin! - 273.15).round()}°C",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.network(
                                              "http://openweathermap.org/img/w/${asyncSnapshot.data.weather![0].icon}.png"),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "${asyncSnapshot.data.weather![0].main}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                      Text(
                                          "Feels Like ${(asyncSnapshot.data.main!.feelsLike! - 273.15).round()}°C",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300))
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 0.5,
                                    height: 30,
                                    color: Colors.white,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: items
                                        .map((e) => Column(
                                              children: [
                                                Text(
                                                  e[0],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                Text(
                                                  e[1],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 20),
                                                ),
                                                Text(
                                                  e[2],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ],
                                            ))
                                        .toList(),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
