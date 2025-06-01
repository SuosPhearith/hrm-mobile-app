import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/work/create_work_provider.dart';

import 'package:mobile_app/services/work/create_work_service.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:provider/provider.dart';

class CreateWorkHistoryScreen extends StatefulWidget {
  const CreateWorkHistoryScreen({super.key, this.id});
  final String? id;

  @override
  State<CreateWorkHistoryScreen> createState() =>
      _CreateWorkHistoryScreenState();
}

class _CreateWorkHistoryScreenState extends State<CreateWorkHistoryScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(CreateWorkProvider provider) async {
    return await provider.getHome();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateIn = TextEditingController();
  final TextEditingController _dateOut = TextEditingController();
  final TextEditingController _rankPossition = TextEditingController();
  final TextEditingController _organization = TextEditingController();
  final TextEditingController _department = TextEditingController();
  final TextEditingController _office = TextEditingController();
  final TextEditingController _possition = TextEditingController();
  final TextEditingController _place = TextEditingController();

  // service
  final CreateWorkService _service = CreateWorkService();

  // Variables to store selected IDs
  String? selectedPlaceId;
  String? selectedOganizationId;
  String? selecteddepartmentId;
  String? selectedOfficeId;
  String? selectedpossitionId;
  String? selectedRankPositionId;

  @override
  void dispose() {
    _dateIn.dispose();
    _rankPossition.dispose();
    _department.dispose();
    _dateOut.dispose();
    _organization.dispose();
    _office.dispose();
    _possition.dispose();
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
      if (selectedPlaceId == null || selectedPlaceId!.isEmpty) {
        return 'Please select institution';
      }
      if (selecteddepartmentId == null || selecteddepartmentId!.isEmpty) {
        return 'Please select department';
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
        await _service.createUserWorkHistory(
          userId: widget.id ?? '',
          departmentId: selecteddepartmentId!,
          organizatioId: selectedOganizationId!,
          generalDepartmentId: null,
          officeId:selectedOfficeId,
          positionId: selectedpossitionId,
          rankPositionId: selectedRankPositionId,
          startWorkingAt: _dateIn.text,
          stopWorkingAt: _dateOut.text,
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
        create: (_) => CreateWorkProvider(),
        child: Consumer2<CreateWorkProvider, SettingProvider>(
            builder: (context, provider, settingProvider, child) {
          final department = _buildEducationSelectionMap(
              apiData: provider.dataSetup,
              dataKey: 'departments',
              settingProvider: settingProvider);
          final position = _buildEducationSelectionMap(
              apiData: provider.dataSetup,
              dataKey: 'positions',
              settingProvider: settingProvider);

          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text(AppLang.translate(
                  lang: settingProvider.lang ?? 'kh',
                  key: 'work_experience_add')),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.blue[800],
              backgroundColor: Colors.white,
              onRefresh: () => _refreshData(provider),
              child: provider.isLoading
                  ? const Center(child: Text('Loading...'))
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
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
                                          key: 'start_date'),
                                      labelStyle:
                                          TextStyle(color: Colors.blueGrey),
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
                                        key: 'end_date',
                                      ),
                                      labelStyle:
                                          TextStyle(color: Colors.blueGrey),
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
                            SizedBox(
                              height: 16,
                            ),
                            //Institution
                            _buildSelectionField(
                              controller: _place,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'institutions'),
                              items: department,
                              selectedId:
                                  selectedPlaceId, // Pass current selection
                              onSelected: (id, value) {
                                setState(() {
                                  selectedPlaceId = id;
                                  _place.text = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Oganization
                            _buildSelectionField(
                              controller: _organization,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'organization'),
                              items: department,
                              selectedId:
                                  selectedOganizationId, // Pass current selection
                              onSelected: (id, value) {
                                setState(() {
                                  selectedOganizationId = id;
                                  _organization.text = value;
                                });
                              },
                            ),

                            const SizedBox(height: 16),
                            // Department
                            _buildSelectionField(
                              controller: _department,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'department'),
                              items: department,
                              selectedId:
                                  selecteddepartmentId, // Pass current selection
                              onSelected: (id, value) {
                                setState(() {
                                  selecteddepartmentId = id;
                                  _department.text = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Office
                            _buildSelectionField(
                              controller: _office,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'office'),
                              items: department,
                              selectedId:
                                  selectedOfficeId, // Pass current selection
                              onSelected: (id, value) {
                                setState(() {
                                  selectedOfficeId = id;
                                  _office.text = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // possition
                            _buildSelectionField(
                              controller: _possition,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'position'),
                              items: position,
                              selectedId:
                                  selectedpossitionId, // Pass current selection
                              onSelected: (id, value) {
                                setState(() {
                                  selectedpossitionId = id;
                                  _possition.text = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // rank position
                            _buildSelectionField(
                              controller: _rankPossition,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'rank_position'),
                              items: position,
                              selectedId:
                                  selectedRankPositionId, // Pass current selection
                              onSelected: (id, value) {
                                setState(() {
                                  selectedRankPositionId = id;
                                  _rankPossition.text = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),

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
          //  selectedId: selectedEducationrankPossitionId, // Pass current selection
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
}
