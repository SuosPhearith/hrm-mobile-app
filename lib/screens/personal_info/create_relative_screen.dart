import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/personalinfo/create_relative_provider.dart';
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
        job: _jobController.text.trim().isNotEmpty?_jobController.text.trim():null,
        workPlace: _workPlaceController.text.trim().isNotEmpty?_workPlaceController.text.trim():null,
        note: _noteController.text.isNotEmpty
            ? _noteController.text.trim()
            : null,
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
        create: (_) => CreateRelativeProvider(),
        child: Consumer2<CreateRelativeProvider, SettingProvider>(
            builder: (context, createRelativeProvider, settingProvider, child) {
                final relativeTypes = _buildRelativeTypes(createRelativeProvider, settingProvider);
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text(
                  AppLang.translate(lang: 'kh', key: 'user_info_family_add')),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              onRefresh: () => _refreshData(createRelativeProvider),
              child: createRelativeProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
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
                            _buildSelectionField(
                              controller: _relativeTypeController,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'relative_type'),
                              items: relativeTypes,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
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
                            _buildTextField(
                              controller: _firstNameController,
                              label: '${AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'user_info_kh_name')} *',
                              validator: (value) => value!.isEmpty
                                  ? AppLang.translate(
                                      lang: settingProvider.lang ?? 'kh',
                                      key: 'please enter name_kh')
                                  : null,
                            ),
                            const SizedBox(height: 24.0),
                            // Name (Latin)
                            _buildTextField(
                              controller: _lastNameController,
                              label: '${AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'user_info_en_name')} *',
                              validator: (value) => value!.isEmpty
                                  ? AppLang.translate(
                                      lang: settingProvider.lang ?? 'kh',
                                      key: 'please enter name_en')
                                  : null,
                            ),
                            const SizedBox(height: 24.0),
                            // Date of Birth
                            _buildTextField(
                              controller: _dobController,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'dob'),
                              readOnly: true,
                              onTap: _selectDate,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today_rounded),
                                onPressed: _selectDate,
                              ),
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
                            _buildTextField(
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
                            _buildTextField(
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
                      borderRadius: BorderRadius.circular(12),
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
  Map<String, String> _buildRelativeTypes(CreateRelativeProvider createRelativeProvider, SettingProvider settingProvider) {
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
            : (item['name_en']?.toString() ?? item['name_kh']?.toString() ?? '');
        
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      maxLines: maxLines,
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
              color: Theme.of(context).colorScheme.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        suffixIcon: suffixIcon,
        filled: true,
      ),
    );
  }

  // Reusable Selection Field widget
  Widget _buildSelectionField({
    required TextEditingController controller,
    required String label,
    required Map<String, String> items,
    required void Function(String id, String value) onSelected,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    final entry = items.entries.elementAt(index);
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
                              color: Colors.grey,
                              width: 1.0,
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
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16.0,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
