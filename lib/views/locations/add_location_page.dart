import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/voiture.dart';
import '../../models/location.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';

class AddLocationPage extends StatefulWidget {
  final Voiture voiture;
  const AddLocationPage({super.key, required this.voiture});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  DateTime _debut = DateTime.now();
  DateTime _fin = DateTime.now().add(const Duration(days: 1));
  final _priseCtrl = TextEditingController();
  final _restitCtrl = TextEditingController();
  bool _loading = false;

  double get _prixTotal =>
      _fin.difference(_debut).inDays * widget.voiture.prixJour;

  Future<void> _pickDate(bool isDebut) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isDebut ? _debut : _fin,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() => isDebut ? _debut = picked : _fin = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle réservation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.voiture.marque} ${widget.voiture.modele}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickDate(true),
                    icon: const Icon(Icons.calendar_today),
                    label: Text('Début: ${_debut.toString().substring(0, 10)}'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickDate(false),
                    icon: const Icon(Icons.calendar_month),
                    label: Text('Fin: ${_fin.toString().substring(0, 10)}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priseCtrl,
              decoration: const InputDecoration(
                  labelText: 'Lieu de prise du véhicule',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _restitCtrl,
              decoration: const InputDecoration(
                  labelText: 'Lieu de restitution',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Prix total estimé',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${_prixTotal.toStringAsFixed(2)} TND',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800)),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : () async {
                  setState(() => _loading = true);
                  final uid = context.read<AuthProvider>().user?.uid ?? '';
                  final loc = Location(
                    id: '',
                    clientId: uid,
                    voitureId: widget.voiture.id,
                    dateDebut: _debut,
                    dateFin: _fin,
                    priseVehicule: _priseCtrl.text,
                    restitutionVehicule: _restitCtrl.text,
                    prixTotal: _prixTotal,
                  );
                  await context.read<BookingProvider>().addLocation(loc);
                  if (mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14)),
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Confirmer la réservation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}