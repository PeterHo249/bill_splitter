import 'package:bill_splitter/widgets/bill_add_form.dart';
import 'package:bill_splitter/widgets/bill_list.dart';
import 'package:bill_splitter/widgets/trip_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentBottomIndex;

  @override
  void initState() {
    super.initState();
    currentBottomIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildHome(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: _buildFloatActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Bill Splitter'),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          title: Text('Bills'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_travel),
          title: Text('Trips'),
        ),
      ],
      currentIndex: currentBottomIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.blueGrey,
      onTap: (value) {
        setState(() {
          currentBottomIndex = value;
        });
      },
    );
  }

  Widget _buildHome(BuildContext context) {
    switch (currentBottomIndex) {
      case 0:
        return BillList();
      case 1:
        return TripList();
      default:
        return Container();
    }
  }

  Widget _buildFloatActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        switch (currentBottomIndex) {
          case 0:
            addBill();
            break;
          case 1:
            addTrip();
            break;
          default:
            return;
        }
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(Icons.add),
    );
  }

  void addBill() {
    Navigator.push(
      this.context,
      MaterialPageRoute(
        builder: (context) => AddingBillForm(),
      ),
    );
  }

  void addTrip() {
    print('add trip');
  }
}
