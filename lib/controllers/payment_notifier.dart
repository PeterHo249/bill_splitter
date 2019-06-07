import 'package:bill_splitter/models/payment.dart';
import 'package:flutter/material.dart';

class PaymentNotifier with ChangeNotifier {
  Payment _payment;

  PaymentNotifier(this._payment);

  Payment get bill => _payment;
  setBill(Payment bill) {
    _payment = bill;
  }

  void setCost(double value) {
    _payment.cost = value;
    notifyListeners();
  }

  void setMemberCount(int value) {
    _payment.memberCount = value;
    notifyListeners();
  }

  void setTipRate(int value) {
    _payment.setTipRate(value);
    notifyListeners();
  }
}