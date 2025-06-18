import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/work/update_work_history_provider.dart';
import 'package:mobile_app/providers/local/work_provider.dart';

import 'package:mobile_app/services/work/create_work_service.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/shared/date/field_date.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/custom_header.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:provider/provider.dart';

class UpdateWorkHistoryScreen extends StatefulWidget {
  const UpdateWorkHistoryScreen({super.key, this.id, this.workId});
  final String? id;
  final String? workId;

  @override
  State<UpdateWorkHistoryScreen> createState() =>
      _UpdateWorkHistoryScreenState();
}

class _UpdateWorkHistoryScreenState extends State<UpdateWorkHistoryScreen> {
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //     GlobalKey<RefreshIndicatorState>();
  // Future<void> _refreshData(UpdateWorkHistoryProvider provider) async {
  //   return await provider.getHome();
  // }

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
  bool _isDataLoaded = false;
  DateTime? _startDate;
  DateTime? _endDate;
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

  // method to load existing data
  void _loadExistingData(
      UpdateWorkHistoryProvider provider, SettingProvider settingProvider) {
    if (_isDataLoaded || provider.data == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final workData = provider.data?.data;
      if (workData == null) return;

      setState(() {
        final currentLang = settingProvider.lang ?? 'kh';
        // _dateIn.text = formatDate(workData['start_working_at']);
        // _dateOut.text = formatDate(workData['stop_working_at']);
        final startDateStr = getSafeString(
            value: provider.data?.data['start_working_at'], safeValue: '');
        _startDate =
            startDateStr.isNotEmpty ? DateTime.tryParse(startDateStr) : null;
        final endDateStr = getSafeString(
            value: provider.data?.data['stop_working_at'], safeValue: '');
        _endDate =
            endDateStr.isNotEmpty ? DateTime.tryParse(startDateStr) : null;
        // Set instituts field (ស្ថាប័ន)
        _place.text = currentLang == 'kh'
            ? (workData['department']?['name_kh'] ??
                workData['department']?['name_en'] ??
                '')
            : (workData['department']?['name_en'] ??
                workData['department']?['name_kh'] ??
                '');

        // Set organization (អង្គភាព)
        _organization.text = currentLang == 'kh'
            ? (workData['organization']?['name_kh'] ??
                workData['organization']?['name_en'] ??
                '')
            : (workData['organization']?['name_en'] ??
                workData['organization']?['name_kh'] ??
                '');

        // Set department (នាយកដ្ឋាន)
        _department.text = currentLang == 'kh'
            ? (workData['department']?['name_kh'] ??
                workData['department']?['name_en'] ??
                '')
            : (workData['department']?['name_en'] ??
                workData['department']?['name_kh'] ??
                '');

        // Set office (ការិយាល័យ)
        _office.text = currentLang == 'kh'
            ? (workData['office']?['name_kh'] ??
                workData['office']?['name_en'] ??
                '')
            : (workData['office']?['name_en'] ??
                workData['office']?['name_kh'] ??
                '');

        // Set position (មុខតំណែង)
        _possition.text = currentLang == 'kh'
            ? (workData['position']?['name_kh'] ??
                workData['position']?['name_en'] ??
                '')
            : (workData['position']?['name_en'] ??
                workData['position']?['name_kh'] ??
                '');

        // Set rank position (ឋានៈស្មើ)
        _rankPossition.text = currentLang == 'kh'
            ? (workData['rank_position']?['name_kh'] ??
                workData['rank_position']?['name_en'] ??
                '')
            : (workData['rank_position']?['name_en'] ??
                workData['rank_position']?['name_kh'] ??
                '');
        // Set selected IDs
        selectedPlaceId = workData['department_id']?.toString();
        selectedOganizationId = workData['organization_id']?.toString();
        selecteddepartmentId = workData['department_id']?.toString();
        selectedOfficeId = workData['office_id']?.toString();
        selectedpossitionId = workData['position_id']?.toString();
        selectedRankPositionId = workData['rank_position_id']?.toString();

        _isDataLoaded = true;
      });
    });
  }

  // Future<void> _selectDate(TextEditingController controller) async {
  //   // Parse existing date if present
  //   DateTime initialDate = DateTime.now();
  //   if (controller.text.isNotEmpty) {
  //     try {
  //       // Handle both DD-MM-YYYY and YYYY-MM-DD formats
  //       String dateText = controller.text;
  //       if (RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(dateText)) {
  //         // Convert DD-MM-YYYY to YYYY-MM-DD for parsing
  //         List<String> parts = dateText.split('-');
  //         dateText = '${parts[2]}-${parts[1]}-${parts[0]}';
  //       }
  //       initialDate = DateTime.parse(dateText);
  //     } catch (e) {
  //       initialDate = DateTime.now();
  //     }
  //   }

  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: initialDate,
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2100),
  //   );

  //   if (picked != null) {
  //     setState(() {
  //       // Store in YYYY-MM-DD format directly
  //       controller.text =
  //           "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
  //     });
  //   }
  // }

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
      // if (_dateIn.text.isEmpty) {
      //   return 'Start Date is required';
      // }
      // if (_dateOut.text.isEmpty) {
      //   return 'End Date is required';
      // }
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
        await _service.updateUserWorkHistory(
          userId: widget.id ?? '',
          workId: widget.workId!,
          departmentId: selecteddepartmentId!,
          organizatioId: selectedOganizationId!,
          generalDepartmentId: null,
          officeId: selectedOfficeId,
          positionId: selectedpossitionId,
          rankPositionId: selectedRankPositionId,
          startWorkingAt: convertDateForApi(_dateIn.text),
          stopWorkingAt: convertDateForApi(_dateOut.text),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ការស្នើសុំត្រូវបានបញ្ជូនដោយជោគជ័យ')),
          );
          // _clearAllFields();
          Provider.of<WorkProvider>(context, listen: false).getHome();
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
      print('Date conversion error: $e');
      return dateString; // Return original if conversion fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => UpdateWorkHistoryProvider(
            userId: widget.id!, workId: widget.workId!),
        child: Consumer2<UpdateWorkHistoryProvider, SettingProvider>(
            builder: (context, provider, settingProvider, child) {
          _loadExistingData(provider, settingProvider);
          final department = _buildEducationSelectionMap(
              apiData: provider.dataSetup,
              dataKey: 'departments',
              settingProvider: settingProvider);
          final position = _buildEducationSelectionMap(
              apiData: provider.dataSetup,
              dataKey: 'positions',
              settingProvider: settingProvider);
          final lang =settingProvider.lang;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(AppLang.translate(
                  lang: settingProvider.lang ?? 'kh',
                  key: 'work_experience_update')),
              centerTitle: true,
              bottom: CustomHeader(),
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
            ),
            body: provider.isLoading
                ?  Center(
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
                   AppLang.translate(
                                        lang: lang ?? 'kh', key: 'waiting'),
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
                        padding: const EdgeInsets.all(15),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              // Date Picker Row
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: TextFormField(
                              //         controller: _dateIn,
                              //         readOnly: true,
                              //         decoration: InputDecoration(
                              //           labelText: AppLang.translate(
                              //               lang: settingProvider.lang ?? 'kh',
                              //               key: 'start_date'),
                              //           labelStyle:
                              //               TextStyle(color: Colors.blueGrey),
                              //           border: OutlineInputBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(12.0),
                              //             borderSide: BorderSide(
                              //                 color: Colors
                              //                     .blueGrey), // Normal border color
                              //           ),
                              //           enabledBorder: OutlineInputBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(12.0),
                              //             borderSide: BorderSide(
                              //                 color: Colors
                              //                     .blueGrey), // Enabled but not focused
                              //           ),
                              //           focusedBorder: OutlineInputBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(12.0),
                              //             borderSide: BorderSide(
                              //               color: Theme.of(context)
                              //                   .colorScheme
                              //                   .primary, // Focused border color
                              //               width: 2.0,
                              //             ),
                              //           ),
                              //           errorBorder: OutlineInputBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(12.0),
                              //             borderSide: BorderSide(
                              //                 color: Colors.red), // Error state
                              //           ),
                              //           focusedErrorBorder: OutlineInputBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(12.0),
                              //             borderSide: BorderSide(
                              //               color:
                              //                   Colors.red, // Focused error state
                              //               width: 2.0,
                              //             ),
                              //           ),
                              //           suffixIcon: IconButton(
                              //             icon: const Icon(Icons.calendar_today),
                              //             onPressed: () => _selectDate(_dateIn),
                              //           ),
                              //         ),
                              //         onTap: () => _selectDate(_dateIn),
                              //       ),
                              //     ),
                              //     const SizedBox(width: 8),
                              //     Expanded(
                              //       child: TextFormField(
                              //         controller: _dateOut,
                              //         readOnly: true,
                              //         decoration: InputDecoration(
                              //           labelText: AppLang.translate(
                              //             lang: settingProvider.lang ?? 'kh',
                              //             key: 'end_date',
                              //           ),
                              //           labelStyle:
                              //               TextStyle(color: Colors.blueGrey),
                              //           border: OutlineInputBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(12.0),
                              //             borderSide: BorderSide(
                              //                 color: Colors
                              //                     .blueGrey), // Normal border color
                              //           ),
                              //           enabledBorder: OutlineInputBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(12.0),
                              //             borderSide: BorderSide(
                              //                 color: Colors
                              //                     .blueGrey), // Enabled but not focused
                              //           ),
                              //           focusedBorder: OutlineInputBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(12.0),
                              //             borderSide: BorderSide(
                              //               color: Theme.of(context)
                              //                   .colorScheme
                              //                   .primary, // Focused border color
                              //               width: 2.0,
                              //             ),
                              //           ),
                              //           errorBorder: OutlineInputBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(12.0),
                              //             borderSide: BorderSide(
                              //                 color: Colors.red), // Error state
                              //           ),
                              //           focusedErrorBorder: OutlineInputBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(12.0),
                              //             borderSide: BorderSide(
                              //               color:
                              //                   Colors.red, // Focused error state
                              //               width: 2.0,
                              //             ),
                              //           ),
                              //           suffixIcon: IconButton(
                              //             icon: const Icon(Icons.calendar_today),
                              //             onPressed: () => _selectDate(_dateOut),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              Row(
                                children: [
                                  Expanded(
                                    child: DateInputField(
                                      label:AppLang.translate(
                                        lang: lang ?? 'kh', key: 'start_date'),
                                      hint: AppLang.translate(
                                        lang: lang ?? 'kh', key: 'please select date'),
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
                                      label: AppLang.translate(
                                        lang: lang ?? 'kh', key: 'end_date'),
                                      hint: AppLang.translate(
                                        lang: lang ?? 'kh', key: 'please select date'),
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
                              SizedBox(
                                height: 16,
                              ),
                              //Institution
                              _buildSelectionField(
                                controller: _place,
                                label: AppLang.translate(
                                    lang: lang ?? 'kh',
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
                ),
            // bottomNavigationBar: SafeArea(
            //   child: Padding(
            //     padding: const EdgeInsets.all(15),
            //     child: SizedBox(
            //       width: double.infinity,
            //       child: ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           padding: const EdgeInsets.symmetric(vertical: 12),
            //           backgroundColor: Colors.blue[900],
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(30),
            //           ),
            //         ),
            //         onPressed: () {
            //           _handleSubmit();
            //         },
            //         child: Text(
            //           AppLang.translate(
            //               lang: settingProvider.lang ?? 'kh', key: 'update'),
            //           style: TextStyle(fontSize: 16, color: Colors.white),
            //         ),
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

  // Reusable Selection Field widget
  Widget _buildSelectionField({
    required TextEditingController controller,
    required String label,
    required Map<String, String> items,
    required void Function(String id, String value) onSelected,
    String? selectedId, // Add selectedId parameter
    // required BuildContext context,
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
        // hintText: hint,
        suffixIcon: Icon(Icons.arrow_drop_down, color: HColors.darkgrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: HColors.darkgrey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(
          color: HColors.darkgrey,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          color: HColors.darkgrey,
        ),
      ),
      // decoration: InputDecoration(
      //   labelText: label,
      //   labelStyle: TextStyle(color: HColors.darkgrey),
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12.0),
      //     borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
      //   ),
      //   enabledBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12.0),
      //     borderSide: BorderSide(color: HColors.darkgrey),
      //   ),
      //   focusedBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12.0),
      //     borderSide: BorderSide(
      //         color: Theme.of(context).colorScheme.primary, width: 1.0),
      //   ),
      // suffixIcon: Icon(Icons.arrow_drop_down,
      //     color: Theme.of(context).colorScheme.primary),
      //   filled: true,
      // ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                        fontSize: 20,
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
                  horizontal: 8.0,
                  // vertical: 8.0,
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
                            // border: Border.all(
                            //   color: isSelected
                            //       ? HColors.darkgrey
                            //       : HColors.darkgrey,
                            //   width: isSelected ? 1.5 : 1.0,
                            // ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 12.0,
                            ),
                            child: Row(
                              children: [
                                // Icon(
                                //   Icons.person_2_outlined,
                                //   color: HColors.darkgrey,
                                //   size: 24,
                                // ),
                                // SizedBox(
                                //   width: 8,
                                // ),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w400,
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
