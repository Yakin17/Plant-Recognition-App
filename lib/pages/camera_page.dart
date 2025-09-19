import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        
        // Ici vous pouvez ajouter la logique pour traiter l'image
        // et l'envoyer à votre API de reconnaissance de plantes
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  void _processImage() {
    if (_selectedImage != null) {
      // Naviguer vers la page de résultats ou traiter l'image
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Traitement de l\'image en cours...')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une image d\'abord')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Identify Medicinal Plant',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        centerTitle: false,
      ),
      body: Container(
        color: const Color(0xFFF8F9FA),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instructions
            const Text(
              'Discover the healing properties of plants around you',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6C757D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Options de sélection d'image
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOptionCard(
                  Icons.photo_library,
                  'Upload File',
                  'Choose from gallery',
                  () => _pickImage(ImageSource.gallery),
                ),
                _buildOptionCard(
                  Icons.camera_alt,
                  'Take Photo',
                  'Use camera',
                  () => _pickImage(ImageSource.camera),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Aperçu de l'image sélectionnée
            if (_selectedImage != null)
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Selected Image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_florist,
                      size: 80,
                      color: const Color(0xFF2E7D32).withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No image selected',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6C757D),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            // Bouton Next
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _processImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Identify Plant'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: const Color(0xFF2E7D32).withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: const Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6C757D),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}