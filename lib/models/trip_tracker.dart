import 'package:bill_splitter/models/payment.dart';
import 'package:json_annotation/json_annotation.dart';

part "trip_tracker.g.dart";

@JsonSerializable()
class TripTracker {
  String name;
  DateTime date;
  List<PayState> members;
  @JsonKey(ignore: true)
  List<PaymentDocument> billDocuments;

  TripTracker({
    this.name,
    this.members,
    this.billDocuments,
    this.date,
  }) {
    date = date ?? DateTime.now();
    name = name ?? 'Trip at $tripDate';
    members = members ??
        <PayState>[
          PayState(
            name: 'You',
            isPayBack: true,
          ),
        ];
    billDocuments = billDocuments ?? List<PaymentDocument>();
  }

  factory TripTracker.fromJson(Map<String, dynamic> json) =>
      _$TripTrackerFromJson(json);

  Map<String, dynamic> toJson() => _$TripTrackerToJson(this);

  void addBill(PaymentDocument billDocument) {
    billDocuments.add(billDocument);
  }

  int get memberCount => members.length;
  String get tripDate => '${date.day}/${date.month}/${date.year}';
  double get totalCost {
    var cost = 0.0;
    billDocuments.forEach((bill) => cost += bill.data.totalCost);
    return cost;
  }

  double getCostForMember(String id) {
    var cost = 0.0;
    billDocuments.forEach((billDocument) {
      var memberIndex = billDocument.data.members.indexWhere((member) => member.id == id);
      if (memberIndex != -1) {
        cost += billDocument.data.paymentPartCost;
      }
    });
    return cost;
  }

  double getRemainCostForMember(String id) {
    var cost = 0.0;
    billDocuments.forEach((billDocument) {
      var memberIndex = billDocument.data.members.indexWhere((member) => member.id == id);
      if (memberIndex != -1 && !billDocument.data.members[memberIndex].isPayBack) {
        cost += billDocument.data.paymentPartCost;
      }
    });
    return cost;
  }
}

class TripTrackerDocument {
  final String path;
  final TripTracker data;

  TripTrackerDocument({
    this.path,
    this.data,
  });
}
