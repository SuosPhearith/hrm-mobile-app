import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/personal_info_provider.dart';
import 'package:mobile_app/providers/local/personalinfo/update_user_family_provider.dart';
import 'package:mobile_app/services/personal_info/create_personalinfo_service.dart';
import 'package:mobile_app/shared/component/bottom_appbar.dart';
import 'package:mobile_app/shared/component/build_selection.dart';
import 'package:mobile_app/shared/component/build_text_filed.dart';
import 'package:mobile_app/shared/date/field_date.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:provider/provider.dart';

class UpdateRelativeScreen extends StatefulWidget {
  const UpdateRelativeScreen(
      {super.key, required this.userId, required this.familyId});
  final String userId;
  final String familyId;
  @override
  State<UpdateRelativeScreen> createState() => _UpdateRelativeScreenState();
}

class _UpdateRelativeScreenState extends State<UpdateRelativeScreen> {
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //     GlobalKey<RefreshIndicatorState>();

  bool _isDataLoaded = false; // Track if data has been loaded
  DateTime? dob;
  // Future<void> _refreshData(UpdateUserFamilyProvider provider) async {
  //   return await provider.getHome();
  // }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final CreatePersonalService _service = CreatePersonalService();
  final TextEditingController _relativeTypeController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _workPlaceController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // Variables to store selected IDs
  String? selectedRelativeTypeId;
  String? selectedJobId;
  String? selectedWorkPlaceId;
  String? selectedGender;
  String? selectedProvince;
  String? selectedDistrict;

  // Helper method to build relative types map from API data
  Map<String, String> _buildRelativeTypes(
      UpdateUserFamilyProvider provider, SettingProvider settingProvider) {
    final dataSetUp = provider.dataSetup?.data['family_role'];

    if (dataSetUp == null || dataSetUp is! List) {
      return {}; // Return empty map if data is not available or not a list
    }

    Map<String, String> types = {};

    for (var item in dataSetUp) {
      if (item is Map<String, dynamic>) {
        final id = item['id']?.toString();
        // Use name based on current language, fallback to other language
        final currentLang = settingProvider.lang ?? 'kh';
        final name = currentLang == 'kh'
            ? (item['name_kh']?.toString() ?? item['name_en']?.toString() ?? '')
            : (item['name_en']?.toString() ??
                item['name_kh']?.toString() ??
                '');

        if (id != null && name.isNotEmpty) {
          types[id] = name;
        }
      }
    }

    return types;
  }

  // Method to load existing data into form fields
  void _loadExistingData(
      UpdateUserFamilyProvider provider, SettingProvider settingProvider) {
    if (_isDataLoaded || provider.data?.data == null) return;

    final data = provider.data!.data;

    // Use post frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        // Load text fields
        _firstNameController.text =
            getSafeString(value: data['name_kh'], safeValue: '');
        _lastNameController.text =
            getSafeString(value: data['name_en'], safeValue: '');
        // _dobController.text =
        //     getSafeString(value: formatDate(data['dob']), safeValue: '');
        // Load Date of Birth
        final dobStr = getSafeString(value: data['dob'], safeValue: '');
        dob = dobStr.isNotEmpty ? DateTime.tryParse(dobStr) : null;
        _jobController.text = getSafeString(value: data['job'], safeValue: '');
        _workPlaceController.text =
            getSafeString(value: data['work_place'], safeValue: '');
        _noteController.text =
            getSafeString(value: data['note'], safeValue: '');

        // Load selected values
        selectedGender = data['sex_id']?.toString();
        selectedRelativeTypeId = data['family_role_id']?.toString();

        // Load relative type text for display
        if (selectedRelativeTypeId != null && provider.dataSetup != null) {
          final relativeTypes = _buildRelativeTypes(provider, settingProvider);
          _relativeTypeController.text =
              relativeTypes[selectedRelativeTypeId] ?? '';
        }

        _isDataLoaded = true;
      });
    });
  }

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
      //ណូរ៉ា
      try {
        await _service.updateUserFamily(
          familyId: widget.familyId,
          userId: widget.userId,
          nameKh: _firstNameController.text.trim(),
          nameEn: _lastNameController.text.trim(),
          sexId: selectedGender ?? '',
          dob: DateFormat('yyyy-MM-dd').format(dob!),
          familyRoleId: selectedRelativeTypeId,
          job: _jobController.text.trim().isNotEmpty
              ? _jobController.text.trim()
              : null,
          workPlace: _workPlaceController.text.trim().isNotEmpty
              ? _workPlaceController.text.trim()
              : null,
          note: _noteController.text.isNotEmpty
              ? _noteController.text.trim()
              : null,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ការស្នើសុំត្រូវបានបញ្ជូនដោយជោគជ័យ')),
          );
          _clearAllFields();
          Provider.of<PersonalInfoProvider>(context, listen: false).getHome();
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

  // Method to clear all form fields (keeping this for potential reset functionality)
  void _clearAllFields() {
    _dobController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _relativeTypeController.clear();
    _jobController.clear();
    _workPlaceController.clear();
    _noteController.clear();

    setState(() {
      selectedGender = null;
      selectedRelativeTypeId = null;
      selectedJobId = null;
      selectedWorkPlaceId = null;
      _isDataLoaded = false; // Reset data loaded flag
    });
  }

  // Future<void> _selectDate() async {
  //   // Parse existing date if available
  //   DateTime? initialDate;
  //   if (_dobController.text.isNotEmpty && _dobController.text != 'N/A') {
  //     try {
  //       initialDate = DateTime.parse(_dobController.text);
  //     } catch (e) {
  //       initialDate = DateTime.now();
  //     }
  //   } else {
  //     initialDate = DateTime.now();
  //   }

  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: initialDate,
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _dobController.text = "${picked.toLocal()}".split(' ')[0];
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => UpdateUserFamilyProvider(
            userId: widget.userId, familyId: widget.familyId),
        child: Consumer2<UpdateUserFamilyProvider, SettingProvider>(
            builder: (context, provider, settingProvider, child) {
          // Build relative types from API data
          final relativeTypes = _buildRelativeTypes(provider, settingProvider);

          // Load existing data when provider has data
          if (!provider.isLoading && provider.data != null) {
            _loadExistingData(provider, settingProvider);
          }

          return Scaffold(
            backgroundColor: Colors.white,

            appBar: AppBar(
              title: Text(AppLang.translate(
                  lang: 'kh', key: 'user_info_family_update')),
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
            body: provider.isLoading
                ? const Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        ),
                        Text(
                          'សូមរងចាំ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: SafeArea(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16.0),

                              // Relative Type Selection
                              buildSelectionField(
                                context: context,
                                controller: _relativeTypeController,
                                label: AppLang.translate(
                                    lang: settingProvider.lang ?? 'kh',
                                    key: 'relative_type'),
                                items: relativeTypes,
                                selectedId: selectedRelativeTypeId,
                                onSelected: (id, value) {
                                  setState(() {
                                    selectedRelativeTypeId = id;
                                    _relativeTypeController.text = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 24.0),

                              // Gender Selection
                              Text(
                                AppLang.translate(
                                    lang: settingProvider.lang ?? 'kh',
                                    key: 'user_info_sex'),
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text(AppLang.translate(
                                          lang: settingProvider.lang ?? 'kh',
                                          key: 'male')),
                                      value: '1',
                                      groupValue: selectedGender,
                                      onChanged: (value) => setState(
                                          () => selectedGender = value),
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text(AppLang.translate(
                                          lang: settingProvider.lang ?? 'kh',
                                          key: 'female')),
                                      value: '2',
                                      groupValue: selectedGender,
                                      onChanged: (value) => setState(
                                          () => selectedGender = value),
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24.0),

                              // Name (Khmer)
                              buildTextField(
                                context: context,
                                controller: _firstNameController,
                                label:
                                    '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'user_info_kh_name')} *',
                                validator: (value) => value!.isEmpty
                                    ? AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'please enter name_kh')
                                    : null,
                              ),
                              const SizedBox(height: 24.0),

                              // Name (Latin)
                              buildTextField(
                                context: context,
                                controller: _lastNameController,
                                label:
                                    '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'user_info_en_name')} *',
                                validator: (value) => value!.isEmpty
                                    ? AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'please enter name_en')
                                    : null,
                              ),
                              const SizedBox(height: 24.0),

                              // // Date of Birth
                              // _buildTextField(
                              //   controller: _dobController,
                              //   label: AppLang.translate(
                              //       lang: settingProvider.lang ?? 'kh',
                              //       key: 'dob'),
                              //   readOnly: true,
                              //   onTap: _selectDate,
                              //   suffixIcon: IconButton(
                              //     icon: const Icon(Icons.calendar_today_rounded),
                              //     onPressed: _selectDate,
                              //   ),
                              // ),
                              DateInputField(
                                label: AppLang.translate(
                                    lang: settingProvider.lang ?? 'kh',
                                    key: 'user_info_date_of_birth'),
                                hint: 'សូមជ្រើសរើសកាលបរិច្ឆេទ',
                                initialDate: DateTime.now(),
                                selectedDate: dob,
                                onDateSelected: (date) {
                                  setState(() {
                                    dob = date;
                                  });
                                },
                              ),
                              const SizedBox(height: 24.0),

                              // Job
                              buildTextField(
                                controller: _jobController,
                                label: AppLang.translate(
                                    lang: settingProvider.lang ?? 'kh',
                                    key: 'job'),
                                context: context,
                              ),
                              const SizedBox(height: 24.0),

                              // Work Place
                              buildTextField(
                                context: context,
                                controller: _workPlaceController,
                                label: AppLang.translate(
                                    lang: settingProvider.lang ?? 'kh',
                                    key: 'work_place'),
                              ),
                              const SizedBox(height: 24.0),

                              // // Note field
                              // _buildTextField(
                              //   controller: _noteController,
                              //   label: AppLang.translate(
                              //       lang: settingProvider.lang ?? 'kh',
                              //       key: 'note'),
                              //   maxLines: 3,
                              // ),
                              const SizedBox(height: 24.0),
                            ],
                          ),
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
            //           borderRadius: BorderRadius.circular(12),
            //         ),
            //       ),
            //       onPressed: provider.isLoading ? null : _handleSubmit,
            //       child: Text(
            //         AppLang.translate(
            //             lang: settingProvider.lang ?? 'kh',
            //             key: 'update'), // Changed from 'create' to 'update'
            //         style: const TextStyle(fontSize: 16, color: Colors.white),
            //       ),
            //     ),
            //   ),
            // ),
          );
        }));
  }
}
