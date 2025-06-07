import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/personalinfo/create_relative_provider.dart';
import 'package:mobile_app/services/personal_info/create_personalinfo_service.dart';
import 'package:mobile_app/shared/component/build_selection.dart';
import 'package:mobile_app/shared/component/build_text_filed.dart';
import 'package:mobile_app/shared/date/field_date.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/custom_header.dart';
import 'package:mobile_app/widgets/helper.dart';
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
  Future<void> _refreshData(CreateRelativeProvider provider) async {
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
//រឿន​ សុផាត់
  // Variables to store selected IDs
  String? selectedRelativeTypeId;
  String? selectedJobId;
  String? selectedWorkPlaceId;

  String? selectedGender;
  String? selectedProvince;
  String? selectedDistrict;
  DateTime? dob;

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
            key: 'create'),
        AppLang.translate(
            lang: Provider.of<SettingProvider>(context, listen: false).lang ??
                'kh',
            key: 'Are you sure to create'),
        DialogType.primary, () async {
      try {
        await _service.createUserFamily(
          userId: widget.id ?? '',
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

  // Method to clear all form fields
  void _clearAllFields() {
    _dobController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _relativeTypeController.clear();
    _jobController.clear();
    _workPlaceController.clear();
    _noteController.clear();

    // Reset dropdown selections
    setState(() {
      selectedGender = null;
      selectedRelativeTypeId = null;
      // Reset any other state variables you might have
    });

    // print("🧹 All form fields cleared");
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CreateRelativeProvider(),
        child: Consumer2<CreateRelativeProvider, SettingProvider>(
            builder: (context, createRelativeProvider, settingProvider, child) {
          final relativeTypes =
              _buildRelativeTypes(createRelativeProvider, settingProvider);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                  AppLang.translate(lang: 'kh', key: 'user_info_family_add')),
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
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              onRefresh: () => _refreshData(createRelativeProvider),
              child: createRelativeProvider.isLoading
                  ? const Center(child: Text('Loading...'))
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16.0),
                            // Relative Type
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
                                    onChanged: (value) =>
                                        setState(() => selectedGender = value),
                                    activeColor:
                                        Theme.of(context).colorScheme.primary,
                                    contentPadding: const EdgeInsets.symmetric(
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
                                    onChanged: (value) =>
                                        setState(() => selectedGender = value),
                                    activeColor:
                                        Theme.of(context).colorScheme.primary,
                                    contentPadding: const EdgeInsets.symmetric(
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
                            // Date of Birth
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
                            // // Job
                            // _buildSelectionField(
                            //   controller: _jobController,
                            //   label: AppLang.translate(
                            //       lang: settingProvider.lang ?? 'kh',
                            //       key: 'job'),
                            //   items: jobTypes,
                            //   onSelected: (id, value) {
                            //     setState(() {
                            //       selectedJobId = id;
                            //       _jobController.text = value;
                            //     });
                            //   },
                            // ),
                            // const SizedBox(height: 24.0),
                            // // Work Place
                            // _buildSelectionField(
                            //   controller: _workPlaceController,
                            //   label: AppLang.translate(
                            //       lang: settingProvider.lang ?? 'kh',
                            //       key: 'work_place'),
                            //   items: workPlaces,
                            //   onSelected: (id, value) {
                            //     setState(() {
                            //       selectedWorkPlaceId = id;
                            //       _workPlaceController.text = value;
                            //     });
                            //   },
                            // ),

                            // Name (Khmer)
                            buildTextField(
                              context: context,
                              controller: _jobController,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'job'),
                              // validator: (value) => value!.isEmpty
                              //     ? AppLang.translate(
                              //         lang: settingProvider.lang ?? 'kh',
                              //         key: 'please enter name_kh')
                              //     : null,
                            ),
                            const SizedBox(height: 24.0),
                            // Name (Latin)
                            buildTextField(
                              context: context,
                              controller: _workPlaceController,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'work_place'),
                              // validator: (value) => value!.isEmpty
                              //     ? AppLang.translate(
                              //         lang: settingProvider.lang ?? 'kh',
                              //         key: 'please enter name_en')
                              //     : null,
                            ),
                            const SizedBox(height: 24.0),
                          ],
                        ),
                      ),
                    ),
            ),
            // bottomNavigationBar: // Submit Button
            //     Padding(
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
            //       onPressed: () {
            //         _handleSubmit();
            //       },
            //       child: Text(
            //         AppLang.translate(
            //             lang: settingProvider.lang ?? 'kh', key: 'create'),
            //         style: TextStyle(fontSize: 16, color: Colors.white),
            //       ),
            //     ),
            //   ),
            // ),
          );
        }));
  }

  // //static data
  // final Map<String, String> relativeTypes = {
  //   '1': 'ប្តី',
  //   '2': 'ប្រពន្ធ',
  //   '3': 'កូន',
  //   '4': 'បងប្រុស',
  //   '5': 'បងស្រី',
  //   '6': 'ប្អូនប្រុស',
  //   '7': 'ប្អូនស្រី',
  //   '8': 'ឪពុក',
  //   '9': 'ម្តាយ',
  // };
  // Helper method to build relative types map
  Map<String, String> _buildRelativeTypes(
      CreateRelativeProvider createRelativeProvider,
      SettingProvider settingProvider) {
    final dataSetUp = createRelativeProvider.dataSetup?.data['family_role'];

    if (dataSetUp == null || dataSetUp is! List) {
      return {}; // Return empty map if data is not available or not a list
    }

    Map<String, String> types = {};

    for (var item in dataSetUp) {
      if (item is Map<String, dynamic>) {
        final id = item['id']?.toString();
        // Use Khmer name based on current language, fallback to English
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

  // final Map<String, String> jobTypes = {
  //   '1': 'គ្រូបង្រៀន',
  //   '2': 'វេជ្ជបណ្ឌិត',
  //   '3': 'វិស្វករ',
  //   '4': 'អ្នកគ្រប់គ្រង',
  //   '5': 'អ្នកវិភាគ',
  // };

  // final Map<String, String> workPlaces = {
  //   '1': 'ក្រសួងអប់រំ',
  //   '2': 'ក្រសួងសុខាភិបាល',
  //   '3': 'ក្រុមហ៊ុនឯកជន',
  //   '4': 'អង្គការអន្តរជាតិ',
  // };
}
