// To parse this JSON data, do
//
//     final circuitBreakersModel = circuitBreakersModelFromJson(jsonString);

import 'dart:convert';

CircuitBreakersModel circuitBreakersModelFromJson(String str) => CircuitBreakersModel.fromJson(json.decode(str));

String circuitBreakersModelToJson(CircuitBreakersModel data) => json.encode(data.toJson());

class CircuitBreakersModel {
  List<int> lowerCircuitBreakers;
  List<int> upperCircuitBreakers;

  CircuitBreakersModel({
      this.lowerCircuitBreakers,
      this.upperCircuitBreakers,
  });

  factory CircuitBreakersModel.fromJson(Map<String, dynamic> json) => CircuitBreakersModel(
    lowerCircuitBreakers: List<int>.from(json["lowerCircuitBreakers"].map((x) => x)),
    upperCircuitBreakers: List<int>.from(json["upperCircuitBreakers"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "lowerCircuitBreakers": List<dynamic>.from(lowerCircuitBreakers.map((x) => x)),
    "upperCircuitBreakers": List<dynamic>.from(upperCircuitBreakers.map((x) => x)),
  };
}
