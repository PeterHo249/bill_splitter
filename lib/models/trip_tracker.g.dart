// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_tracker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripTracker _$TripTrackerFromJson(Map<String, dynamic> json) {
  return TripTracker(
      name: json['name'] as String,
      members: (json['members'] as List)
          ?.map((e) =>
              e == null ? null : PayState.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String));
}

Map<String, dynamic> _$TripTrackerToJson(TripTracker instance) =>
    <String, dynamic>{
      'name': instance.name,
      'date': instance.date?.toIso8601String(),
      'members': instance.members
    };
