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
  }

  void setCost(double value) {
    _payment.cost = value;
  }

  void addMember() {
    _payment.members.add(
      PayState(
        name: 'Member ${_payment.memberCount - 1}',
        isPayBack: false,
      ),
    );
    notifyListeners();
  }

  void removeMember() {
    _payment.members.removeLast();
    notifyListeners();
  }

  void removeMemberAt(int index) {
    if (index <= 0 || index >= _payment.memberCount) {
      return;
    } else {
      _payment.members.removeAt(index);
      notifyListeners();
    }
  }

  void setTipRate(int value) {
    _payment.setTipRate(value);
  }

  void setMemberName(String value, int index) {
    _payment.members[index].name = value;
  }

  void setMemberPayBackState(bool value, int index) {
    _payment.members[index].isPayBack = value;
  }

  void resetNotify() {
    notifyListeners();
  }
}
