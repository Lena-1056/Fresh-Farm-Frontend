import 'package:flutter/material.dart';
import '../models/farmer_model.dart';
import '../services/api_service.dart';

class FarmerProvider extends ChangeNotifier {
  FarmerModel _farmer = FarmerModel(
    ownerName: "",
    farmName: "",
    location: "",
    email: "",
    phone: "",
    farmingType: "",
    farmSize: "",
    irrigation: "",
    mainCrops: "",
    harvestFrequency: "",
    isAvailable: true,
  );

  FarmerModel get farmer => _farmer;

  /// Call after farmer login/register: show name and email on profile, rest empty.
  void initializeFromAuth({required String name, required String email}) {
    _farmer = FarmerModel(
      ownerName: name,
      email: email,
      farmName: "",
      location: "",
      phone: "",
      farmingType: "",
      farmSize: "",
      irrigation: "",
      mainCrops: "",
      harvestFrequency: "",
      isAvailable: true,
    );
    notifyListeners();
  }

  /// Load profile from database (after edit, details will appear here).
  Future<void> loadProfile() async {
    try {
      final res = await ApiService.getProfile();
      _farmer = FarmerModel(
        ownerName: res.name,
        email: res.email,
        farmName: res.farmName ?? "",
        location: res.location ?? "",
        phone: res.phone ?? "",
        farmingType: res.farmingType ?? "",
        farmSize: res.farmSize ?? "",
        irrigation: res.irrigation ?? "",
        mainCrops: res.mainCrops ?? "",
        harvestFrequency: res.harvestFrequency ?? "",
        isAvailable: res.isAvailable,
      );
      notifyListeners();
    } catch (_) {
      // Keep current _farmer if API fails (e.g. first time)
    }
  }

  /// Save profile to database; then update local state from response.
  Future<void> saveProfile(FarmerModel updated) async {
    final res = await ApiService.updateProfile({
      "phone": updated.phone.isEmpty ? null : updated.phone,
      "farmName": updated.farmName.isEmpty ? null : updated.farmName,
      "location": updated.location.isEmpty ? null : updated.location,
      "farmingType": updated.farmingType.isEmpty ? null : updated.farmingType,
      "farmSize": updated.farmSize.isEmpty ? null : updated.farmSize,
      "irrigation": updated.irrigation.isEmpty ? null : updated.irrigation,
      "mainCrops": updated.mainCrops.isEmpty ? null : updated.mainCrops,
      "harvestFrequency": updated.harvestFrequency.isEmpty ? null : updated.harvestFrequency,
      "isAvailable": updated.isAvailable,
    });
    _farmer = FarmerModel(
      ownerName: res.name,
      email: res.email,
      farmName: res.farmName ?? "",
      location: res.location ?? "",
      phone: res.phone ?? "",
      farmingType: res.farmingType ?? "",
      farmSize: res.farmSize ?? "",
      irrigation: res.irrigation ?? "",
      mainCrops: res.mainCrops ?? "",
      harvestFrequency: res.harvestFrequency ?? "",
      isAvailable: res.isAvailable,
    );
    notifyListeners();
  }

  void updateFarmer(FarmerModel updatedFarmer) {
    _farmer = updatedFarmer;
    notifyListeners();
  }

  void toggleAvailability(bool value) {
    _farmer.isAvailable = value;
    notifyListeners();
  }

  void logout() {
    _farmer = FarmerModel(
      ownerName: "",
      farmName: "",
      location: "",
      email: "",
      phone: "",
      farmingType: "",
      farmSize: "",
      irrigation: "",
      mainCrops: "",
      harvestFrequency: "",
      isAvailable: false,
    );
    notifyListeners();
  }
}
