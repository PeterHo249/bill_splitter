// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return Payment(
      cost: (json['cost'] as num)?.toDouble(),
      memberCount: json['memberCount'] as int,
      tipRate: (json['tipRate'] as num)?.toDouble(),
      members: (json['members'] as List)
          ?.map((e) =>
              e == null ? null : PayState.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'cost': instance.cost,
      'memberCount': instance.memberCount,
      'tipRate': instance.tipRate,
      'members': instance.members
    };

PayState _$PayStateFromJson(Map<String, dynamic> json) {
  return PayState(
      name: json['name'] as String, isPayBack: json['isPayBack'] as bool);
}

Map<String, dynamic> _$PayStateToJson(PayState instance) =>
    <String, dynamic>{'name': instance.name, 'isPayBack': instance.isPayBack};
