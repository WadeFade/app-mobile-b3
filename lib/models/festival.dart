import 'dart:convert';

import 'package:app_festival_flutter/models/event.dart';
import 'package:intl/intl.dart';

class Festival {
  int id;
  String name;
  String description;
  DateTime startDate;
  DateTime endDate;
  // Un festival à plusieurs events
  List<Event>? listEvents;

  Festival(this.id, this.name, this.description, this.startDate, this.endDate, this.listEvents);

  Festival.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        startDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(json["startDate"]),
        endDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(json["endDate"]),
        listEvents = null;
        // List<Event>.from(jsonDecode(json['events'])!.
        // map((i) => Event.fromJson(i)));

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'startDate': startDate,
    'endDate': endDate,
  };
}
