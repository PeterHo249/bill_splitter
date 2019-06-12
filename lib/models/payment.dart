import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  String title;
  double cost;
  double tipRate;
  List<PayState> members;
  DateTime date;

  Payment({
    this.title,
    this.cost = 0,
    this.tipRate = 0.0,
    this.members,
    this.date,
  }) {
    if (members == null) {
      members = [
        PayState(name: 'You', isPayBack: true),
      ];
    }

    date = date ?? DateTime.now();
    title = title ?? 'Bill at $billDate';
  }

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);

  double get tipAmount => cost * tipRate;
  int get displayedTipRate => (tipRate * 100).floor();
  String get billDate => '${date.day}/${date.month}/${date.year}';
  double get totalCost => cost * (1.0 + tipRate);
  double get paymentPartCost => totalCost / memberCount;
  int get memberCount => members.length;

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

  bool changePaymentStateOfMember(int index) {
    if (index == 0) {
      return false;
    } else {
      members[index].changeState();
      return true;
    }
  }
}

@JsonSerializable()
class PayState {
  String id;
  String name;
  bool isPayBack;

  PayState({
    this.id,
    this.name,
    this.isPayBack = false,
  }) {
    id = id ?? UniqueKey().toString();
  }

  factory PayState.fromJson(Map<String, dynamic> json) =>
      _$PayStateFromJson(json);

  Map<String, dynamic> toJson() => _$PayStateToJson(this);

  void changeState() {
    isPayBack = !isPayBack;
  }
}

class PaymentDocument {
  final String path;
  final Payment data;

  PaymentDocument({this.path, this.data});
}
