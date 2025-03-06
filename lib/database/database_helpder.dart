import 'package:flight_app/models/common.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  factory DatabaseHelper() => instance;
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'db_flight_app.db');

    return await openDatabase(path, version: 2, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE itineraries (
      id TEXT PRIMARY KEY,
      price TEXT,
      agent TEXT,
      agentRating REAL
    );
    ''');

    await db.execute('''
    CREATE TABLE legs (
      id TEXT PRIMARY KEY,
      departureAirport TEXT,
      arrivalAirport TEXT,
      departureTime TEXT,
      arrivalTime TEXT,
      stops INTEGER,
      airlineName TEXT,
      airlineId TEXT,
      durationMins INTEGER
    );
    ''');

    await db.execute('''
    CREATE TABLE itinerariesLegs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      itineraryId TEXT NOT NULL,
      legId TEXT NOT NULL
    );
    ''');
  }

  Future<void> insertItinerariesAndLegs(Flights flights) async {
    final db = await database;

    for (var leg in flights.legs) {
      await db.insert('legs', {
        'id': leg.id,
        'departureAirport': leg.departureAirport,
        'arrivalAirport': leg.arrivalAirport,
        'departureTime': leg.departureTime,
        'arrivalTime': leg.arrivalTime,
        'stops': leg.stops,
        'airlineName': leg.airlineName,
        'airlineId': leg.airlineId,
        'durationMins': leg.durationMins,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    for (var itinerary in flights.itineraries) {
      await db.insert('itineraries', {
        'id': itinerary.id,
        'price': itinerary.price,
        'agent': itinerary.agent,
        'agentRating': itinerary.agentRating,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      for (var legId in itinerary.legs) {
        await db.insert('itinerariesLegs', {
          'itineraryId': itinerary.id,
          'legId': legId,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  Future<Flights> fetchItinerariesWithLegs() async {
    final db = await database;

    final itineraries = await db.query('itineraries');
    final legs = await db.query('legs');
    final itinerariesLegs = await db.query('itinerariesLegs');

    final itineraryList =
        itineraries.map((itinerary) {
          final itineraryLegs =
              itinerariesLegs
                  .where(
                    (relation) => relation['itineraryId'] == itinerary['id'],
                  )
                  .map((relation) => relation['legId'] as String)
                  .toList();

          return Itinerary(
            id: (itinerary['id'] ?? '') as String,
            legs: itineraryLegs,
            price: (itinerary['price'] ?? 'N/A') as String,
            agent: (itinerary['agent'] ?? 'Unknown') as String,
            agentRating: (itinerary['agentRating'] as num?)?.toDouble() ?? 0.0,
          );
        }).toList();

    final legList = legs.map((leg) => Leg.fromJson(leg)).toList();

    return Flights(itineraries: itineraryList, legs: legList);
  }

  Future<void> clearDatabase() async {
    final db = await database;

    await db.delete('legs');
    await db.delete('itineraries');
    await db.delete('itinerariesLegs');
  }
}
