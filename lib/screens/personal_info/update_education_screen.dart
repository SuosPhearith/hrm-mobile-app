import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';

import 'package:mobile_app/providers/local/personalinfo/update_education_provider.dart';
import 'package:mobile_app/services/personal_info/create_personalinfo_service.dart';
import 'package:mobile_app/shared/component/bottom_appbar.dart';
import 'package:mobile_app/shared/component/build_selection.dart';
import 'package:mobile_app/shared/date/field_date.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:provider/provider.dart';

class UpdateEducationScreen extends StatefulWidget {
  const UpdateEducationScreen(
      {super.key, required this.userId, required this.educationId});
  final String userId;
  final String educationId;

  @override
  State<UpdateEducationScreen> createState() => _UpdateEducationScreenState();
}

class _UpdateEducationScreenState extends State<UpdateEducationScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(UpdateEducationProvider provider) async {
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
  bool _isDataLoaded = false;
  DateTime? _startDate;
  DateTime? _endDate;
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

  void _loadExistingData(UpdateEducationProvider provider) {
    if (_isDataLoaded || provider.data == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        // Set text fields

        final startDateStr = getSafeString(
            value: provider.data?.data['study_at'], safeValue: '');
        _startDate =
            startDateStr.isNotEmpty ? DateTime.tryParse(startDateStr) : null;
        final endDateStr = getSafeString(
            value: provider.data?.data['graduate_at'], safeValue: '');
        _endDate =
            endDateStr.isNotEmpty ? DateTime.tryParse(startDateStr) : null;

        _type.text = getSafeString(
            value: provider.data?.data['education_type']?['name_kh'],
            safeValue: '');
        _educationLevel.text = getSafeString(
            value: provider.data?.data['education_level']?['name_kh'],
            safeValue: '');
        _certificate.text = getSafeString(
            value: provider.data?.data['certificate_type']?['name_kh'],
            safeValue: '');
        _skill.text = getSafeString(
            value: provider.data?.data['major']?['name_kh'], safeValue: '');
        _school.text = getSafeString(
            value: provider.data?.data['school']?['name_kh'], safeValue: '');
        _place.text = getSafeString(
            value: provider.data?.data['education_place']?['name_kh'],
            safeValue: '');

        // Set selected IDs for dropdowns
        selectedEducationTypeId =
            provider.data?.data['education_type']?['id'].toString();
        selectedEducationLevelId =
            provider.data?.data['education_level']?['id'].toString();
        selectedCertificateTypeId =
            provider.data?.data['certificate_type']?['id'].toString();
        selectedMajorId = provider.data?.data['major']?['id'].toString();
        selectedSchoolId = provider.data?.data['school']?['id'].toString();
        selectedEducationPlaceId =
            provider.data?.data['education_place']?['id'].toString();

        _isDataLoaded = true;
      });
    });
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
      if (_startDate==null) {
        return 'Start Date is required';
      }
      if (_endDate==null) {
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
            key: 'update'),
        AppLang.translate(
            lang: Provider.of<SettingProvider>(context, listen: false).lang ??
                'kh',
            key: 'Are you sure to update'),
        DialogType.primary, () async {
      try {
        await _service.updatedUserEducation(
          educationId: widget.educationId,
          userId: widget.userId,
          educationTypeId: selectedEducationTypeId ?? '',
          educationLevelId: selectedEducationLevelId ?? '',
          certificateTypeId: selectedCertificateTypeId ?? '',
          majorId: selectedMajorId ?? '',
          schoolId: selectedSchoolId ?? '',
          educationPlaceId: selectedEducationPlaceId ?? '',
          studyAt: DateFormat('yyyy-MM-dd').format(_startDate!),
          graduateAt: DateFormat('yyyy-MM-dd').format(_endDate!),
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
        create: (_) => UpdateEducationProvider(
            userId: widget.userId, educationId: widget.educationId),
        child: Consumer2<UpdateEducationProvider, SettingProvider>(builder:
            (context, createEducationProvider, settingProvider, child) {
          final educationTypes = _buildEducationSelectionMap(
            apiData: createEducationProvider.dataSetup,
            dataKey: 'education_types',
            settingProvider: settingProvider,
          );

          final educationLevels = _buildEducationSelectionMap(
            apiData: createEducationProvider.dataSetup,
            dataKey: 'education_levels',
            settingProvider: settingProvider,
          );

          final certificateTypes = _buildEducationSelectionMap(
              apiData: createEducationProvider.dataSetup,
              dataKey: 'certificate_types',
              settingProvider: settingProvider);
          final majors = _buildEducationSelectionMap(
              apiData: createEducationProvider.dataSetup,
              dataKey: 'majors',
              settingProvider: settingProvider);
          final schools = _buildEducationSelectionMap(
              apiData: createEducationProvider.dataSetup,
              dataKey: 'schools',
              settingProvider: settingProvider);
          final educationPlaces = _buildEducationSelectionMap(
              apiData: createEducationProvider.dataSetup,
              dataKey: 'education_places',
              settingProvider: settingProvider);
          if (!createEducationProvider.isLoading && !_isDataLoaded) {
            _loadExistingData(createEducationProvider);
          }
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(AppLang.translate(
                  lang: 'kh', key: 'user_info_education_update')),
              centerTitle: true,
              actions: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () => _handleSubmit(),
                    child: Icon(
                      Icons.check,
                      color: Colors.blueAccent,
                    ),
                  ),
                )
              ],
              bottom: CustomHeader(),
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
                            buildSelectionField(
                              context: context,
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
                            buildSelectionField(
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
                              context: context,
                            ),
                            const SizedBox(height: 16),
                            // Certificate
                            buildSelectionField(
                              context: context,
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
                            buildSelectionField(
                              context: context,
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
                            buildSelectionField(
                              context: context,
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
                            buildSelectionField(
                              context: context,
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
                                  child: DateInputField(
                                    label: 'ថ្ងៃចាប់ផ្តើម',
                                    hint: 'សូមជ្រើសរើសកាលបរិច្ឆេទ',
                                    initialDate: DateTime.now(),
                                    selectedDate: _startDate,
                                    onDateSelected: (date) {
                                      setState(() {
                                        _startDate = date;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: DateInputField(
                                    label: 'ថ្ងៃបញ្ចប់',
                                    hint: 'សូមជ្រើសរើសកាលបរិច្ឆេទ',
                                    initialDate: DateTime.now(),
                                    selectedDate: _endDate,
                                    onDateSelected: (date) {
                                      setState(() {
                                        _endDate = date;
                                      });
                                    },
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
            // bottomNavigationBar: Padding(
            //   padding: const EdgeInsets.all(15),
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         padding: const EdgeInsets.symmetric(vertical: 12),
            //         backgroundColor: Colors.blue[900],
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(30),
            //         ),
            //       ),
            //       onPressed: () {
            //         _handleSubmit();
            //       },
            //       child: Text(
            //         AppLang.translate(
            //             lang: settingProvider.lang ?? 'kh', key: 'update'),
            //         style: TextStyle(fontSize: 16, color: Colors.white),
            //       ),
            //     ),
            //   ),
            // ),
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
}
