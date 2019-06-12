// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return Payment(
      title: json['title'] as String,
      cost: (json['cost'] as num)?.toDouble(),
      tipRate: (json['tipRate'] as num)?.toDouble(),
      members: (json['members'] as List)
          ?.map((e) =>
              e == null ? null : PayState.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String));
}

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'title': instance.title,
      'cost': instance.cost,
      'tipRate': instance.tipRate,
      'members': instance.members,
      'date': instance.date?.toIso8601String()
    };

PayState _$PayStateFromJson(Map<String, dynamic> json) {
  return PayState(
      id: json['id'] as String,
      name: json['name'] as String,
      isPayBack: json['isPayBack'] as bool);
}

Map<String, dynamic> _$PayStateToJson(PayState instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isPayBack': instance.isPayBack
    };
