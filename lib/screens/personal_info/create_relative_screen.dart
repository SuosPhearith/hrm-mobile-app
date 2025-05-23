import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/sample_provider.dart';
import 'package:mobile_app/services/personal_info/create_service.dart';
import 'package:provider/provider.dart';

class CreateRelativeScreen extends StatefulWidget {
  const CreateRelativeScreen({super.key, this.id});
  final String? id;
  @override
  State<CreateRelativeScreen> createState() => _CreateRelativeScreenState();
}

class _CreateRelativeScreenState extends State<CreateRelativeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(SampleProvider provider) async {
    return await provider.getHome();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final CreatePersonalService _service = CreatePersonalService();
  final TextEditingController _relativeTypeController =
      TextEditingController(); // ត្រូវជា
  final TextEditingController _jobController =
      TextEditingController(); // មុខរបរ
  final TextEditingController _workPlaceController =
      TextEditingController(); // ស្ថាប័ន
  final TextEditingController _noteController =
      TextEditingController(); // ចំណាំ

  // Variables to store selected IDs
  String? selectedRelativeTypeId;
  String? selectedJobId;
  String? selectedWorkPlaceId;

  String? selectedGender;
  String? selectedProvince;
  String? selectedDistrict;

 void _handleSubmit() async {
  if (!_formKey.currentState!.validate()) return;

  // Validate required fields
  if (_firstNameController.text.isEmpty ||
      _lastNameController.text.isEmpty ||
      selectedGender == null) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('សូមបំពេញព័ត៌មានចាំបាច់')),
    );
    return;
  }

  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final result = await _service.createUserFamily(
      userId: widget.id ?? '',
      nameKh: _firstNameController.text.trim(),
      nameEn: _lastNameController.text.trim(),
      sexId: selectedGender ?? '',
      dob: _dobController.text.isNotEmpty ? _dobController.text.trim() : null,
      familyRoleId: selectedRelativeTypeId,
      job: selectedJobId,
      workPlace: selectedWorkPlaceId,
      note: _noteController.text.isNotEmpty ? _noteController.text.trim() : null,
    );

    if (!mounted) return;
    Navigator.of(context).pop(); // Close loading dialog
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('បង្កើតបានជោគជ័យ')),
    );

    Navigator.of(context).pop(result); // Return to previous screen
  } on DioException catch (dioError) {
    if (!mounted) return;
    Navigator.of(context).pop(); // Close loading dialog
    
    String errorMessage = 'បញ្ហាក្នុងការបង្កើត';
    if (dioError.response?.data != null) {
      errorMessage += ': ${dioError.response?.data['message'] ?? ''}';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  } catch (e) {
    if (!mounted) return;
    Navigator.of(context).pop(); // Close loading dialog
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('បញ្ហាមិនដឹងមូលហេតុ: ${e.toString()}')),
    );
  }
}

  @override
  void dispose() {
    _dobController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _relativeTypeController.dispose();
    _jobController.dispose();
    _workPlaceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text = "${picked.toLocal()}".split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => SampleProvider(),
        child: Consumer2<SampleProvider, SettingProvider>(
            builder: (context, evaluateProvider, settingProvider, child) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text(
                  AppLang.translate(lang: 'kh', key: 'user_info_family_add')),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.blue[800],
              backgroundColor: Colors.white,
              onRefresh: () => _refreshData(evaluateProvider),
              child: evaluateProvider.isLoading
                  ? Center(child: Text('Loading...'))
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              // ត្រូវជា (Relative Type)
                              TextFormField(
                                controller: _relativeTypeController,
                                readOnly: true,
                                onTap: () async {
                                  await _showSelectionBottomSheet(
                                    context: context,
                                    title: 'Select Relative Type',
                                    items: relativeTypes,
                                    onSelected: (id, value) {
                                      setState(() {
                                        selectedRelativeTypeId = id;
                                        _relativeTypeController.text = value;
                                      });
                                    },
                                  );
                                },
                                decoration: const InputDecoration(
                                  labelText: 'ត្រូវជា',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: const Text('ប្រុស'),
                                      value: '1',
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() => selectedGender = value);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: const Text('ស្រី'),
                                      value: '2',
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() => selectedGender = value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              // ឈ្មោះជាភាសាខ្មែរ *
                              TextFormField(
                                controller: _firstNameController,
                                decoration: const InputDecoration(
                                  labelText: 'ឈ្មោះជាភាសាខ្មែរ *',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              // ឈ្មោះជាអក្សរឡាតាំង *
                              TextFormField(
                                controller: _lastNameController,
                                decoration: const InputDecoration(
                                  labelText: 'ឈ្មោះជាអក្សរឡាតាំង *',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              // ថ្ងៃខែឆ្នាំកំណើត
                              TextFormField(
                                controller: _dobController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'ថ្ងៃខែឆ្នាំកំណើត',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: _selectDate,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              // មុខរបរ (Job)
                              TextFormField(
                                controller: _jobController,
                                readOnly: true,
                                onTap: () async {
                                  await _showSelectionBottomSheet(
                                    context: context,
                                    title: 'Select Job',
                                    items: jobTypes,
                                    onSelected: (id, value) {
                                      setState(() {
                                        selectedJobId = id;
                                        _jobController.text = value;
                                      });
                                    },
                                  );
                                },
                                decoration: const InputDecoration(
                                  labelText: 'មុខរបរ',
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox( 
                                height: 25,
                              ),

                              // ស្ថាប័ន (Work Place)
                              TextFormField(
                                controller: _workPlaceController,
                                readOnly: true,
                                onTap: () async {
                                  await _showSelectionBottomSheet(
                                    context: context,
                                    title: 'Select Work Place',
                                    items: workPlaces,
                                    onSelected: (id, value) {
                                      setState(() {
                                        selectedWorkPlaceId = id;
                                        _workPlaceController.text = value;
                                      });
                                    },
                                  );
                                },
                                decoration: const InputDecoration(
                                  labelText: 'ស្ថាប័ន',
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
            bottomNavigationBar: // Submit Button
                Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    _handleSubmit();
                  },
                  child: Text(
                    AppLang.translate(
                        lang: settingProvider.lang ?? 'kh', key: 'create'),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        }));
  }

  //static data
  final Map<String, String> relativeTypes = {
    '1': 'ប្តី',
    '2': 'ប្រពន្ធ',
    '3': 'កូន',
    '4': 'បងប្រុស',
    '5': 'បងស្រី',
    '6': 'ប្អូនប្រុស',
    '7': 'ប្អូនស្រី',
    '8': 'ឪពុក',
    '9': 'ម្តាយ',
  };

  final Map<String, String> jobTypes = {
    '1': 'គ្រូបង្រៀន',
    '2': 'វេជ្ជបណ្ឌិត',
    '3': 'វិស្វករ',
    '4': 'អ្នកគ្រប់គ្រង',
    '5': 'អ្នកវិភាគ',
  };

  final Map<String, String> workPlaces = {
    '1': 'ក្រសួងអប់រំ',
    '2': 'ក្រសួងសុខាភិបាល',
    '3': 'ក្រុមហ៊ុនឯកជន',
    '4': 'អង្គការអន្តរជាតិ',
  };
  //bottom sheet selector
  Future<void> _showSelectionBottomSheet({
    required BuildContext context,
    required String title,
    required Map<String, String> items,
    required Function(String id, String value) onSelected,
  }) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView(
                children: items.entries
                    .map((entry) => ListTile(
                          title: Text(entry.value),
                          onTap: () {
                            onSelected(entry.key, entry.value);
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
