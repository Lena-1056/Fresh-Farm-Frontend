import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/farmer_provider.dart';
import '../../models/farmer_model.dart';

class EditFarmerProfileScreen extends StatefulWidget {
  const EditFarmerProfileScreen({super.key});

  @override
  State<EditFarmerProfileScreen> createState() =>
      _EditFarmerProfileScreenState();
}

class _EditFarmerProfileScreenState extends State<EditFarmerProfileScreen> {
  late TextEditingController ownerController;
  late TextEditingController farmNameController;
  late TextEditingController locationController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController mainCropsController;
  late TextEditingController aboutController;

  FarmerModel? farmer;

  final Color primaryColor = const Color(0xFF0DF20D);

  String? selectedFarmingType;
  String? selectedFarmSize;
  String? selectedIrrigation;
  String? selectedHarvestFrequency;

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage; // ✅ Only one image

  final List<String> farmingTypes = [
    "Organic",
    "Conventional",
    "Natural Farming",
    "Hydroponic",
    "Mixed Farming",
  ];

  final List<String> farmSizes = [
    "Below 1 Acre",
    "1 – 5 Acres",
    "5 – 10 Acres",
    "10 – 25 Acres",
    "25+ Acres",
  ];

  final List<String> irrigationTypes = [
    "Drip Irrigation",
    "Sprinkler Irrigation",
    "Canal Irrigation",
    "Borewell",
    "Rain-fed",
  ];

  final List<String> harvestFrequencies = [
    "Weekly",
    "Bi-Weekly",
    "Monthly",
    "Seasonal",
    "On Demand",
  ];

  @override
  void initState() {
    super.initState();

    final provider = context.read<FarmerProvider>();
    farmer = provider.farmer;

    ownerController = TextEditingController(text: farmer?.ownerName ?? "");
    farmNameController = TextEditingController(text: farmer?.farmName ?? "");
    locationController = TextEditingController(text: farmer?.location ?? "");
    emailController = TextEditingController(text: farmer?.email ?? "");
    phoneController = TextEditingController(text: farmer?.phone ?? "");
    mainCropsController = TextEditingController(text: farmer?.mainCrops ?? "");
    aboutController = TextEditingController();

    selectedFarmingType = farmer?.farmingType;
    selectedFarmSize = farmer?.farmSize;
    selectedIrrigation = farmer?.irrigation;
    selectedHarvestFrequency = farmer?.harvestFrequency;
  }

  /// ================= IMAGE PICKER FUNCTION =================
  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path); // Only one image stored
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<FarmerProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// ================= IMAGE SELECTION BOX =================
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    child: _selectedImage == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ================= BASIC INFO =================
            _sectionTitle("Basic Information"),
            _card([
              _field(ownerController, "Owner Name", readOnly: true),
              _locationField(),
              _field(emailController, "Email", readOnly: true),
              _field(phoneController, "Phone"),
            ]),

            const SizedBox(height: 25),

            /// ================= FARM DETAILS =================
            _sectionTitle("Farm Details"),
            _card([
              _field(farmNameController, "Farm Name"),
              _dropdown(
                "Farming Type",
                selectedFarmingType,
                farmingTypes,
                (val) => setState(() => selectedFarmingType = val),
              ),

              _dropdown(
                "Farm Size",
                selectedFarmSize,
                farmSizes,
                (val) => setState(() => selectedFarmSize = val),
              ),

              _dropdown(
                "Irrigation Type",
                selectedIrrigation,
                irrigationTypes,
                (val) => setState(() => selectedIrrigation = val),
              ),

              _dropdown(
                "Harvest Frequency",
                selectedHarvestFrequency,
                harvestFrequencies,
                (val) => setState(() => selectedHarvestFrequency = val),
              ),

              _field(mainCropsController, "Main Crops"),
              _field(aboutController, "About Farm", maxLines: 3),
            ]),

            const SizedBox(height: 35),

            /// ================= SAVE BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  final updated = FarmerModel(
                    ownerName: farmer?.ownerName ?? ownerController.text,
                    farmName: farmNameController.text,
                    location: locationController.text,
                    email: farmer?.email ?? emailController.text,
                    phone: phoneController.text,
                    farmingType: selectedFarmingType ?? "",
                    farmSize: selectedFarmSize ?? "",
                    irrigation: selectedIrrigation ?? "",
                    mainCrops: mainCropsController.text,
                    harvestFrequency: selectedHarvestFrequency ?? "",
                    isAvailable: farmer?.isAvailable ?? true,
                  );
                  try {
                    await provider.saveProfile(updated);
                    if (mounted) Navigator.pop(context);
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to save: ${e.toString().replaceFirst('Exception: ', '')}")),
                      );
                    }
                  }
                },
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= LOCATION FIELD =================
  Widget _locationField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: locationController,
        decoration: InputDecoration(
          labelText: "Location",
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// ================= UI HELPERS =================
  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: Column(children: children),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
