import 'package:chaudiere_mobile/models/evenement_provider.dart';
import 'package:flutter/material.dart';

class EvenementsMaster extends StatefulWidget {
  const EvenementsMaster({super.key});

  @override
  State<EvenementsMaster> createState() => _EvenementsMasterState();
}

class _EvenementsMasterState extends State<EvenementsMaster> {
  EvenementProvider evenementProvider = EvenementProvider();

  @override
  void initState() {
    super.initState();
    evenementProvider.fetchEvenements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: evenementProvider.evenements,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found.'));
          } else {
            final evenements = snapshot.data!;
            return ListView.builder(
              itemCount: evenements.length,
              itemBuilder: (context, index) {
                final evenement = evenements[index];
                return ListTile(
                  title: Text(evenement.titre),
                  subtitle: Text(evenement.description_md),
                  trailing: Text('\$${evenement.tarif.toStringAsFixed(2)}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
