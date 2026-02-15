import 'package:flutter/material.dart';
import '../models/farmer_model.dart';

class FarmerProvider extends ChangeNotifier {
  FarmerModel _farmer = FarmerModel(
    ownerName: "Farmer Joe",
    farmName: "Green Valley Farms",
    location: "Willow Creek, OR",
    email: "farmer@email.com",
    phone: "+91 9876543210",
    farmingType: "Organic",
    farmSize: "5 Acres",
    irrigation: "Drip Irrigation",
    mainCrops: "Carrots, Tomatoes",
    harvestFrequency: "Weekly",
    isAvailable: true,
  );
  //FarmerModel? _farmer;
  //   FarmerModel? get farmer => _farmer;
  FarmerModel get farmer => _farmer;

  void initializeFarmer({required String name, required String email}) {
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
