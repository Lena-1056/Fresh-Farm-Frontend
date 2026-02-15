class FarmerModel {
  String ownerName;
  String farmName;
  String location;
  String email;
  String phone;
  String farmingType;
  String farmSize;
  String irrigation;
  String mainCrops;
  String harvestFrequency;
  bool isAvailable;
  String? profileImagePath; // ✅ ADD THIS

  FarmerModel({
    required this.ownerName,
    required this.farmName,
    required this.location,
    required this.email,
    required this.phone,
    required this.farmingType,
    required this.farmSize,
    required this.irrigation,
    required this.mainCrops,
    required this.harvestFrequency,
    required this.isAvailable,
    this.profileImagePath,
  });
}
