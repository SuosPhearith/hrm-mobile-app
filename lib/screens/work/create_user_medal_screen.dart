import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';

import 'package:mobile_app/providers/local/work/create_work_provider.dart';
import 'package:mobile_app/providers/local/work_provider.dart';

import 'package:mobile_app/services/work/create_work_service.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/shared/date/field_date.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/custom_header.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:provider/provider.dart';

class CreateUserMedalScreen extends StatefulWidget {
  const CreateUserMedalScreen({super.key, this.id});
  final String? id;
  @override
  State<CreateUserMedalScreen> createState() => _CreateUserMedalScreenState();
}

class _CreateUserMedalScreenState extends State<CreateUserMedalScreen> {
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //     GlobalKey<RefreshIndicatorState>();
  // Future<void> _refreshData(CreateWorkProvider provider) async {
  //   return await provider.getHome();
  // }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _givenDate = TextEditingController();
  final TextEditingController _medalType = TextEditingController();
  final TextEditingController _medal = TextEditingController();
  final TextEditingController _note = TextEditingController();

  final CreateWorkService _service = CreateWorkService();
  // Variables to store selected IDs
  DateTime? _startDate;
  String? selectedMedalId;
  String? selectedMedalTypeId;

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

  // Future<void> _selectDate(TextEditingController controller) async {
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2100),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       controller.text = "${picked.toLocal()}".split(' ')[0];
  //     });
  //   }
  // }

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
            key: 'create'),
        AppLang.translate(
            lang: Provider.of<SettingProvider>(context, listen: false).lang ??
                'kh',
            key: 'Are you sure to create'),
        DialogType.primary, () async {
      try {
        await _service.createUserMedal(
          userId: widget.id!,
          medalTypeId: selectedMedalTypeId!,
          medalId: selectedMedalId!,
          givenAt: DateFormat('yyyy-MM-dd').format(_startDate!),
          note: _note.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ការស្នើសុំត្រូវបានបញ្ជូនដោយជោគជ័យ')),
          );
          _clearAllControllers();
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CreateWorkProvider(),
        child: Consumer2<CreateWorkProvider, SettingProvider>(
            builder: (context, provider, settingProvider, child) {
          final medalType = _buildEducationSelectionMap(
              apiData: provider.dataSetup,
              dataKey: 'medal_types',
              settingProvider: settingProvider);
          final medals = _buildEducationSelectionMap(
              apiData: provider.dataSetup,
              dataKey: 'medals',
              settingProvider: settingProvider);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(AppLang.translate(
                  lang: settingProvider.lang ?? 'kh', key: 'medals_add')),
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
                ? Center(child: Text('Loading...'))
                : SafeArea(
                  child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // TextFormField(
                              //   controller: _givenDate,
                              //   readOnly: true,
                              //   decoration: InputDecoration(
                              //     labelText: AppLang.translate(
                              //         lang: settingProvider.lang ?? 'kh',
                              //         key: 'given date'),
                              //     labelStyle: TextStyle(color: Colors.blueGrey),
                              //     border: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(12.0),
                              //       borderSide: BorderSide(
                              //           color: Colors
                              //               .blueGrey), // Normal border color
                              //     ),
                              //     enabledBorder: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(12.0),
                              //       borderSide: BorderSide(
                              //           color: Colors
                              //               .blueGrey), // Enabled but not focused
                              //     ),
                              //     focusedBorder: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(12.0),
                              //       borderSide: BorderSide(
                              //         color: Theme.of(context)
                              //             .colorScheme
                              //             .primary, // Focused border color
                              //         width: 2.0,
                              //       ),
                              //     ),
                              //     errorBorder: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(12.0),
                              //       borderSide: BorderSide(
                              //           color: Colors.red), // Error state
                              //     ),
                              //     focusedErrorBorder: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(12.0),
                              //       borderSide: BorderSide(
                              //         color: Colors.red, // Focused error state
                              //         width: 2.0,
                              //       ),
                              //     ),
                              //     suffixIcon: IconButton(
                              //       icon: const Icon(Icons.calendar_today),
                              //       onPressed: () => _selectDate(_givenDate),
                              //     ),
                              //   ),
                              // ),
                              DateInputField(
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
            //             lang: settingProvider.lang ?? 'kh', key: 'create'),
            //         style: const TextStyle(fontSize: 16, color: Colors.white),
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
