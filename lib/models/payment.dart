import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  double cost;
  int memberCount;
  double tipRate;
  List<PayState> members;

  Payment({
    @required this.cost,
    this.memberCount = 1,
    this.tipRate = 0.0,
    this.members,
  }) {
    if (members == null) {
      members = [
        PayState(name: 'You', isPayBack: true),
      ];
    } else {
      if (memberCount != members.length) {
        throw Exception("Invalid Argument");
      }
    }
  }

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);

  double get tipAmount => cost * tipRate;
  int get displayedTipRate => (tipRate * 100).floor();
  
  void setTipRate(int rate) {
    if (rate < 0) {
      tipRate = 0.0;
      return;
    }

    if (rate > 100) {
      tipRate = 1.0;
      return;
    }

    tipRate = rate / 100;
  }

  double get paymentPartCost => (cost * (1 + tipRate)) / memberCount;
}

@JsonSerializable()
class PayState {
  String name;
  bool isPayBack;

  PayState({
    this.name,
    this.isPayBack = false,
  });

  factory PayState.fromJson(Map<String, dynamic> json) => _$PayStateFromJson(json);

  Map<String, dynamic> toJson() => _$PayStateToJson(this);
}
