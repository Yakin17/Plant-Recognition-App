class PlantIdentificationResponse{
  final List<PlantResult> results;
  final String version;

  PlantIdentificationResponse({required this.results, required this.version});
  
  factory PlantIdentificationResponse.fromJson(Map<String, dynamic> json) {
    final resultsList = (json['results'] as List?) ?? const [];
    final List<PlantResult> results = resultsList
        .whereType<Map<String, dynamic>>()
        .map((i) => PlantResult.fromJson(i))
        .toList();

    return PlantIdentificationResponse(
      results: results, 
      version: (json['version'] ?? '').toString(),
      );
  } 
}

class PlantResult {
  final double score;
  final PlantSpecies species;
  final List<PlantImage> images;

  PlantResult({required this.score, required this.species, required this.images});

  factory PlantResult.fromJson(Map<String, dynamic> json) {
    final imagesList = (json['images'] as List?) ?? const [];
    final List<PlantImage> images = imagesList
        .whereType<Map<String, dynamic>>()
        .map((i) => PlantImage.fromJson(i))
        .toList();

    return PlantResult(
    score: (json['score'] as num?)?.toDouble() ?? 0.0, 
    species: PlantSpecies.fromJson((json['species'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{}), 
    images: images,
    );

  }
}

class PlantSpecies {
  final String scientificName;
  final PlantGenus genus;
  final PlantFamily family;
  final List<String> commonNames;

  PlantSpecies({required this.scientificName, required this.genus, required this.family, required this.commonNames});

  factory PlantSpecies.fromJson(Map<String, dynamic> json) {
    final commonNamesList = (json['commonNames'] as List?) ?? const [];
    final List<String> commonNames = commonNamesList.map((i) => i.toString()).toList();

    return PlantSpecies(
      scientificName: (json['scientificName'] ?? '').toString(),
      genus: PlantGenus.fromJson((json['genus'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{}),
      family: PlantFamily.fromJson((json['family'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{}),
      commonNames: commonNames,
    );
  }
}
class PlantGenus{
  final String scientificName;
  PlantGenus({required this.scientificName});

  factory PlantGenus.fromJson(Map<String, dynamic> json) {
    return PlantGenus(
      scientificName: (json['scientificName'] ?? '').toString(),
    );
  }
}

class PlantFamily {
  final String scientificName;
  PlantFamily({required this.scientificName});

  factory PlantFamily.fromJson(Map<String, dynamic> json) {
    return PlantFamily(scientificName: (json['scientificName'] ?? '').toString()
    );
  }
}

class PlantImage {
  final String organ;
  final PlantImageUrl url;

  PlantImage({required this.organ, required this.url});

  factory PlantImage.fromJson(Map<String, dynamic> json) {
    return PlantImage(
      organ: (json['organ'] ?? '').toString(),
      url:PlantImageUrl.fromJson((json['url'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{}),
    );
  }
}

class PlantImageUrl {
  final String original;
  final String medium;
  final String small;

  PlantImageUrl({required this.original, required this.medium, required this.small});

  factory PlantImageUrl.fromJson(Map<String, dynamic> json) {
    return PlantImageUrl(
      original: (json['o'] ?? '').toString(),
      medium: (json['m'] ?? '').toString(),
      small: (json['s'] ?? '').toString(),
    );
  }
}

class PlantSpeciesDetails {
  final String id;
  final String scientificName;
  final PlantGenus genus;
  final PlantFamily family;
  final List<String> commonNames;
  final String? description;
  final String? medicinalUses;
  final String? habitat;
  final Map<String, dynamic>? gbif;

  PlantSpeciesDetails({
    required this.id,
    required this.scientificName,
    required this.genus,
    required this.family,
    required this.commonNames,
    this.description,
    this.medicinalUses,
    this.habitat,
    this.gbif,
  });

  factory PlantSpeciesDetails.fromJson(Map<String, dynamic> json) {
    var commonNamesList = json['commonNames'] as List;
    List<String> commonNames = commonNamesList.map((i) => i.toString()).toList();

    return PlantSpeciesDetails(
      id: json['id'],
      scientificName: json['scientificName'],
      genus: PlantGenus.fromJson(json['genus']),
      family:PlantFamily.fromJson(json['family']),
      commonNames: commonNames,
      description: json['description'],
      medicinalUses: json['medidinalUses'],
      habitat: json['habitat'],
      gbif: json['gbif'],
    );
  }
}

class PlantProject {
  final String id;
  final String name;
  final String? description;
  final int speciesCount;
  final int imageCount;

  PlantProject({
    required this.id,
    required this.name,
    this.description,
    required this.speciesCount,
    required this.imageCount,
  });

  factory PlantProject.fromJson(Map<String, dynamic> json) {
    final dynamic speciesCountRaw = json['speciesCount'];
    final dynamic imageCountRaw = json['imageCount'];

    int parseToInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
        final parsedDouble = double.tryParse(value);
        if (parsedDouble != null) return parsedDouble.toInt();
      }
      return 0;
    }

    return PlantProject(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'])?.toString(),
      speciesCount: parseToInt(speciesCountRaw),
      imageCount: parseToInt(imageCountRaw),
    );
  }
}