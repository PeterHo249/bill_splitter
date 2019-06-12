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
    notifyListeners();
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

  void addMember() {
    _tripTracker.members.add(
      PayState(
        name: 'Member ${_tripTracker.memberCount - 1}',
        isPayBack: false,
      ),
    );
    notifyListeners();
  }

  void removeMember() {
    _tripTracker.members.removeLast();
    notifyListeners();
  }

  void removeMemberAt(int index) {
    if (index <= 0 || index >= _tripTracker.memberCount) {
      return;
    } else {
      _tripTracker.members.removeAt(index);
      notifyListeners();
    }
  }

  void setMemberName(String value, int index) {
    _tripTracker.members[index].name = value;
  }
}
