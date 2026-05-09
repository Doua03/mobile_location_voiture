import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/voiture_provider.dart';
import '../../models/voiture.dart';
import 'voiture_detail.dart';
import '../locations/locations_board_page.dart';

class VoituresListPage extends StatelessWidget {
  const VoituresListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final vp = context.watch<VoitureProvider>();
    final isAdmin = auth.role == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voitures disponibles'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.dashboard),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LocationsBoardPage())),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tableau des états (3 colonnes)
          Container(
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                _StatCard('Libres', vp.voituresLibres.length, Colors.green),
                _StatCard('Louées', vp.voituresLouees.length, Colors.orange),
                _StatCard('Total', vp.voitures.length, Colors.blue),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: vp.voitures.length,
              itemBuilder: (ctx, i) {
                final v = vp.voitures[i];
                return _VoitureCard(v, isAdmin: isAdmin);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () => _showVoitureForm(context, null),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showVoitureForm(BuildContext context, Voiture? existing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => VoitureFormSheet(voiture: existing),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatCard(this.label, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text('$count',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color)),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _VoitureCard extends StatelessWidget {
  final Voiture v;
  final bool isAdmin;

  const _VoitureCard(this.v, {this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Icon(
          Icons.directions_car,
          color: v.estLouee ? Colors.orange : Colors.green,
          size: 36,
        ),
        title: Text('${v.marque} ${v.modele} (${v.annee})',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${v.prixJour} TND/jour · Caution: ${v.caution} TND'),
            Row(
              children: [
                _Badge(v.estLouee ? 'Loué' : 'Libre',
                    v.estLouee ? Colors.orange : Colors.green),
                const SizedBox(width: 4),
                _Badge(v.avecChauffeur ? 'Avec chauffeur' : 'Sans chauffeur',
                    Colors.blue),
              ],
            ),
          ],
        ),
        trailing: isAdmin
            ? PopupMenuButton(
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('Modifier')),
                  const PopupMenuItem(
                      value: 'delete', child: Text('Supprimer')),
                ],
                onSelected: (val) {
                  if (val == 'delete') {
                    context.read<VoitureProvider>().deleteVoiture(v.id);
                  } else if (val == 'edit') {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => VoitureFormSheet(voiture: v),
                    );
                  }
                },
              )
            : null,
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => VoitureDetailPage(voiture: v))),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, color: color)),
    );
  }
}

// Formulaire ajout/modification voiture
class VoitureFormSheet extends StatefulWidget {
  final Voiture? voiture;
  const VoitureFormSheet({super.key, this.voiture});

  @override
  State<VoitureFormSheet> createState() => _VoitureFormSheetState();
}

class _VoitureFormSheetState extends State<VoitureFormSheet> {
  late final TextEditingController _marque, _modele, _annee,
      _immat, _places, _prix, _caution;

  @override
  void initState() {
    super.initState();
    final v = widget.voiture;
    _marque  = TextEditingController(text: v?.marque ?? '');
    _modele  = TextEditingController(text: v?.modele ?? '');
    _annee   = TextEditingController(text: v?.annee.toString() ?? '');
    _immat   = TextEditingController(text: v?.immat ?? '');
    _places  = TextEditingController(text: v?.places.toString() ?? '');
    _prix    = TextEditingController(text: v?.prixJour.toString() ?? '');
    _caution = TextEditingController(text: v?.caution.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16, right: 16, top: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.voiture == null ? 'Ajouter une voiture' : 'Modifier la voiture',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...[
              ('Marque', _marque), ('Modèle', _modele), ('Année', _annee),
              ('Immatriculation', _immat), ('Places', _places),
              ('Prix/jour (TND)', _prix), ('Caution (TND)', _caution),
            ].map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: e.$2,
                decoration: InputDecoration(
                    labelText: e.$1, border: const OutlineInputBorder()),
              ),
            )),
            ElevatedButton(
              onPressed: () {
                final vp = context.read<VoitureProvider>();
                final data = Voiture(
                  id: widget.voiture?.id ?? '',
                  marque: _marque.text,
                  modele: _modele.text,
                  annee: int.tryParse(_annee.text) ?? 0,
                  immat: _immat.text,
                  places: int.tryParse(_places.text) ?? 0,
                  prixJour: double.tryParse(_prix.text) ?? 0,
                  caution: double.tryParse(_caution.text) ?? 0,
                );
                if (widget.voiture == null) {
                  vp.addVoiture(data);
                } else {
                  vp.updateVoiture(data);
                }
                Navigator.pop(context);
              },
              child: Text(widget.voiture == null ? 'Ajouter' : 'Enregistrer'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}