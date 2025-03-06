import 'package:flight_app/models/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Flight extends StatelessWidget {
  final Itinerary itinerary;
  final List<Leg> legs;

  const Flight({required this.itinerary, required this.legs, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flight #${itinerary.id}',
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text(
              itinerary.agent,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text('Rating: ', style: const TextStyle(fontSize: 14)),
                Text(
                  "${itinerary.agentRating}/10",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('Price: ', style: const TextStyle(fontSize: 14)),
                Text(
                  itinerary.price,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // AgentInfoRow(itinerary: itinerary),
            const Text(
              'Legs:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: legs.length,
                itemBuilder: (context, index) {
                  final leg = legs[index];

                  return LegCard(leg: leg);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LegCard extends StatelessWidget {
  const LegCard({super.key, required this.leg});

  final Leg leg;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.secondary,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Departure airport: ',
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
                Text(
                  leg.departureAirport,
                  style: TextStyle(
                    color: theme.colorScheme.onSecondary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Arrival airport: ',
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
                Text(
                  leg.arrivalAirport,
                  style: TextStyle(
                    color: theme.colorScheme.onSecondary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Duration: ${leg.durationMins} mins',
              style: TextStyle(color: theme.colorScheme.onSecondary),
            ),
            Text(
              'Nro. of stops:: ${leg.stops}',
              style: TextStyle(color: theme.colorScheme.onSecondary),
            ),
            Text(
              'Departure: ${formatDate(leg.departureTime)}',
              style: TextStyle(color: theme.colorScheme.onSecondary),
            ),
            Text(
              'Arrival: ${formatDate(leg.arrivalTime)}',
              style: TextStyle(color: theme.colorScheme.onSecondary),
            ),
          ],
        ),
      ),
    );
  }

  //> other functions
  String formatDate(String date) {
    DateTime formatDate = DateTime.parse(date);
    return DateFormat('dd/MM/yy hh:mm').format(formatDate);
  }
}
