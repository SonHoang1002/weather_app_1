import 'package:flutter/material.dart';
import 'package:waether_app/general/constant_var.dart';
import 'package:waether_app/repository/min_max_temp.dart';

const linearGradient =
    LinearGradient(colors: [Colors.green, Colors.yellow, Colors.red]);

class WeatherDay extends StatelessWidget {
  final String day;
  final int darkTemp;
  final int lightTemp;

  const WeatherDay(
      {super.key,
      required this.day,
      required this.darkTemp,
      required this.lightTemp});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            // day
            Container(
              width: 60,
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
            // icon
            Container(
              // margin: ,
              child: Image.asset(
                ConstantVariable.pathImage + "cloud.png",
                height: 30,
                width: 30,
              ),
            ),
            // dark temp
            Container(
              child: Text(
                darkTemp.toString() + "°",
                style: TextStyle(color: Colors.white),
              ),
            ),
            // temp line
            Stack(
              children: [
                Container(
                  width: 70,
                  height: 4,
                  decoration: BoxDecoration(gradient: linearGradient),
                ),
                Row(
                  children: [
                    Container(
                      width: 70 *
                          (darkTemp - MinAndMaxTemparture.min) /
                          (MinAndMaxTemparture.max - MinAndMaxTemparture.min),
                      color: Colors.black.withOpacity(0.8),
                      height: 4,
                    ),
                    Container(
                      width: 70 *
                          (lightTemp - darkTemp) /
                          (MinAndMaxTemparture.max - MinAndMaxTemparture.min),
                      color: Colors.transparent,
                      height: 4,
                    ),
                    Container(
                      width: 70 *
                          (MinAndMaxTemparture.max - lightTemp) /
                          (MinAndMaxTemparture.max - MinAndMaxTemparture.min),
                      color: Colors.black.withOpacity(0.8),
                      height: 4,
                    ),
                  ],
                ),
                // ],
                // )
              ],
            ),
            // light temp
            Container(
              child: Text(
                lightTemp.toString() + "°",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ]),
          Divider(
            height: 10,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
