import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/personalinfo/create_education_provider.dart';
import 'package:mobile_app/services/personal_info/create_personalinfo_service.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/helper.dart';
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
  Future<void> _refreshData(CreateEducationProvider provider) async {
    return await provider.getHome();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateIn = TextEditingController();
  final TextEditingController _dateOut = TextEditingController();
  final TextEditingController _type = TextEditingController();
  final TextEditingController _certificate = TextEditingController();
  final TextEditingController _educationLevel = TextEditingController();
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
    _educationLevel.dispose();
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

  
  void _handleSubmit() async {
    // First validate the form fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate each field one by one and show first error encountered
    String? getFirstValidationError() {
      if (selectedEducationTypeId == null || selectedEducationTypeId!.isEmpty) {
        return 'Please select education type';
      }
      if (selectedEducationLevelId == null ||
          selectedEducationLevelId!.isEmpty) {
        return 'Please select education level';
      }
      if (_dateIn.text.isEmpty) {
        return 'Start Date is required';
      }
      if (_dateOut.text.isEmpty) {
        return 'End Date is required';
      }
      return null;
    }

    final errorMessage = getFirstValidationError();
    if (errorMessage != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLang.translate(lang: 'kh', key: errorMessage),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    showConfirmDialogWithNavigation(
        context,
        AppLang.translate(
            lang: Provider.of<SettingProvider>(context, listen: false).lang ??
                'kh',
            key: 'create'),
        AppLang.translate(
            lang: Provider.of<SettingProvider>(context, listen: false).lang ??
                'kh',
            key: 'Are you sure to create'),
        DialogType.primary, () async {
      try {
        await _service.createUserEducation(
          userId: widget.id ?? '',
          educationTypeId: selectedEducationTypeId!,
          educationLevelId: selectedEducationLevelId!,
          certificateTypeId: selectedCertificateTypeId ?? '',
          majorId: selectedMajorId ?? '',
          schoolId: selectedSchoolId ?? '',
          educationPlaceId: selectedEducationPlaceId ?? '',
          studyAt: _dateIn.text,
          graduateAt: _dateOut.text,
          note: null,
          attachmentId: null,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ការស្នើសុំត្រូវបានបញ្ជូនដោយជោគជ័យ')),
          );
          // _clearAllFields();

          context.pop();
        }
      } catch (e) {
        if (e is DioException) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(parseErrorResponse(e.response?.data)['message']
                      ?['name_kh'])),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CreateEducationProvider(),
        child: Consumer2<CreateEducationProvider, SettingProvider>(builder:
            (context, createEducationProvider, settingProvider, child) {
          final educationTypes = _buildEducationSelectionMap(
            apiData: createEducationProvider.data,
            dataKey: 'education_types',
            settingProvider: settingProvider,
          );

          final educationLevels = _buildEducationSelectionMap(
            apiData: createEducationProvider.data,
            dataKey: 'education_levels',
            settingProvider: settingProvider,
          );

          final certificateTypes = _buildEducationSelectionMap(
              apiData: createEducationProvider.data,
              dataKey: 'certificate_types',
              settingProvider: settingProvider);
          final majors = _buildEducationSelectionMap(
              apiData: createEducationProvider.data,
              dataKey: 'majors',
              settingProvider: settingProvider);
          final schools = _buildEducationSelectionMap(
              apiData: createEducationProvider.data,
              dataKey: 'schools',
              settingProvider: settingProvider);
          final educationPlaces = _buildEducationSelectionMap(
              apiData: createEducationProvider.data,
              dataKey: 'education_places',
              settingProvider: settingProvider);

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
              onRefresh: () => _refreshData(createEducationProvider),
              child: createEducationProvider.isLoading
                  ? const Center(child: Text('Loading...'))
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            // Education Type
                            _buildSelectionField(
                              controller: _type,
                              label:
                                  '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'user_education_type')} *',
                              items: educationTypes,
                              selectedId:
                                  selectedEducationTypeId, // Pass current selection
                              onSelected: (id, value) {
                                setState(() {
                                  selectedEducationTypeId = id;
                                  _type.text = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Education Level
                            _buildSelectionField(
                              controller: _educationLevel,
                              label:
                                  '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'user_educationLevel')} *',
                              items: educationLevels,
                              selectedId:
                                  selectedEducationLevelId, // Pass current selection
                              onSelected: (id, value) {
                                setState(() {
                                  selectedEducationLevelId = id;
                                  _educationLevel.text = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Certificate
                            _buildSelectionField(
                              controller: _certificate,
                              label:
                                  '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'certificate')} *',
                              items: certificateTypes,
                              selectedId:
                                  selectedCertificateTypeId, // Pass current selection
                              onSelected: (id, value) {
                                setState(() {
                                  selectedCertificateTypeId = id;
                                  _certificate.text = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Majors
                            _buildSelectionField(
                              controller: _skill,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'majors'),
                              items: majors,
                              selectedId:
                                  selectedMajorId, // Pass current selection
                              onSelected: (id, value) {
                                setState(() {
                                  selectedMajorId = id;
                                  _skill.text = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // School
                            _buildSelectionField(
                              controller: _school,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'school'),
                              items: schools,
                              selectedId:
                                  selectedSchoolId, // Pass current selection
                              onSelected: (id, value) {
                                setState(() {
                                  selectedSchoolId = id;
                                  _school.text = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Place Study
                            _buildSelectionField(
                              controller: _place,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'school place'),
                              items: educationPlaces,
                              selectedId:
                                  selectedEducationPlaceId, // Pass current selection
                              onSelected: (id, value) {
                                setState(() {
                                  selectedEducationPlaceId = id;
                                  _place.text = value;
                                });
                              },
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
                                      labelText: AppLang.translate(
                                          lang: settingProvider.lang ?? 'kh',
                                          key: 'enroll date'),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                            color: Colors
                                                .blueGrey), // Normal border color
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                            color: Colors
                                                .blueGrey), // Enabled but not focused
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary, // Focused border color
                                          width: 2.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                            color: Colors.red), // Error state
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                          color:
                                              Colors.red, // Focused error state
                                          width: 2.0,
                                        ),
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
                                      labelText: AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'graduated date',
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                            color: Colors
                                                .blueGrey), // Normal border color
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                            color: Colors
                                                .blueGrey), // Enabled but not focused
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary, // Focused border color
                                          width: 2.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                            color: Colors.red), // Error state
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                          color:
                                              Colors.red, // Focused error state
                                          width: 2.0,
                                        ),
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

  Map<String, String> _buildEducationSelectionMap({
    required dynamic apiData,
    required String dataKey,
    required SettingProvider settingProvider,
  }) {
    final dataSetUp = apiData?.data[dataKey];

    if (dataSetUp == null || dataSetUp is! List) {
      return {};
    }

    Map<String, String> result = {};

    for (var item in dataSetUp) {
      if (item is Map<String, dynamic>) {
        final id = item['id']?.toString();
        final currentLang = settingProvider.lang ?? 'kh';
        final name = currentLang == 'kh'
            ? (item['name_kh']?.toString() ?? item['name_en']?.toString() ?? '')
            : (item['name_en']?.toString() ??
                item['name_kh']?.toString() ??
                '');

        if (id != null && name.isNotEmpty) {
          result[id] = name;
        }
      }
    }

    return result;
  }

  // Reusable Selection Field widget
  Widget _buildSelectionField({
    required TextEditingController controller,
    required String label,
    required Map<String, String> items,
    required void Function(String id, String value) onSelected,
    String? selectedId, // Add selectedId parameter
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        await _showSelectionBottomSheet(
          context: context,
          title: label,
          items: items,
          onSelected: onSelected,
          //  selectedId: selectedEducationTypeId, // Pass current selection
          selectedId: selectedId, // Pass current selection
        );
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 1.0),
        ),
        suffixIcon: Icon(Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.primary),
        filled: true,
      ),
    );
  }

  Future<void> _showSelectionBottomSheet({
    required BuildContext context,
    required String title,
    required Map<String, String> items,
    required Function(String id, String value) onSelected,
    String? selectedId, // Add selectedId parameter
  }) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.close),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    final entry = items.entries.elementAt(index);
                    final isSelected = selectedId == entry.key;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          onSelected(entry.key, entry.value);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 16.0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 24.0,
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
