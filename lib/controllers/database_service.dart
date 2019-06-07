import 'dart:convert';

import 'package:bill_splitter/models/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;
  String udid;

  static final DatabaseService _singleton = DatabaseService._internal();
  DatabaseService._internal();
  static DatabaseService get instance => _singleton;

  //******************* Read data section ********************
  Stream<Payment> getPaymentStream(String docId) {
    return _db.collection(udid).document(docId).snapshots().map(
          (snapshot) => Payment.fromJson(
                json.decode(
                  json.encode(snapshot.data),
                ),
              ),
        );
  }

  //****************** End read data section ******************

  //******************* Write data section ********************
  writePayment(Payment payment, {String docId}) async {
    var batch = _db.batch();

    DocumentReference docRef = _db.collection(udid).document(docId ?? "");
    batch.setData(
      docRef,
      json.decode(
        json.encode(payment),
      ),
    );

    await batch
        .commit()
        .catchError((error) => print('=========> error: $error'));
  }
  //***************** End write data section ******************
}
