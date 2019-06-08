import 'package:bill_splitter/models/payment.dart';
import 'package:flutter/material.dart';

class PaymentNotifier with ChangeNotifier {
  Payment _payment;

  PaymentNotifier(this._payment);

  Payment get bill => _payment;
  setBill(Payment bill) {
    _payment = bill;
  }

  void setTitle(String value) {
    _payment.title = value;
    //notifyListeners();
  }

  void setCost(double value) {
    _payment.cost = value;
    //notifyListeners();
  }

  void addMember() {
    _payment.memberCount++;
    _payment.members.add(
      PayState(
        name: 'Member ${_payment.memberCount - 1}',
        isPayBack: false,
      ),
    );
    notifyListeners();
  }

  void removeMember() {
    _payment.memberCount--;
    _payment.members.removeLast();
    notifyListeners();
  }

  void removeMemberAt(int index) {
    if (index <= 0 || index >= _payment.memberCount) {
      return;
    } else {
      _payment.memberCount--;
      _payment.members.removeAt(index);
      notifyListeners();
    }
  }

  void setTipRate(int value) {
    _payment.setTipRate(value);
    //notifyListeners();
  }

  void setMemberName(String value, int index) {
    _payment.members[index].name = value;
    //notifyListeners();
  }

  void setMemberPayBackState(bool value, int index) {
    _payment.members[index].isPayBack = value;
    //notifyListeners();
  }

  void resetNotify() {
    notifyListeners();
  }
}
