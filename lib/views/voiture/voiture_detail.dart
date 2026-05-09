import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/voiture.dart';
import '../../providers/booking_provider.dart';
import '../locations/add_location_page.dart';

class VoitureDetailPage extends StatelessWidget {
  final Voiture voiture;

  const VoitureDetailPage({super.key, required this.voiture});

  @override
  Widget build(BuildContext context) {
    final bp = context.watch<BookingProvider>();
    final activeLocation = bp.locations
        .where((l) => l.voitureId == voiture.id)
        .isNotEmpty
        ? bp.locations.firstWhere((l) => l.voitureId == voiture.id)
        : null;

    return Scaffold(
      appBar: AppBar(title: Text('${voiture.marque} ${voiture.modele}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.directions_car,
                size: 80,
                color: voiture.estLouee ? Colors.orange : Colors.green),
            const SizedBox(height: 16),
            _InfoRow('Marque', voiture.marque),
            _InfoRow('Modèle', voiture.modele),
            _InfoRow('Année', '${voiture.annee}'),
            _InfoRow('Immatriculation', voiture.immat),
            _InfoRow('Places', '${voiture.places}'),
            _InfoRow('Prix/jour', '${voiture.prixJour} TND'),
            _InfoRow('Caution', '${voiture.caution} TND'),
            _InfoRow('Statut', voiture.estLouee ? 'Loué' : 'Disponible'),
            if (voiture.estLouee && activeLocation != null) ...[
              const Divider(height: 32),
              const Text('Détails de la location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _InfoRow('Début', activeLocation.dateDebut.toString().substring(0, 10)),
              _InfoRow('Fin', activeLocation.dateFin.toString().substring(0, 10)),
              _InfoRow('Durée', '${activeLocation.dureeJours} jours'),
              _InfoRow('Prix total', '${activeLocation.prixTotal} TND'),
            ],
            const Spacer(),
            if (!voiture.estLouee)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) => AddLocationPage(voiture: voiture))),
                  icon: const Icon(Icons.book_online),
                  label: const Text('Réserver cette voiture'),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 140,
              child: Text(label,
                  style: TextStyle(color: Colors.grey.shade600))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}