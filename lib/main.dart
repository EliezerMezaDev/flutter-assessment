//- FLUTTER IMPORTS
import 'package:flight_app/views/airlinesList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//? MY IMPORTS
import 'package:flight_app/provider/common.dart';
import 'package:flight_app/views/flightsList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'FlightsApp',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        ),
        home: RootPage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = Flights();
        break;
      case 1:
        page = Airlines();
        break;
      case 2:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return ChangeNotifierProvider(
      create: (context) => CommonProvider(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            body: page,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedIndex,
              showUnselectedLabels: false,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.flight_takeoff),
                  label: 'Flights',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map_sharp),
                  label: 'Airlines',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Save',
                ),
              ],
              iconSize: 30,
              fixedColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        },
      ),
    );
  }
}
