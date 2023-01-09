import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:waether_app/business/getx_temparture.dart';
import 'package:waether_app/general/constant_var.dart';
import 'package:waether_app/models/current_time_model.dart';
import 'package:waether_app/models/next_day_model.dart';
import 'package:waether_app/models/next_time.model.dart';
import 'package:waether_app/repository/api.dart';
import 'package:waether_app/widget/weather_day.dart';
import 'package:waether_app/widget/weather_time.dart';

const double K_to_C = 273.15;

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String address = "Hà Nội";
  late int temp;
  String description =
      "Có mây sẽ tiếp tục đến hết ngày . Gió giật lên đến 17 km/h";
  int currentHour = DateTime.now().hour;
  late List<String> listOfTime;
  late List<String> listOfDay;
  late TimeModel timeModel;
  late List<NextTimeModel> nextTimeModel;
  late NextDayModel nextDayModel;

  @override
  void initState() {
    super.initState();
    nextDayModel = NextDayModel();
    timeModel = TimeModel();
    Future<int> a = getDataTime();
    if (nextDayModel.list?.length == 0) {
      Future<int> b = getDataTime();
      print(nextDayModel.cod);
    }
  }

  @override
  Widget build(BuildContext context) {
    listOfTime = ["Bây giờ"];
    listOfDay = ["Hôm nay"];

    var b = setMinAndMaxTempature();

    _buildSixNextDay();
    return Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
          future: getDataTime(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                nextDayModel == null &&
                timeModel == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(
                    ConstantVariable.pathImage + "cloudy.jpg",
                  ),
                  fit: BoxFit.cover,
                )),
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                // padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // address
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Center(
                          child: Text(
                            address,
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                        ),
                      ),

                      // temperature
                      Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Center(
                            child: Text(
                              ((timeModel?.main?.temp ?? 294) - K_to_C)
                                      .ceil()
                                      .toString() +
                                  "°",
                              style: TextStyle(
                                  fontSize: 75,
                                  fontWeight: FontWeight.lerp(
                                      FontWeight.normal, FontWeight.normal, 4),
                                  color: Colors.white),
                            ),
                          )),

                      // temp for time
                      Container(
                        height: 180,
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Column(children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
                            child: Text(
                              // timeModel.weather![0].description.toString(),
                              timeModel.weather?[0].description.toString() ?? "20",
                              style: TextStyle(
                                  // fontSize: 40,
                                  // fontWeight:
                                  //     FontWeight.lerp(FontWeight.normal, FontWeight.normal, 4),
                                  color: Colors.white),
                            ),
                          ),
                          Divider(
                            height: 10,
                            color: Colors.white,
                          ),
                          Container(
                            height: 87,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: nextTimeModel.length,
                                itemBuilder: ((context, index) {
                                  return WeatherTime(
                                      hour: index == 0
                                          ? "Bây giờ"
                                          : ((nextTimeModel[index].dtTxt)!
                                                  .split(" ")[1])
                                              .split(":")[0],
                                      temp: (nextTimeModel[index].main!.temp! -
                                              K_to_C)
                                          .round());
                                })),
                          )
                        ]),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.6),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),

                      // du bao 10 ngay toi
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.6),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 7, 0),
                                        height: 18,
                                        width: 18,
                                        child: Image.asset(
                                          ConstantVariable.pathImage +
                                              "calendar_icon.png",
                                          color: Colors.white,
                                        )),
                                    Text(
                                      "DỰ BÁO 10 NGÀY",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ]),
                            ),
                            Divider(
                              height: 10,
                              color: Colors.white,
                            ),
                            Container(
                              child:
                                  FutureBuilder(builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Container(
                                  height: 310,
                                  child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: nextDayModel.list!.length,
                                      itemBuilder: ((context, index) {
                                        return WeatherDay(
                                            day: listOfDay[index],
                                            darkTemp: nextDayModel
                                                .list![index].temp!.min!
                                                .ceil(),
                                            lightTemp: nextDayModel
                                                .list![index].temp!.max!
                                                .ceil());
                                      })),
                                );
                              })),
                            )
                          ],
                        ),
                      ),

                      // bottom sheet
                      Expanded(
                        child: Container(
                          color: Colors.grey[500],
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Center(
                                            child: Icon(
                                              Icons.wind_power,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        Wrap(
                                          verticalDirection:
                                              VerticalDirection.up,
                                          children: [
                                            Icon(
                                              CupertinoIcons.location,
                                              color: Colors.white,
                                              size: 10,
                                            ),
                                            Align(
                                              child: Container(
                                                height: 5,
                                                width: 5,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                        Wrap(children: [Icon(Icons.menu)])
                                      ]),
                                ),
                                Align(
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    height: 3,
                                    width: 150,
                                    color: Colors.white,
                                  ),
                                )
                              ]),
                        ),
                      ),
                    ]));
          },
        ));
  }

  _buildSixNextDay() {
    var tempDay = DateTime.now().weekday + 2;
    for (var i = 0; i < 9; i++) {
      if (tempDay > 7) {
        listOfDay.add("CN");
        tempDay = 2;
      } else {
        listOfDay.add("Th $tempDay");
        tempDay += 1;
      }
    }
  }

  _buildFiveNextTime(Map<String, dynamic> value) {
    listOfTime = ["Bây giờ"];
    var temp = currentHour;
    for (var i = 1; i < 6; i++) {
      if (temp < 24) {
        temp += 1;
        listOfTime.add(temp.toString());
      }
    }
  }

  Future<int> getDataTime() async {
    timeModel = await getCurrentTemparature();
    nextTimeModel = await getNextTimeData();
    nextDayModel = await getNextDayData();
    setState(() {});
    return Future.value(1);
  }

  int setMinAndMaxTempature() {
    if (nextDayModel?.list?.length == 0 || nextDayModel.list == null) {
      Future<int> abc = getDataTime();
    } else {
      int min = nextDayModel.list![0].temp!.min!.ceil();
      int max = nextDayModel.list![0].temp!.max!.ceil();

      for (int i = 0; i < nextDayModel.list!.length; i++) {
        if (nextDayModel.list![i].temp!.max!.ceil() > max) {
          max = nextDayModel.list![i].temp!.max!.ceil();
        }
        if (nextDayModel.list![i].temp!.min!.ceil() < min) {
          min = nextDayModel.list![i].temp!.min!.ceil();
        }
      }
      MinAndMaxTemparture.max = max;
      MinAndMaxTemparture.min = min;
      // print(MinAndMaxTemparture.min);
      // print(MinAndMaxTemparture.max);
    }

    return 1;
  }
}
