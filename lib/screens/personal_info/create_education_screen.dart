import 'package:flutter/material.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/sample_provider.dart';
import 'package:mobile_app/services/personal_info/create_service.dart';
import 'package:provider/provider.dart';

class CreateEducationScreen extends StatefulWidget {
  const CreateEducationScreen({super.key, this.id});
  final String? id;

  @override
  State<CreateEducationScreen> createState() => _CreateEducationScreenState();
}

class _CreateEducationScreenState extends State<CreateEducationScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(SampleProvider provider) async {
    return await provider.getHome();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateIn = TextEditingController();
  final TextEditingController _dateOut = TextEditingController();
  final TextEditingController _type = TextEditingController();
  final TextEditingController _certificate = TextEditingController();
  final TextEditingController _languageLevel = TextEditingController();
  final TextEditingController _skill = TextEditingController();
  final TextEditingController _school = TextEditingController();
  final TextEditingController _place = TextEditingController();

  // service
  final CreatePersonalService _service = CreatePersonalService();

  // Variables to store selected IDs
  String? selectedEducationTypeId;
  String? selectedEducationLevelId;
  String? selectedCertificateTypeId;
  String? selectedMajorId;
  String? selectedSchoolId;
  String? selectedEducationPlaceId;

  @override
  void dispose() {
    _dateIn.dispose();
    _type.dispose();
    _languageLevel.dispose();
    _dateOut.dispose();
    _certificate.dispose();
    _skill.dispose();
    _school.dispose();
    _place.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  // Handle form submission
  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final result = await _service.createUserEducation(
          userId: widget.id ?? '', //  widget.id is the user ID
          educationTypeId: selectedEducationTypeId ?? '',
          educationLevelId: selectedEducationLevelId ?? '',
          certificateTypeId: selectedCertificateTypeId ?? '',
          majorId: selectedMajorId,
          schoolId: selectedSchoolId,
          educationPlaceId: selectedEducationPlaceId,
          studyAt: _dateIn.text,
          graduateAt: _dateOut.text,
          note: null,
          attachmentId: null,
        );

        // Handle successful submission
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Education created successfully')),
        );
        Navigator.pop(context, result); // Return to previous screen
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
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
              title: Text(AppLang.translate(
                  lang: 'kh', key: 'user_info_education_add')),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.blue[800],
              backgroundColor: Colors.white,
              onRefresh: () => _refreshData(evaluateProvider),
              child: evaluateProvider.isLoading
                  ? const Center(child: Text('Loading...'))
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            // Type
                            TextFormField(
                              controller: _type,
                              readOnly: true,
                              onTap: () async {
                                await _showSelectionBottomSheet(
                                  context: context,
                                  title: 'Select Education Type',
                                  items: educationTypes,
                                  onSelected: (id, value) {
                                    setState(() {
                                      selectedEducationTypeId = id;
                                      _type.text = value;
                                    });
                                  },
                                );
                              },
                              decoration: const InputDecoration(
                                labelText: 'ប្រភេទ *',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  // return 'Please select education type';
                                  return AppLang.translate(
                                      lang: settingProvider.lang ?? 'kh',
                                      key: 'Please select education type');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            // Language Level
                            TextFormField(
                              controller: _languageLevel,
                              readOnly: true,
                              onTap: () async {
                                await _showSelectionBottomSheet(
                                  context: context,
                                  title: 'Select Education Level',
                                  items: educationLevels,
                                  onSelected: (id, value) {
                                    setState(() {
                                      selectedEducationLevelId = id;
                                      _languageLevel.text = value;
                                    });
                                  },
                                );
                              },
                              decoration: const InputDecoration(
                                labelText: 'កម្រិតភាសា *',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLang.translate(
                                      lang: settingProvider.lang ?? 'kh',
                                      key: 'Please select education level');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            // Certificate
                            TextFormField(
                              controller: _certificate,
                              readOnly: true,
                              onTap: () async {
                                await _showSelectionBottomSheet(
                                  context: context,
                                  title: 'ជ្រើសរើសប្រភេទសញ្ញាបត្រ',
                                  items: certificateTypes,
                                  onSelected: (id, value) {
                                    setState(() {
                                      selectedCertificateTypeId = id;
                                      _certificate.text = value;
                                    });
                                  },
                                );
                              },
                              decoration: const InputDecoration(
                                labelText: 'សញ្ញាបត្រ *',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLang.translate(
                                      lang: settingProvider.lang ?? 'kh',
                                      key: 'Please select certificate type');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            // Skill Level
                            TextFormField(
                              controller: _skill,
                              readOnly: true,
                              onTap: () async {
                                await _showSelectionBottomSheet(
                                  context: context,
                                  title: 'Select Major',
                                  items: majors,
                                  onSelected: (id, value) {
                                    setState(() {
                                      selectedMajorId = id;
                                      _skill.text = value;
                                    });
                                  },
                                );
                              },
                              decoration: const InputDecoration(
                                labelText: 'ជំនាញ',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // School
                            TextFormField(
                              controller: _school,
                              readOnly: true,
                              onTap: () async {
                                await _showSelectionBottomSheet(
                                  context: context,
                                  title: 'Select School',
                                  items: schools,
                                  onSelected: (id, value) {
                                    setState(() {
                                      selectedSchoolId = id;
                                      _school.text = value;
                                    });
                                  },
                                );
                              },
                              decoration: const InputDecoration(
                                labelText: 'គ្រឹះស្ថានសិក្សា',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                              ),
                            ),

                            // Place Study
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _place,
                              readOnly: true,
                              onTap: () async {
                                await _showSelectionBottomSheet(
                                  context: context,
                                  title: 'Select Education Place',
                                  items: educationPlaces,
                                  onSelected: (id, value) {
                                    setState(() {
                                      selectedEducationPlaceId = id;
                                      _place.text = value;
                                    });
                                  },
                                );
                              },
                              decoration: const InputDecoration(
                                labelText: 'ទីកន្លែងសិក្សា',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Date Picker Row
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _dateIn,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'ថ្ងៃចូលសិក្សា',
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.calendar_today),
                                        onPressed: () => _selectDate(_dateIn),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: _dateOut,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'ថ្ងៃបញ្ចប់',
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.calendar_today),
                                        onPressed: () => _selectDate(_dateOut),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // const SizedBox(
                            //     height: 30), // Extra space before button
                          ],
                        ),
                      ),
                    ),
            ),
            bottomNavigationBar: Padding(
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
  final Map<String, String> educationTypes = {
    '1': 'Formal Education',
    '2': 'Vocational Training',
    '3': 'Online Course',
  };

  final Map<String, String> educationLevels = {
    '1': 'Primary',
    '2': 'Secondary',
    '3': 'Bachelor',
    '4': 'Master',
    '5': 'PhD',
  };

  final Map<String, String> certificateTypes = {
    '1': 'Diploma',
    '2': 'Degree',
    '3': 'Certificate',
  };

  final Map<String, String> majors = {
    '1': 'Computer Science',
    '2': 'Business Administration',
    '3': 'Engineering',
  };

  final Map<String, String> schools = {
    '1': 'University A',
    '2': 'University B',
    '3': 'College C',
  };

  final Map<String, String> educationPlaces = {
    '1': 'Phnom Penh',
    '2': 'Siem Reap',
    '3': 'Battambang',
  };

  // Function to show bottom sheet for selection
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
