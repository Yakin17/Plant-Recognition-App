import 'package:flutter/material.dart';
import 'package:plantrecognition_app/services/plantnet_service.dart';
import 'package:plantrecognition_app/models/plant_model.dart';
import 'package:plantrecognition_app/pages/plant_details_page.dart';

class ProjectSpeciesPage extends StatefulWidget {
  final PlantProject project;

  const ProjectSpeciesPage({super.key, required this.project});

  @override
  State<ProjectSpeciesPage> createState() => _ProjectSpeciesPageState();
}

class _ProjectSpeciesPageState extends State<ProjectSpeciesPage> {
  List<PlantSpecies> _species = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSpecies();
  }

  Future<void> _loadSpecies() async {
    try {
      final species = await PlantNetService.getProjectSpecies(widget.project.id);
      setState(() {
        _species = species;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading species: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _species.length,
              itemBuilder: (context, index) {
                final species = _species[index];
                return ListTile(
                  leading: const Icon(Icons.local_florist, color: Color(0xFF2E7D32)),
                  title: Text(species.scientificName),
                  subtitle: species.commonNames.isNotEmpty
                      ? Text(species.commonNames.join(', '))
                      : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantDetailsPage(speciesId: species.scientificName),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}