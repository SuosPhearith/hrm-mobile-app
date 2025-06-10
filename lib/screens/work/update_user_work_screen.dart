import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/work/update_user_work_provider.dart';
import 'package:mobile_app/providers/local/work_provider.dart';

import 'package:mobile_app/services/work/create_work_service.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/shared/date/field_date.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/custom_header.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:provider/provider.dart';

class UpdateUserWorkScreen extends StatefulWidget {
  const UpdateUserWorkScreen({super.key, this.id, this.workId});
  final String? id;
  final String? workId;

  @override
  State<UpdateUserWorkScreen> createState() => _UpdateUserWorkScreenState();
}

class _UpdateUserWorkScreenState extends State<UpdateUserWorkScreen> {
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //     GlobalKey<RefreshIndicatorState>();
  // Future<void> _refreshData(UpdateUserWorkProvider provider) async {
  //   return await provider.getHome();
  // }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _idCard = TextEditingController();
  final TextEditingController _startWorkingAt = TextEditingController();
  final TextEditingController _appointmentAt = TextEditingController();
  final TextEditingController _rankPossition = TextEditingController();
  final TextEditingController _organization = TextEditingController();
  final TextEditingController _department = TextEditingController();
  final TextEditingController _office = TextEditingController();
  final TextEditingController _possition = TextEditingController();
  final TextEditingController _place = TextEditingController();
  final TextEditingController _staffType = TextEditingController();
  final TextEditingController _frameworkCategory = TextEditingController();
  final TextEditingController _salaryRankType = TextEditingController();
  final TextEditingController _salaryRankGroup = TextEditingController();
  final TextEditingController _certificateType = TextEditingController();
  final TextEditingController _major = TextEditingController();
  final TextEditingController _upgradedSalaryRankAt = TextEditingController();
  final TextEditingController _graduatedAt = TextEditingController();
  final TextEditingController _prakasNumber = TextEditingController();
  final TextEditingController _prakasAt = TextEditingController();
  final TextEditingController _note = TextEditingController();
  final TextEditingController _appointedAt = TextEditingController();

  // service
  final CreateWorkService _service = CreateWorkService();

  // Variables to store selected IDs
  String? selectedPlaceId;
  String? selectedOganizationId;
  String? selecteddepartmentId;
  String? selectedOfficeId;
  String? selectedpossitionId;
  String? selectedStaffTypeId;
  String? selectedRankPositionId;
  String? selectedFrameworkCategoryId;
  String? selectedSalaryRankTypeId;
  String? selectedSalaryRankGroupId;
  String? selectedCertificateTypeId;
  String? selectedMajorId;
  DateTime? _startDate;
  DateTime? _endDate;
  int _sort = 1;

  bool _isDataLoaded = false;
  @override
  void dispose() {
    _startWorkingAt.dispose();
    _rankPossition.dispose();
    _department.dispose();
    _appointmentAt.dispose();
    _organization.dispose();
    _office.dispose();
    _possition.dispose();
    _place.dispose();
    _id.dispose();
    _idCard.dispose();
    _staffType.dispose();
    _frameworkCategory.dispose();
    _salaryRankType.dispose();
    _salaryRankGroup.dispose();
    _certificateType.dispose();
    _major.dispose();
    _upgradedSalaryRankAt.dispose();
    _graduatedAt.dispose();
    _prakasNumber.dispose();
    _prakasAt.dispose();
    _note.dispose();
    _appointedAt.dispose();
    super.dispose();
  }

  // method to load existing data
  void _loadExistingData(
      UpdateUserWorkProvider provider, SettingProvider settingProvider) {
    if (_isDataLoaded || provider.data == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final workData = provider.data?.data;
      if (workData == null) return;

      setState(() {
        final currentLang = settingProvider.lang ?? 'kh';
        _id.text = getSafeString(value: workData['id_number'], safeValue: '');
        _idCard.text =
            getSafeString(value: workData['staff_card_number'], safeValue: '');
        _staffType.text = getSafeString(
            value: AppLang.translate(
                lang: settingProvider.lang ?? 'kh',
                data: workData['staff_type']),
            safeValue: '');
        final startDateStr = getSafeString(
            value: provider.data?.data['start_working_at'], safeValue: '');
        _startDate =
            startDateStr.isNotEmpty ? DateTime.tryParse(startDateStr) : null;
        final endDateStr = getSafeString(
            value: provider.data?.data['appointed_at'], safeValue: '');
        _endDate =
            endDateStr.isNotEmpty ? DateTime.tryParse(startDateStr) : null;
        // _startWorkingAt.text = formatDate(workData['start_working_at']);
        // _appointmentAt.text = formatDate(workData['appointed_at']);
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
        _appointedAt.text = formatDate(workData['appointed_at']);
        _upgradedSalaryRankAt.text =
            formatDate(workData['upgraded_salary_rank_at']);
        _graduatedAt.text = formatDate(workData['graduated_at']);
        _prakasNumber.text =
            getSafeString(value: workData['prakas_number'], safeValue: '');
        _prakasAt.text = formatDate(workData['prakas_at']);
        _note.text = getSafeString(value: workData['note_'], safeValue: '');
        _sort = workData['sort'] ?? 1;

        // Framework Category
        _frameworkCategory.text = currentLang == 'kh'
            ? (workData['framework_category']?['name_kh'] ??
                workData['framework_category']?['name_en'] ??
                '')
            : (workData['framework_category']?['name_en'] ??
                workData['framework_category']?['name_kh'] ??
                '');

        // Salary Rank Type
        _salaryRankType.text = currentLang == 'kh'
            ? (workData['salary_rank_type']?['name_kh'] ??
                workData['salary_rank_type']?['name_en'] ??
                '')
            : (workData['salary_rank_type']?['name_en'] ??
                workData['salary_rank_type']?['name_kh'] ??
                '');

        // Salary Rank Group
        _salaryRankGroup.text = currentLang == 'kh'
            ? (workData['salary_rank_group']?['name_kh'] ??
                workData['salary_rank_group']?['name_en'] ??
                '')
            : (workData['salary_rank_group']?['name_en'] ??
                workData['salary_rank_group']?['name_kh'] ??
                '');

        // Certificate Type
        _certificateType.text = currentLang == 'kh'
            ? (workData['certificate_type']?['name_kh'] ??
                workData['certificate_type']?['name_en'] ??
                '')
            : (workData['certificate_type']?['name_en'] ??
                workData['certificate_type']?['name_kh'] ??
                '');

        // Major
        _major.text = currentLang == 'kh'
            ? (workData['major']?['name_kh'] ??
                workData['major']?['name_en'] ??
                '')
            : (workData['major']?['name_en'] ??
                workData['major']?['name_kh'] ??
                '');
        // Set selected IDs
        // selectedPlaceId = workData['department']?['id'].toString();
        selectedOganizationId = workData['organization']?['id'].toString();
        selecteddepartmentId = workData['department']?['id'].toString();
        selectedOfficeId = workData['office']?['id'].toString();
        selectedpossitionId = workData['position']?['id'].toString();
        selectedRankPositionId = workData['rank_position']['id']?.toString();
        selectedStaffTypeId = workData['staff_type']['id'].toString();
        selectedFrameworkCategoryId =
            workData['framework_category']?['id'].toString();
        selectedSalaryRankTypeId =
            workData['salary_rank_type']?['id'].toString();
        selectedSalaryRankGroupId =
            workData['salary_rank_group']?['id'].toString();
        selectedCertificateTypeId =
            workData['certificate_type']?['id'].toString();
        selectedMajorId = workData['major']?['id'].toString();
        _isDataLoaded = true;
      });
    });
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

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
        await _service.updateUserWork(
          userId: widget.id ?? '',
          workId: widget.workId!,
          idNumber: _id.text,
          staffCardNumber: _idCard.text,
          staffTypeId: selectedStaffTypeId,
          organizationId: selectedOganizationId!,
          departmentId: selecteddepartmentId!,
          generalDepartmentId: null,
          officeId: selectedOfficeId,
          positionId: selectedpossitionId,
          rankPositionId: selectedRankPositionId,
          startWorkingAt: DateFormat('yyyy-MM-dd').format(_startDate!),
          appointedAt: DateFormat('yyyy-MM-dd').format(_endDate!),
          frameworkCategoryId: selectedFrameworkCategoryId,
          salaryRankTypeId: selectedSalaryRankTypeId,
          salaryRankGroupId: selectedSalaryRankGroupId,
          certificateTypeId: selectedCertificateTypeId,
          majorId: selectedMajorId,
          upgradedSalaryRankAt: convertDateForApi(_upgradedSalaryRankAt.text),
          graduatedAt: convertDateForApi(_graduatedAt.text),
          prakasNumber: _prakasNumber.text,
          prakasAt: convertDateForApi(_prakasAt.text),
          note: _note.text,
          attachmentId: null,
          sort: _sort,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ការស្នើសុំត្រូវបានបញ្ជូនដោយជោគជ័យ')),
          );
          Provider.of<WorkProvider>(context, listen: false).getHome();
          context.pop();
        }
      } catch (e) {
        if (e is DioException) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(parseErrorResponse(e.response?.data)['message']
                    ?['name_kh']),
              ),
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
        create: (_) =>
            UpdateUserWorkProvider(userId: widget.id!, workId: widget.workId!),
        child: Consumer2<UpdateUserWorkProvider, SettingProvider>(
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
          // final staffTypes = _buildEducationSelectionMap(
          //     apiData: provider.dataSetup,
          //     dataKey: 'staff_types',
          //     settingProvider: settingProvider);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(AppLang.translate(
                  lang: settingProvider.lang ?? 'kh', key: 'update_user_work')),
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
                ? const Center(child: Text('Loading...'))
                : SafeArea(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  // child: TextFormField(
                                  //   controller: txtStreetNumber,
                                  //   decoration: InputDecoration(
                                  //     labelText: AppLang.translate(
                                  //         key: "user_info_street", lang: 'kh'),
                                  //     border: const OutlineInputBorder(
                                  //       borderRadius: BorderRadius.all(
                                  //           Radius.circular(12.0)),
                                  //     ),
                                  //   ),
                                  // ),
                                  child: _buildTextField(
                                    controller: _id,
                                    label: AppLang.translate(
                                      lang: settingProvider.lang ?? 'kh',
                                      key: 'id_number',
                                    ),
                                    // keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  // child: TextFormField(
                                  //   controller: txtHomeNumber,
                                  //   decoration: InputDecoration(
                                  //     labelText: AppLang.translate(
                                  //         key: "user_info_number", lang: 'kh'),
                                  //     border: const OutlineInputBorder(
                                  //       borderRadius: BorderRadius.all(
                                  //           Radius.circular(12.0)),
                                  //     ),
                                  //   ),
                                  // ),
                                  child: _buildTextField(
                                    controller: _idCard,
                                    label: AppLang.translate(
                                      lang: settingProvider.lang ?? 'kh',
                                      key: 'staff_card_number',
                                    ),
                                    // keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            // Date Picker Row
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: TextFormField(
                            //         controller: _appointmentAt,
                            //         readOnly: true,
                            //         decoration: InputDecoration(
                            //           labelText: AppLang.translate(
                            //             lang: settingProvider.lang ?? 'kh',
                            //             key: 'appointed_at',
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
                            //             onPressed: () =>
                            //                 _selectDate(_appointmentAt),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //     const SizedBox(width: 8),
                            //     Expanded(
                            //       child: TextFormField(
                            //         controller: _startWorkingAt,
                            //         readOnly: true,
                            //         decoration: InputDecoration(
                            //           labelText: AppLang.translate(
                            //               lang: settingProvider.lang ?? 'kh',
                            //               key: 'start_working_at'),
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
                            //             onPressed: () =>
                            //                 _selectDate(_startWorkingAt),
                            //           ),
                            //         ),
                            //         onTap: () => _selectDate(_startWorkingAt),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(height: 16),
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
                            SizedBox(
                              height: 16,
                            ),
                            // //Institution
                            // _buildSelectionField(
                            //   controller: _place,
                            //   label: AppLang.translate(
                            //       lang: settingProvider.lang ?? 'kh',
                            //       key: 'institutions'),
                            //   items: department,
                            //   selectedId:
                            //       selectedPlaceId, // Pass current selection
                            //   onSelected: (id, value) {
                            //     setState(() {
                            //       selectedPlaceId = id;
                            //       _place.text = value;
                            //     });
                            //   },
                            // ),
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
                            // // staffType
                            // _buildSelectionField(
                            //   controller: _staffType,
                            //   label: AppLang.translate(
                            //       lang: settingProvider.lang ?? 'kh',
                            //       key: 'staff_type'),
                            //   items: staffTypes,
                            //   selectedId:
                            //       selectedStaffTypeId, // Pass current selection
                            //   onSelected: (id, value) {
                            //     setState(() {
                            //       selectedStaffTypeId = id;
                            //       _staffType.text = value;
                            //     });
                            //   },
                            // ),
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

  // // Reusable Selection Field widget
  // Widget _buildSelectionField({
  //   required TextEditingController controller,
  //   required String label,
  //   required Map<String, String> items,
  //   required void Function(String id, String value) onSelected,
  //   String? selectedId, // Add selectedId parameter
  // }) {
  //   return TextFormField(
  //     controller: controller,
  //     readOnly: true,
  //     onTap: () async {
  //       await _showSelectionBottomSheet(
  //         context: context,
  //         title: label,
  //         items: items,
  //         onSelected: onSelected,
  //         //  selectedId: selectedEducationrankPossitionId, // Pass current selection
  //         selectedId: selectedId, // Pass current selection
  //       );
  //     },
  //     decoration: InputDecoration(
  //       labelText: label,
  //       labelStyle: TextStyle(color: Colors.blueGrey),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12.0),
  //         borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12.0),
  //         borderSide: BorderSide(color: Colors.blueGrey),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12.0),
  //         borderSide: BorderSide(
  //             color: Theme.of(context).colorScheme.primary, width: 1.0),
  //       ),
  //       suffixIcon: Icon(Icons.arrow_drop_down,
  //           color: Theme.of(context).colorScheme.primary),
  //       filled: true,
  //     ),
  //   );
  // }
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

  // Widget _buildTextField({
  //   required TextEditingController controller,
  //   required String label,
  //   String? Function(String?)? validator,
  //   bool readOnly = false,
  //   VoidCallback? onTap,
  //   Widget? suffixIcon,
  //   int maxLines = 1,
  //   TextInputType? keyboardType,
  // }) {
  //   return TextFormField(
  //     controller: controller,
  //     readOnly: readOnly,
  //     onTap: onTap,
  //     validator: validator,
  //     maxLines: maxLines,
  //     keyboardType: keyboardType,
  //     decoration: InputDecoration(
  //       labelText: label,
  //       labelStyle: const TextStyle(color: Colors.blueGrey),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12.0),
  //         borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12.0),
  //         borderSide: const BorderSide(color: Colors.blueGrey),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12.0),
  //         borderSide: BorderSide(
  //             color: Theme.of(context).colorScheme.primary, width: 2.0),
  //       ),
  //       errorBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12.0),
  //         borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
  //       ),
  //       suffixIcon: suffixIcon,
  //       filled: true,
  //     ),
  //   );
  // }
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool readOnly = false,
    final TextInputType? keyboardType,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        // hintText: hint,
        // suffixIcon: Icon(Icons.calendar_today, color: HColors.darkgrey),
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
    );
  }
}
