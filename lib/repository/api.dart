import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:waether_app/models/current_time_model.dart';
import 'package:waether_app/models/next_day_model.dart';
import 'package:waether_app/models/next_time.model.dart';

Future<TimeModel> getCurrentTemparature() async {
  const url =
      "https://api.openweathermap.org/data/2.5/weather?lat=21.027763&lon=105.834160&lang=vi&appid=4f7d7496aa4484f29d904b86b01ef8bf";
  try {
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    final data = TimeModel.fromJson(body);
    // print(a);
    return data;
  } catch (e) {
    throw e;
  }
}

Future<List<NextTimeModel>> getNextTimeData() async {
  final String path = await rootBundle.loadString("assets/repo/time_data.json");
  final List<dynamic> response = await json.decode(path);
  final list = response.map((e) => (NextTimeModel.fromJson(e))).toList();
  // print("list.length : ${list.length}");
  return list;
}

Future<NextDayModel> getNextDayData() async {
  final String path = await rootBundle.loadString("assets/repo/day_data.json");
  // final response = await json.decode(path);
  final response = jsonDecode(path);
  final nextDayModel = NextDayModel.fromJson(response);
  print(nextDayModel.list!.length);
  return nextDayModel;
}

Stream<TimeModel> getDataTimeStream() async* {
  yield* Stream.periodic(const Duration(seconds: 3), (_) {
    var json;
    final body = http
        .get(Uri.parse(
            "https://api.openweathermap.org/data/2.5/weather?lat=21.027763&lon=105.834160&lang=vi&appid=4f7d7496aa4484f29d904b86b01ef8bf"))
        .then((value) {
      json = jsonDecode(value.body);
    });
    return TimeModel.fromJson(json);
  });
}
