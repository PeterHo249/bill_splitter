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

  Stream<List<Payment>> getPaymentListStream() {
    return _db.collection(udid).snapshots().map(
          (snapshot) => _convertPaymentQueryDataToList(snapshot.documents),
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

  //********************* Helper section **********************
  List<Payment> _convertPaymentQueryDataToList(
      List<DocumentSnapshot> documents) {
    var result = List<Payment>();

    for (var document in documents) {
      if (document.documentID != 'trips') {
        result.add(
          Payment.fromJson(
            json.decode(
              json.encode(document.data),
            ),
          ),
        );
      }
    }

    return result;
  }
  //******************* End helper section ********************
}
