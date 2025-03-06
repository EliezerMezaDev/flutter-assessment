import 'package:flight_app/database/database_helpder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/widgets.dart';
import 'package:flight_app/models/common.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class CommonProvider extends ChangeNotifier {
  String get baseUrl => dotenv.env['API_URL'] ?? '';

  bool isLoading = false;
  String error = '';

  Flights flights = Flights(itineraries: [], legs: []);

  getDataFromApi() async {
    isLoading = true;

    final dbHelper = DatabaseHelper.instance;

    try {
      Response response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        flights = decodeFlightsFromJson(response.body);

        try {
          await dbHelper.insertItinerariesAndLegs(flights);
        } catch (e) {}
      } else {
        error = response.statusCode.toString();
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }
}
