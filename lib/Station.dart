import 'dart:convert';
class Station{
  int numberOfBusses;
  String stationName;
  int stationNumber;

  Station({this.stationNumber,this.stationName,this.numberOfBusses});
  factory Station.fromJson(Map<String,dynamic>json)=>Station(
    numberOfBusses: json["numberOfBusses"],
    stationName: json["stationName"],
    stationNumber: json["stationNumber"]
  );
}
