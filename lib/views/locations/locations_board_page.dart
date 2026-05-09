import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/voiture_provider.dart';

class LocationsBoardPage extends StatelessWidget {
  const LocationsBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bp = context.watch<BookingProvider>();
    final vp = context.watch<VoitureProvider>();
    final revenu = bp.getRevenuDuMois();
    final locsMois = bp.getLocationsDuMois();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord Admin'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistiques du mois
            const Text('Statistiques du mois',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _DashCard('Locations', '${locsMois.length}', Icons.car_rental, Colors.blue),
                _DashCard('Revenu', '${revenu.toStringAsFixed(0)} TND',
                    Icons.attach_money, Colors.green),
                _DashCard('Libres', '${vp.voituresLibres.length}',
                    Icons.directions_car, Colors.orange),
              ],
            ),
            const SizedBox(height: 24),
            // Tableau 3 colonnes: voitures
            const Text('État des voitures',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.blue.shade50),
                  children: const [
                    _TH('Voiture'), _TH('Statut'), _TH('Chauffeur'),
                  ],
                ),
                ...vp.voitures.map((v) => TableRow(
                  children: [
                    _TD('${v.marque} ${v.modele}'),
                    _TDColored(v.estLouee ? 'Loué' : 'Libre',
                        v.estLouee ? Colors.orange : Colors.green),
                    _TD(v.avecChauffeur ? 'Oui' : 'Non'),
                  ],
                )),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Locations actives',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...bp.locations.map((l) => Card(
              child: ListTile(
                leading: const Icon(Icons.receipt_long, color: Colors.blue),
                title: Text('Voiture: ${l.voitureId.substring(0, 6)}...'),
                subtitle: Text(
                    '${l.dateDebut.toString().substring(0, 10)} → ${l.dateFin.toString().substring(0, 10)}'),
                trailing: Text('${l.prixTotal.toStringAsFixed(0)} TND',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _DashCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;

  const _DashCard(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TH extends StatelessWidget {
  final String text;
  const _TH(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}

class _TD extends StatelessWidget {
  final String text;
  const _TD(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(text, style: const TextStyle(fontSize: 12)));
  }
}

class _TDColored extends StatelessWidget {
  final String text;
  final Color color;
  const _TDColored(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text,
            style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
      ),
    );
  }
}