class ProfileResponse {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? farmName;
  final String? location;
  final String? farmingType;
  final String? farmSize;
  final String? irrigation;
  final String? mainCrops;
  final String? harvestFrequency;
  final bool isAvailable;

  ProfileResponse({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.farmName,
    this.location,
    this.farmingType,
    this.farmSize,
    this.irrigation,
    this.mainCrops,
    this.harvestFrequency,
    this.isAvailable = true,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      farmName: json['farmName'] as String?,
      location: json['location'] as String?,
      farmingType: json['farmingType'] as String?,
      farmSize: json['farmSize'] as String?,
      irrigation: json['irrigation'] as String?,
      mainCrops: json['mainCrops'] as String?,
      harvestFrequency: json['harvestFrequency'] as String?,
      isAvailable: json['isAvailable'] == true,
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      if (phone != null) 'phone': phone,
      if (farmName != null) 'farmName': farmName,
      if (location != null) 'location': location,
      if (farmingType != null) 'farmingType': farmingType,
      if (farmSize != null) 'farmSize': farmSize,
      if (irrigation != null) 'irrigation': irrigation,
      if (mainCrops != null) 'mainCrops': mainCrops,
      if (harvestFrequency != null) 'harvestFrequency': harvestFrequency,
      'isAvailable': isAvailable,
    };
  }
}
