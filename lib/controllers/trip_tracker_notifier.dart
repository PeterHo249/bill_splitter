import 'package:bill_splitter/models/payment.dart';
import 'package:bill_splitter/models/trip_tracker.dart';
import 'package:flutter/material.dart';

class TripTrackerNotifier with ChangeNotifier {
  TripTracker _tripTracker;

  TripTrackerNotifier(this._tripTracker);

  TripTracker get tripTracker => _tripTracker;
  void setTripTracker(TripTracker tripTracker) => _tripTracker = tripTracker;

  void setDate(DateTime date) {
    _tripTracker.date = date;
  }

  void setName(String name) {
    _tripTracker.name = name;
  }

  void setMembers(List<PayState> members) {
    _tripTracker.members = members;
    notifyListeners();
  }

  void setBills(List<PaymentDocument> bills) {
    _tripTracker.billDocuments = bills;
    notifyListeners();
  }
}