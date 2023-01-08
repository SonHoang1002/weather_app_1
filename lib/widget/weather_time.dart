import 'package:flutter/material.dart';
import 'package:waether_app/general/constant_var.dart';

class WeatherTime extends StatelessWidget {
  final String hour;
  final int temp;

  const WeatherTime({super.key, required this.hour, required this.temp});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 15, 0, 0),
      width: 50,
      // color: Colors.red,
      height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(hour,style: TextStyle(color: Colors.white),),
          ),
          Container(
            // margin: ,
            child: Image.asset(ConstantVariable.pathImage + "cloud.png",height: 40,width: 40,),
          ),
          Container(child: Text(temp.toString()+"°",style: TextStyle(color: Colors.white),),)
        ],
      ),
    );
  }
}

