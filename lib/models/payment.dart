import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  String title;
  double cost;
  int memberCount;
  double tipRate;
  List<PayState> members;
  DateTime date;

  Payment({
    this.title,
    this.cost = 0,
    this.memberCount = 1,
    this.tipRate = 0.1,
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
