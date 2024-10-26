import 'package:intl/intl.dart';

class DeliveryTrackingModel {
  final Carrier carrier;
  final TrackingParty from;
  final TrackingParty to;
  final List<TrackingProgress> progresses;
  final TrackingState state;

  DeliveryTrackingModel({
    required this.carrier,
    required this.from,
    required this.to,
    required this.progresses,
    required this.state,
  });

  factory DeliveryTrackingModel.fromJson(Map<String, dynamic> json) {
    return DeliveryTrackingModel(
      carrier: Carrier.fromJson(json['carrier']),
      from: TrackingParty.fromJson(json['from']),
      to: TrackingParty.fromJson(json['to']),
      progresses: (json['progresses'] as List)
          .map((progress) => TrackingProgress.fromJson(progress))
          .toList(),
      state: TrackingState.fromJson(json['state']),
    );
  }
}

class Carrier {
  final String id;
  final String name;
  final String tel;

  Carrier({required this.id, required this.name, required this.tel});

  factory Carrier.fromJson(Map<String, dynamic> json) {
    return Carrier(
      id: json['id'],
      name: json['name'],
      tel: json['tel'],
    );
  }
}

class TrackingParty {
  final String name;
  final DateTime time;

  TrackingParty({required this.name, required this.time});

  factory TrackingParty.fromJson(Map<String, dynamic> json) {
    return TrackingParty(
      name: json['name'] ?? "",
      time: DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(json['time']),
    );
  }
}

class TrackingProgress {
  final DateTime time;
  final TrackingState status;
  final Location location;
  final String description;

  TrackingProgress({
    required this.time,
    required this.status,
    required this.location,
    required this.description,
  });

  factory TrackingProgress.fromJson(Map<String, dynamic> json) {
    return TrackingProgress(
      time: DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(json['time']),
      status: TrackingState.fromJson(json['status']),
      location: Location.fromJson(json['location']),
      description: json['description'],
    );
  }
}

class TrackingState {
  final String id;
  final String text;

  TrackingState({required this.id, required this.text});

  factory TrackingState.fromJson(Map<String, dynamic> json) {
    return TrackingState(
      id: json['id'],
      text: json['text'],
    );
  }
}

class Location {
  final String name;

  Location({required this.name});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
    );
  }
}
