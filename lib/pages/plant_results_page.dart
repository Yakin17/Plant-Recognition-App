import 'package:flutter/material.dart';
import 'package:plantrecognition_app/models/plant_model.dart';

class PlantResultsPage extends StatelessWidget {

  final PlantIdentificationResponse identificationResult;


  const PlantResultsPage({super.key, required this.identificationResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identification Results'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: ListView.builder(
        itemCount: identificationResult.results.length,
        itemBuilder: (context, index) {
          final result = identificationResult.results[index];
          return _buildPlantCard(result);
        },
      ),
    );
  }

  Widget _buildPlantCard(PlantResult result) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.species.scientificName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 8),
            if(result.species.commonNames.isNotEmpty)
            Text(
              'Common names: ${result.species.commonNames.join(',')}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Family: ${result.species.family.scientificName}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Confidence: ${(result.score * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                color: result.score > 0.7 ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            )
          ]
        ),
      ),
    );
  }
}