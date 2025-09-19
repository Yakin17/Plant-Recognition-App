import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image/image.dart' as img;
import '../models/plant_model.dart';

class PlantNetService {
  static final String? _apiKey = dotenv.env['PLANTNET_API_KEY'];
  static final String _baseUrl = dotenv.env['PLANTNET_BASE_URL'] ?? 'https://my-api.plantnet.org/v2';

  //Identification de plantes (deja existant)
  static Future<PlantIdentificationResponse> identifyPlant(
    File imageFile, {
      String organ = 'auto',
      String project = 'all',
    }
  ) async {
    if(_apiKey == null) {
      throw Exception('PlantNet API key not found');
    }

    //Preparer la requete
    var request = http.MultipartRequest('POST', 
    Uri.parse('$_baseUrl/identify/$project?api-key=$_apiKey'),
    );

    //Ajouter l'image
    var imageStream = http.ByteStream(imageFile.openRead());
    var imageLength = await imageFile.length();
    var multipartFile = http.MultipartFile(
      'images', 
      imageStream, 
      imageLength,
      filename: 'plant_image.jpg',
      );
      request.files.add(multipartFile);

      //Ajouter les parametres
      request.fields['organs'] = organ;

      //Envoyer la requete
      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseString);
        return PlantIdentificationResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to identify plant: ${response.statusCode} - $responseString');
      }
  }

  //Obtenir les especes d'un projet
  static Future<List<PlantSpecies>> getProjectSpecies(String project) async {
    if (_apiKey == null) {
      throw Exception('PlantNet API key not found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/projects/$project/species?api-keys=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return( data['species'] as List).map((e) => PlantSpecies.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load project species: ${response.statusCode}');
    }
  }

  //Obtenir les details d'une espece
  static Future<PlantSpeciesDetails> getSpeciesDetails(String speciesId) async {
    if (_apiKey == null) {
      throw Exception('PlantNet API key not found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/species/$speciesId?api-key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return PlantSpeciesDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load species details: ${response.statusCode}');
    }
  }

  //obtenir les images d'une espece
  static Future<List<PlantImage>> getSpeciesImages(String speciesId, {int limit = 10}) async {
    if (_apiKey == null) {
      throw Exception('PlantNet API key not found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/species/$speciesId/images?limit=$limit&api-key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['images'] as List).map((e) => PlantImage.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load species images: ${response.statusCode}');
    }
  }

  //obtenir la liste des projets
  static Future<List<PlantProject>> getProjects() async {
    if (_apiKey == null) {
      throw Exception('PlantNet API key not found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/projects?api-key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['projects'] as List).map((e) => PlantProject.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load projects: ${response.statusCode}');
    }
  }

  //rechercher des especes
 static Future<List<PlantSpecies>> searchSpecies(String query, {int limit = 10}) async {
  if (_apiKey == null) {
    throw Exception('PlantNet API key not found');
  }

  final response = await http.get(
    Uri.parse('$_baseUrl/species/search?q=${Uri.encodeQueryComponent(query)}&limit=$limit&api-key=$_apiKey'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return (data['species'] as List).map((e) => PlantSpecies.fromJson(e)).toList();
  } else {
    throw Exception('Failed to search species: ${response.statusCode} - ${response.body}');
  }
}


  //Methode pour compresse l'image si necessare
  static Future<File> compressImage(File imageFile) async {
    final originalImage = img.decodeImage(await imageFile.readAsBytes());
    if (originalImage == null) {
      return imageFile;
    }

    //Redimensionner l'image si elle est trop grande
    final resizedImage = img.copyResize(originalImage,width: 800);
    final compressedBytes = img.encodeJpg(resizedImage, quality: 85);

    //creer un fichier temporaire
    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/compressed_plant_image.jpg');
    await tempFile.writeAsBytes(compressedBytes);

    return tempFile;
  }
}
