import 'package:flutter/material.dart';
import 'package:plantrecognition_app/services/plantnet_service.dart';
import 'package:plantrecognition_app/models/plant_model.dart';
import 'package:plantrecognition_app/pages/project_species_page.dart';

class ExplorePlantsPage extends StatefulWidget {
  const ExplorePlantsPage({super.key});

  @override
  State<ExplorePlantsPage> createState() => _ExplorePlantsPageState();
}

class _ExplorePlantsPageState extends State<ExplorePlantsPage> {
  List<PlantProject> _projects = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    try {
      final projects = await PlantNetService.getProjects();
      setState(() {
        _projects = projects;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading projects: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Medicinal Plants'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search plants in this project...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2E7D32)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFCED4DA)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                // Implémentez la recherche filtrée si nécessaire
              },
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _projects.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.local_florist, color: Color(0xFF2E7D32)),
                        title: Text(_projects[index].name),
                        subtitle: Text('${_projects[index].speciesCount} species'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectSpeciesPage(project: _projects[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}