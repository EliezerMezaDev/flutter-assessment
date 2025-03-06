import 'dart:convert';

//? FLIGHTS ?//
class Flights {
  final List<Itinerary> itineraries;
  final List<Leg> legs;

  Flights({required this.itineraries, required this.legs});

  factory Flights.fromJson(Map<String, dynamic> json) => Flights(
    itineraries: List<Itinerary>.from(
      json["itineraries"].map((x) => Itinerary.fromJson(x)),
    ),
    legs: List<Leg>.from(json["legs"].map((x) => Leg.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "itineraries": List<dynamic>.from(itineraries.map((x) => x.toJson())),
    "legs": List<dynamic>.from(legs.map((x) => x.toJson())),
  };
}

class Itinerary {
  final String id;
  final List<String> legs;
  final String price;
  final String agent;
  final double agentRating;

  Itinerary({
    required this.id,
    required this.legs,
    required this.price,
    required this.agent,
    required this.agentRating,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
    id: json["id"],
    legs: List<String>.from(json["legs"].map((x) => x)),
    price: json["price"],
    agent: json["agent"],
    agentRating: json["agent_rating"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "legs": List<dynamic>.from(legs.map((x) => x)),
    "price": price,
    "agent": agent,
    "agent_rating": agentRating,
  };
}

class Leg {
  final String id;
  final String departureAirport;
  final String arrivalAirport;
  final String departureTime;
  final String arrivalTime;
  final int stops;
  final String airlineName;
  final String airlineId;
  final int durationMins;

  Leg({
    required this.id,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    required this.stops,
    required this.airlineName,
    required this.airlineId,
    required this.durationMins,
  });

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
    id: json["id"],
    departureAirport: json["departure_airport"],
    arrivalAirport: json["arrival_airport"],
    departureTime: json["departure_time"],
    arrivalTime: json["arrival_time"],
    stops: json["stops"],
    airlineName: json["airline_name"],
    airlineId: json["airline_id"],
    durationMins: json["duration_mins"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "departure_airport": departureAirport,
    "arrival_airport": arrivalAirport,
    "departure_time": departureTime,
    "arrival_time": arrivalTime,
    "stops": stops,
    "airline_name": airlineName,
    "airline_id": airlineId,
    "duration_mins": durationMins,
  };
}

Flights decodeFlightsFromJson(String str) => Flights.fromJson(json.decode(str));
String encodeFlightsToJson(Flights data) => json.encode(data.toJson());
