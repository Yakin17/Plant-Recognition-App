import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image/image.dart' as img;
import '../models/plant_model.dart';

class PlantNetService {
  static final String? _apiKey = dotenv.env['PLANTNET_API_KEY'];
  static final String _baseUrl = dotenv.env['PLANTNET_BASE_URL'] ?? 'https://my-api.plantnet.org/v2';

  static Future<PlantIdentificationResponse> identifyPlant(
    File imageFile, {
      String organ = 'auto',
    }
  ) async {
    if(_apiKey == null) {
      throw Exception('PlantNet API key not found');
    }

    //Preparer la requete
    var request = http.MultipartRequest('POST', 
    Uri.parse('$_baseUrl/identify/all?api-key=$_apiKey'),
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
