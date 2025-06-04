import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/work/update_user_medal_provider.dart';
import 'package:mobile_app/services/work/create_work_service.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:provider/provider.dart';

class UpdateUserMedalScreen extends StatefulWidget {
  const UpdateUserMedalScreen({super.key, this.id, this.userMedalId});
  final String? id;
  final String? userMedalId;
  @override
  State<UpdateUserMedalScreen> createState() => _UpdateUserMedalScreenState();
}

class _UpdateUserMedalScreenState extends State<UpdateUserMedalScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(UpdateUserMedalProvider provider) async {
    return await provider.getHome();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _givenDate = TextEditingController();
  final TextEditingController _medalType = TextEditingController();
  final TextEditingController _medal = TextEditingController();
  final TextEditingController _note = TextEditingController();

  final CreateWorkService _service = CreateWorkService();
  // Variables to store selected IDs
  String? selectedMedalId;
  String? selectedMedalTypeId;
  bool _isDataLoaded = false;
  @override
  void dispose() {
    _givenDate.dispose();
    _medal.dispose();
    _medalType.dispose();
    _note.dispose();
    super.dispose();
  }

  void _clearAllControllers() {
    _givenDate.clear();
    _medal.clear();
    _medalType.clear();
    _note.clear();

    // Also clear any selected IDs if needed
    setState(() {
      selectedMedalId = null;
      selectedMedalTypeId = null;
    });
  }

  // method to load existing data
  void _loadExistingData(
      UpdateUserMedalProvider provider, SettingProvider settingProvider) {
    if (_isDataLoaded || provider.data == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final medalData = provider.data?.data;
      if (medalData == null) return;

      setState(() {
        final currentLang = settingProvider.lang ?? 'kh';
        _givenDate.text = formatDate(medalData['given_at']);
        // Set medal type (តាមរយៈ)
        _medalType.text = currentLang == 'kh'
            ? (medalData['medal_types']?['name_kh'] ??
                medalData['medal_types']?['name_en'] ??
                '')
            : (medalData['medal_types']?['name_en'] ??
                medalData['medal_types']?['name_kh'] ??
                '');

        // Set medal (ឥស្សរយស)
        _medal.text = currentLang == 'kh'
            ? (medalData['medals']?['name_kh'] ??
                medalData['medals']?['name_en'] ??
                '')
            : (medalData['medals']?['name_en'] ??
                medalData['medals']?['name_kh'] ??
                '');

        // Set selected IDs
        selectedMedalId = medalData['medal_id']?.toString();
        selectedMedalTypeId = medalData['medal_type_id']?.toString();

        _isDataLoaded = true;
      });
    });
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

  // Add this helper method to convert DD-MM-YYYY to YYYY-MM-DD
  String convertDateForApi(String dateString) {
    if (dateString.isEmpty) return '';

    try {
      // Check if it's already in YYYY-MM-DD format
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateString)) {
        return dateString;
      }

      // Handle DD-MM-YYYY format
      if (RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(dateString)) {
        List<String> parts = dateString.split('-');
        String day = parts[0];
        String month = parts[1];
        String year = parts[2];
        return '$year-$month-$day';
      }

      // Try to parse as DateTime and format
      DateTime date = DateTime.parse(dateString);
      return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateString; // Return original if conversion fails
    }
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate required fields
    if (selectedMedalId == null || selectedMedalTypeId == null) {
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
      try {
        await _service.updateUserMedal(
          userId: widget.id!,
          userMedalId: widget.userMedalId!,
          medalTypeId: selectedMedalTypeId!,
          medalId: selectedMedalId!,
          givenAt: convertDateForApi(_givenDate.text),
          note: _note.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ការស្នើសុំត្រូវបានបញ្ជូនដោយជោគជ័យ')),
          );
          _clearAllControllers();
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
        create: (_) => UpdateUserMedalProvider(
            userId: widget.id!, medalId: widget.userMedalId!),
        child: Consumer2<UpdateUserMedalProvider, SettingProvider>(
            builder: (context, provider, settingProvider, child) {
          _loadExistingData(provider, settingProvider);
          final medalType = _buildEducationSelectionMap(
              apiData: provider.dataSetup,
              dataKey: 'medal_types',
              settingProvider: settingProvider);
          final medals = _buildEducationSelectionMap(
              apiData: provider.dataSetup,
              dataKey: 'medals',
              settingProvider: settingProvider);
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text(AppLang.translate(
                  lang: settingProvider.lang ?? 'kh',
                  key: 'update_user_medal')),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.blue[800],
              backgroundColor: Colors.white,
              onRefresh: () => _refreshData(provider),
              child: provider.isLoading
                  ? Center(child: Text('Loading...'))
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _givenDate,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: AppLang.translate(
                                      lang: settingProvider.lang ?? 'kh',
                                      key: 'given date'),
                                  labelStyle: TextStyle(color: Colors.blueGrey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                        color: Colors
                                            .blueGrey), // Normal border color
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                        color: Colors
                                            .blueGrey), // Enabled but not focused
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary, // Focused border color
                                      width: 2.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                        color: Colors.red), // Error state
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Colors.red, // Focused error state
                                      width: 2.0,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () => _selectDate(_givenDate),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // medal
                              _buildSelectionField(
                                controller: _medal,
                                label:
                                    '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'medals')} *',
                                items: medals,
                                selectedId:
                                    selectedMedalId, // Pass current selection
                                onSelected: (id, value) {
                                  setState(() {
                                    selectedMedalId = id;
                                    _medal.text = value;
                                  });
                                },
                              ),

                              const SizedBox(height: 16),

                              // Speaking and Reading Levels
                              _buildSelectionField(
                                controller: _medalType,
                                label:
                                    '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'throught')} *',
                                items: medalType,
                                selectedId:
                                    selectedMedalTypeId, // Pass current selection
                                onSelected: (id, value) {
                                  setState(() {
                                    selectedMedalTypeId = id;
                                    _medalType.text = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _note,
                                label: AppLang.translate(
                                    lang: settingProvider.lang ?? 'kh',
                                    key: 'user_info_note'),
                                // validator: (value) => value!.isEmpty
                                //     ? AppLang.translate(
                                //         lang: settingProvider.lang ?? 'kh',
                                //         key: 'please enter name_en')
                                //     : null,
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
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
                        lang: settingProvider.lang ?? 'kh', key: 'update'),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
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
                        fontWeight: FontWeight.w500,
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
}
