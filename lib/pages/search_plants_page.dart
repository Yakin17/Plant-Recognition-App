import 'package:flutter/material.dart';
import 'package:plantrecognition_app/services/plantnet_service.dart';
import 'package:plantrecognition_app/models/plant_model.dart';
import 'package:plantrecognition_app/pages/plant_details_page.dart';

class SearchPlantsPage extends StatefulWidget {
  const SearchPlantsPage({super.key});

  @override
  State<SearchPlantsPage> createState() => _SearchPlantsPageState();
}

class _SearchPlantsPageState extends State<SearchPlantsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<PlantSpecies> _searchResults = [];
  bool _loading = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchPlants(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _loading = true;
      _hasSearched = true;
    });

    try {
      final results = await PlantNetService.searchSpecies(query, limit: 20);
      setState(() {
        _searchResults = results;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed: $e')),
      );
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults.clear();
      _hasSearched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Medicinal Plants',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for medicinal plants...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2E7D32)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF2E7D32)),
                        onPressed: _clearSearch,
                      )
                    : null,
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onSubmitted: _searchPlants,
              textInputAction: TextInputAction.search,
            ),
          ),

          // Résultats de recherche
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
                : _hasSearched
                    ? _searchResults.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  'No plants found',
                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                ),
                                Text(
                                  'Try a different search term',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final plant = _searchResults[index];
                              return _buildPlantItem(plant);
                            },
                          )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search, size: 64, color: Color(0xFF2E7D32)),
                            SizedBox(height: 16),
                            Text(
                              'Search for medicinal plants',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Enter the name of a plant to discover its medicinal properties',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantItem(PlantSpecies plant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.local_florist, color: Color(0xFF2E7D32)),
        ),
        title: Text(
          plant.scientificName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        subtitle: plant.commonNames.isNotEmpty
            ? Text(
                plant.commonNames.join(', '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF2E7D32)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantDetailsPage(speciesId: plant.scientificName),
            ),
          );
        },
      ),
    );
  }
}