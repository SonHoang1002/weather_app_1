import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:waether_app/general/constant_var.dart';
import 'package:waether_app/repository/api.dart';

// class TestWidget extends StatelessWidget {
//   const TestWidget({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(children: <Widget>[
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.transparent,
//           ),
//           height: 350,
//           child: Column(children: []),
//         ),
//       ]),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           getNextDayData();
//         },
//         child: Text("ADD"),
//       ),
//     );
//   }
// }

class TestWidget extends StatelessWidget {
  final double day = 19.55;
  final double night = 16.09;
  final double eve = 19.77;
  final double morn = 13.33;
  final double max = 19.77;
  final double min = 11.96;
  int sunrise = 40;
  int sunset = 230;
  List<Color> listColor = [
    Colors.green,
    Colors.yellow,
    Colors.yellowAccent,
    Colors.red
  ];
  @override
  Widget build(BuildContext context) {
    double averrage = (min + max) / 2;
    int begin = 0;
    return Scaffold(
      body: Center(
          child: Container(
              // width: 300,
              height: 20,
              // color: Colors.black,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 144,
                  itemBuilder: ((context, index) {
                    if (index < sunset && index > sunrise) {
                      begin = begin + 100;
                      return Container(
                        width: 2.5,
                        height: 20,
                        // decoration: BoxDecoration(color: Colors.greenAccent[begin]),
                        color: Colors.green,
                      );
                    }
                    return Container(
                      width: 2.5,
                      height: 20,
                      color: Colors.black,
                    );
                  })))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text("ADD"),
      ),
    );
  }
}
// Widget setabc(){
//   return ListView()
// }