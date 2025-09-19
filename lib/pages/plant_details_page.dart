import 'package:flutter/material.dart';
import 'package:plantrecognition_app/services/plantnet_service.dart';
import 'package:plantrecognition_app/models/plant_model.dart';

class PlantDetailsPage extends StatefulWidget {
  final String speciesId;
  const PlantDetailsPage({super.key, required this.speciesId});

  @override
  State<PlantDetailsPage> createState() => _PlantDetailsPageState();
}

class _PlantDetailsPageState extends State<PlantDetailsPage> {
  PlantSpeciesDetails? _speciesDetails;
  bool _loading = true;

  @override
  void initState(){
    super.initState();
    _loadSpeciesDetails();
  }

  Future<void> _loadSpeciesDetails() async{
    try{
      final details = await PlantNetService.getSpeciesDetails(widget.speciesId);
      setState(() {
        _speciesDetails = details;
        _loading = false;
      });

    } catch(e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading species details: $e')),
      );

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Details'),
        backgroundColor: const Color(0xFF2E7D32),

      ),
      body: _loading
      ? const Center(child: CircularProgressIndicator())
      : _speciesDetails == null
        ? const Center(child: Text('No details available'),)
        : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _speciesDetails!.scientificName,
                style: const TextStyle(fontSize:24, fontWeight:FontWeight.bold),

              ),
              const SizedBox(height: 8),
              if(_speciesDetails!.commonNames.isNotEmpty)
                Text(
                  'Common names: ${_speciesDetails!.commonNames.join(',')}',
                  style: const TextStyle(fontSize:16), 
                ),
                const SizedBox(height: 16),
                if(_speciesDetails!.medicinalUses != null)
                  Text(
                    'Medicinal uses: ${_speciesDetails!.medicinalUses}',
                    style: const TextStyle(fontSize: 16),
                  )

            ],
          )
          )
      ,
    );
  }
}