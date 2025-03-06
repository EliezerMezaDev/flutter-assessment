import 'package:flight_app/models/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/common.dart';

class Airlines extends StatefulWidget {
  const Airlines({super.key});

  @override
  State<Airlines> createState() => _AirlinesState();
}

class _AirlinesState extends State<Airlines> {
  String selectedAirline = '...';

  @override
  void initState() {
    final provider = Provider.of<CommonProvider>(context, listen: false);

    provider.getDataFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CommonProvider>(context);

    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Airlines',
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      body:
          provider.isLoading
              ? loader()
              : provider.error.isNotEmpty
              ? errorScreen(provider.error)
              : Column(
                children: [
                  filters(provider),
                  Expanded(child: airlinesList(provider.flights.legs)),
                ],
              ),
    );
  }

  Widget loader() {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          SizedBox(height: 16),
          Text('Loading...', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget errorScreen(String error) {
    return Center(
      child: Text(error, style: TextStyle(color: Colors.red, fontSize: 18)),
    );
  }

  Widget filters(CommonProvider provider) {
    final airlines = [
      '...',
      ...provider.flights.legs.map((legs) => legs.airlineName).toSet(),
    ];

    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 10,
        bottom: 10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('Airline: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedAirline,
                  onChanged: (value) {
                    setState(() {
                      selectedAirline = value!;
                    });
                  },
                  items:
                      airlines
                          .map(
                            (airline) => DropdownMenuItem(
                              value: airline,
                              child: Text(airline),
                            ),
                          )
                          .toList(),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget airlinesList(List<Leg> legs) {
    var theme = Theme.of(context);

    final filteredAirlines =
        legs.where((legs) {
          final isAirlineValid = selectedAirline == '...';
          return isAirlineValid;
        }).toList();

    return ListView.builder(
      itemCount: filteredAirlines.length,
      itemBuilder: (context, index) {
        final leg = filteredAirlines[index];

        return Card(
          color: theme.colorScheme.secondary,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: ListTile(
            title: Text(
              leg.airlineName,
              style: TextStyle(
                color: theme.colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Departure: ${formatDate(leg.departureTime)} at ${leg.departureAirport}',
                  style: TextStyle(color: theme.colorScheme.onSecondary),
                ),
                Text(
                  'Arraival: ${formatDate(leg.arrivalTime)} at ${leg.arrivalAirport}',
                  style: TextStyle(color: theme.colorScheme.onSecondary),
                ),
                Text(
                  'Duration: ${leg.durationMins}m',
                  style: TextStyle(
                    color: theme.colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            trailing: Text(
              'Nro. of stops: ${leg.stops}',
              style: TextStyle(
                color: theme.colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        );
      },
    );
  }

  //> other functions
  String formatDate(String date) {
    DateTime formatDate = DateTime.parse(date);
    return DateFormat('dd/MM/yy').format(formatDate);
  }
}
