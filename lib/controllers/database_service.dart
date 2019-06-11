import 'dart:convert';

import 'package:bill_splitter/models/payment.dart';
import 'package:bill_splitter/models/trip_tracker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;
  String udid;

  static final DatabaseService _singleton = DatabaseService._internal();
  DatabaseService._internal();
  static DatabaseService get instance => _singleton;

  //******************* Read data section ********************
  Stream<PaymentDocument> getPaymentStream(String docPath) {
    return _db.document(docPath).snapshots().map(
          (snapshot) => PaymentDocument(
                path: snapshot.reference.path,
                data: Payment.fromJson(
                  json.decode(
                    json.encode(snapshot.data),
                  ),
                ),
              ),
        );
  }

  Stream<List<PaymentDocument>> getPaymentListStream() {
    return _db
        .collection(udid)
        .document('bills')
        .collection('bills')
        .snapshots()
        .map(
          (snapshot) => _convertPaymentQueryDataToList(snapshot.documents),
        );
  }

  Stream<List<PaymentDocument>> getPaymentInTripListStream(String tripDocPath) {
    return _db.document(tripDocPath).collection('bills').snapshots().map(
          (snapshot) => _convertPaymentQueryDataToList(snapshot.documents),
        );
  }

  Stream<List<TripTrackerDocument>> getTripList() {
    return _db
        .collection(udid)
        .document('trips')
        .collection('trips')
        .snapshots()
        .map((snapshot) => _convertTripQueryDataToList(snapshot.documents));
  }
  //****************** End read data section ******************

  //******************* Write data section ********************
  Future<String> writePayment(
    Payment payment, {
    String docId,
    String docPath,
    String tripDocId,
    bool isSingle = true,
  }) async {
    var batch = _db.batch();

    DocumentReference docRef;

    if (docPath != null) {
      docRef = _db.document(docPath);
    } else {
      if (isSingle) {
        docRef = _db
            .collection(udid)
            .document('bills')
            .collection('bills')
            .document(docId);
      } else {
        docRef = _db
            .collection(udid)
            .document('trips')
            .collection('trips')
            .document(tripDocId)
            .collection('bills')
            .document(docId);
      }
    }

    String newDocPath = docRef.path;
    batch.setData(
      docRef,
      json.decode(
        json.encode(payment),
      ),
    );

    await batch
        .commit()
        .catchError((error) => print('=========> error: $error'));

    return newDocPath;
  }

  Future<String> writeTrip(TripTracker trip,
      {String docId, String docPath}) async {
    var batch = _db.batch();

    DocumentReference docRef;

    if (docPath != null) {
      docRef = _db.document(docPath);
    } else {
      docRef = _db
          .collection(udid)
          .document('trips')
          .collection('trips')
          .document(docId);
    }

    String newDocPath = docRef.path;
    batch.setData(
      docRef,
      json.decode(
        json.encode(trip),
      ),
    );

    await batch
        .commit()
        .catchError((error) => print('=========> error: $error'));
    return newDocPath;
  }

  deletePayment(String docPath) async {
    var batch = _db.batch();

    var docRef = _db.document(docPath);
    batch.delete(docRef);

    await batch
        .commit()
        .catchError((error) => print('=========> error: $error'));
  }

  changePaymentState(int index, PaymentDocument billDocument) {
    var isNeedUpdate = billDocument.data.changePaymentStateOfMember(index);

    if (isNeedUpdate) {
      writePayment(billDocument.data, docPath: billDocument.path);
    }
  }
  //***************** End write data section ******************

  //********************* Helper section **********************
  List<PaymentDocument> _convertPaymentQueryDataToList(
    List<DocumentSnapshot> documents,
  ) {
    var result = List<PaymentDocument>();

    for (var document in documents) {
      result.add(
        PaymentDocument(
          path: document.reference.path,
          data: Payment.fromJson(
            json.decode(
              json.encode(document.data),
            ),
          ),
        ),
      );
    }

    result.sort((a, b) => b.data.date.compareTo(a.data.date));

    return result;
  }

  List<TripTrackerDocument> _convertTripQueryDataToList(
    List<DocumentSnapshot> documents,
  ) {
    var result = List<TripTrackerDocument>();

    for (var document in documents) {
      var data = TripTracker.fromJson(
        json.decode(
          json.encode(document.data),
        ),
      );

      getPaymentInTripListStream(document.reference.path)
          .listen((paymentList) => data.billDocuments = paymentList);

      result.add(
        TripTrackerDocument(
          path: document.reference.path,
          data: data,
        ),
      );
    }

    return result;
  }
  //******************* End helper section ********************
}
