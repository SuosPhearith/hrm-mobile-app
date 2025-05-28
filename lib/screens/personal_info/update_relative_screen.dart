import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/personalinfo/update_user_family_provider.dart';
import 'package:mobile_app/services/personal_info/create_personalinfo_service.dart';
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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool _isDataLoaded = false; // Track if data has been loaded

  Future<void> _refreshData(UpdateUserFamilyProvider provider) async {
    return await provider.getHome();
  }

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
        _dobController.text =
            getSafeString(value: formatDate(data['dob']), safeValue: '');
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
          dob: _dobController.text.isNotEmpty
              ? _dobController.text.trim()
              : null,
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

  Future<void> _selectDate() async {
    // Parse existing date if available
    DateTime? initialDate;
    if (_dobController.text.isNotEmpty && _dobController.text != 'N/A') {
      try {
        initialDate = DateTime.parse(_dobController.text);
      } catch (e) {
        initialDate = DateTime.now();
      }
    } else {
      initialDate = DateTime.now();
    }

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

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
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text(AppLang.translate(
                  lang: 'kh', key: 'user_info_family_update')),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              onRefresh: () => _refreshData(provider),
              child: provider.isLoading
                  ? const Center(
                      child: Center(
                      child: Text("Loading..."),
                    ))
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16.0),

                            // Relative Type Selection
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
                                  ?.copyWith(fontWeight: FontWeight.w500),
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
                            _buildTextField(
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

                            // Job
                            _buildTextField(
                              controller: _jobController,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'job'),
                            ),
                            const SizedBox(height: 24.0),

                            // Work Place
                            _buildTextField(
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
            bottomNavigationBar: Padding(
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
                  onPressed: provider.isLoading ? null : _handleSubmit,
                  child: Text(
                    AppLang.translate(
                        lang: settingProvider.lang ?? 'kh',
                        key: 'update'), // Changed from 'create' to 'update'
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        }));
  }

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
        labelStyle: const TextStyle(color: Colors.blueGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.blueGrey),
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

  // Reusable Selection Field widget (keeping for future use)
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
        labelStyle: const TextStyle(color: Colors.blueGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.blueGrey),
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

  // Bottom sheet selector (keeping for future use)
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
                                const Icon(
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
