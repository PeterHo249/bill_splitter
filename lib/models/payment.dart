import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  double cost;
  int memberCount;
  double tipRate;
  List<PayState> members;
  DateTime date;

  Payment({
    this.cost = 0,
    this.memberCount = 1,
    this.tipRate = 0.0,
    this.members,
    this.date,
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

    date = date ?? DateTime.now();
  }

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);

  double get tipAmount => cost * tipRate;
  int get displayedTipRate => (tipRate * 100).floor();
  String get billDate => '${date.day}/${date.month}/${date.year}';

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

  factory PayState.fromJson(Map<String, dynamic> json) =>
      _$PayStateFromJson(json);

  Map<String, dynamic> toJson() => _$PayStateToJson(this);
}
