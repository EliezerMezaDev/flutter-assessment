import 'package:flight_app/models/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//? COMMON PROVIDER
import 'package:flight_app/provider/common.dart';

class Flights extends StatefulWidget {
  const Flights({super.key});

  @override
  State<Flights> createState() => _FlightsState();
}

class _FlightsState extends State<Flights> {
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
          'Flights',
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
              : (provider.error.isNotEmpty
                  ? errorScreen(provider.error)
                  : Column(
                    children: [
                      filterSection(provider),
                      Expanded(
                        child: flightsList(
                          provider.flights.itineraries,
                          provider.flights.legs,
                        ),
                      ),
                    ],
                  )),
    );
  }

  Widget loader() {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          const Text('Loading...', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  Widget errorScreen(String error) {
    return Center(
      child: Text(
        error,
        style: const TextStyle(color: Colors.red, fontSize: 20),
      ),
    );
  }

  Widget filterSection(CommonProvider provider) {
    final airlines = [
      '...',
      ...provider.flights.itineraries
          .map((itinerary) => itinerary.agent)
          .toSet(),
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
            spacing: 10,
            children: [
              Text('Agent: ', style: TextStyle(fontWeight: FontWeight.bold)),
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
            ],
          ),
        ],
      ),
    );
  }

  Widget flightsList(List<Itinerary> itineraries, List<Leg> legs) {
    var theme = Theme.of(context);

    final filteredItineraries =
        itineraries.where((itinerary) {
          final isAirlineValid =
              selectedAirline == '...' || itinerary.agent == selectedAirline;
          return isAirlineValid;
        }).toList();

    return ListView.builder(
      itemCount: filteredItineraries.length,
      itemBuilder: (context, index) {
        final itinerary = filteredItineraries[index];

        return Card(
          color: theme.colorScheme.secondary,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: ListTile(
            title: Text(
              '(${itinerary.price}) Flight #${itinerary.id}',
              style: TextStyle(
                color: theme.colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Agent: ${itinerary.agent}(${itinerary.agentRating}/10) ',
              style: TextStyle(color: theme.colorScheme.onSecondary),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              color: theme.cardColor,
              onPressed:
                  () => showDialog<String>(
                    context: context,
                    builder:
                        (BuildContext context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 30,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 12.0,
                                  ),
                                  child: Text(
                                    'Want to see more information about this flight?',
                                    style: theme.textTheme.titleLarge,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Close'),
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        //! NAV TO
                                      },
                                      child: const Text('See more'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                  ),
            ),
          ),
        );
      },
    );
  }
}
