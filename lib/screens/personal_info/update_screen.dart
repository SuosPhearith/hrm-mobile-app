import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/personal_info_provider.dart';
import 'package:mobile_app/providers/local/personalinfo/update_personal_info_provider.dart';
import 'package:mobile_app/services/personal_info/update_personal_info_service.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/shared/component/build_selection.dart';
import 'package:mobile_app/shared/component/build_text_filed.dart';
import 'package:mobile_app/shared/date/field_date.dart';

import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/custom_header.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:mobile_app/widgets/skeleton.dart';
import 'package:provider/provider.dart';

class UpdatePersonalInfoScreen extends StatefulWidget {
  const UpdatePersonalInfoScreen({super.key, this.id});
  final String? id;
  @override
  State<UpdatePersonalInfoScreen> createState() =>
      _UpdatePersonalInfoScreenState();
}

class _UpdatePersonalInfoScreenState extends State<UpdatePersonalInfoScreen> {
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //     GlobalKey<RefreshIndicatorState>();
  // Future<void> _refreshData(UpdatePersonalInfoProvider provider) async {
  //   return await provider.getHome();
  // }

  final UpdatePersonalInfoService _service = UpdatePersonalInfoService();
  bool _isDataLoaded = false;
  DateTime? _dob;
  // DateTime? _endDate;

  @override
  void dispose() {
    txtSalute.dispose();
    txtKhName.dispose();
    txtEnName.dispose();
    txtPhone.dispose();
    txtEmail.dispose();
    txtIdentity.dispose();
    txtNote.dispose();
    txtProvince.dispose();
    txtDistrict.dispose();
    txtCommune.dispose();
    txtVillage.dispose();
    txtStreetNumber.dispose();
    txtHomeNumber.dispose();
    txtDob.dispose();
    txtDobProvince.dispose();
    txtDobDistrict.dispose();
    txtDobCommune.dispose();
    txtDobVillage.dispose();
    txtDobStreetNumber.dispose();
    txtDobHomeNumber.dispose();
    super.dispose();
  }

  final txtSalute = TextEditingController();
  final txtKhName = TextEditingController();
  final txtEnName = TextEditingController();
  final txtPhone = TextEditingController();
  final txtEmail = TextEditingController();
  final txtIdentity = TextEditingController();
  final txtNote = TextEditingController();
  final txtProvince = TextEditingController();
  final txtDistrict = TextEditingController();
  final txtCommune = TextEditingController();
  final txtVillage = TextEditingController();
  final txtStreetNumber = TextEditingController();
  final txtHomeNumber = TextEditingController();
  final txtDob = TextEditingController();
  final txtDobProvince = TextEditingController();
  final txtDobDistrict = TextEditingController();
  final txtDobCommune = TextEditingController();
  final txtDobVillage = TextEditingController();
  final txtDobStreetNumber = TextEditingController();
  final txtDobHomeNumber = TextEditingController();

  //static data for gender selection
  String selectedGender = 'male';
  int? selectedGenderId;
  String? selectedSaluteId;
  final List<Map<String, dynamic>> genderList = [
    {"id": 1, "name_kh": "ប្រុស", "name_en": "Male"},
    {"id": 2, "name_kh": "ស្រី", "name_en": "Female"},
  ];

  // Method to load existing data into form fields
  void _loadExistingData(
      UpdatePersonalInfoProvider provider, SettingProvider settingProvider) {
    if (_isDataLoaded || provider.data?.data == null) return;

    final userData = provider.data!.data['user'];

    // Use post frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        // Load text fields
        txtSalute.text = userData['salute'] != null
            ? AppLang.translate(
                data: userData['salute'], lang: settingProvider.lang ?? 'kh')
            : '';
        txtKhName.text =
            getSafeString(value: userData['name_kh'], safeValue: '');
        txtEnName.text =
            getSafeString(value: userData['name_en'], safeValue: '');
        txtPhone.text =
            getSafeString(value: userData['phone_number'], safeValue: '');
        txtEmail.text = getSafeString(value: userData['email'], safeValue: '');
        txtIdentity.text = getSafeString(
            value: userData['identity_card_number'], safeValue: '');
        txtNote.text = getSafeString(value: userData['note'], safeValue: '');
        // Load Date of Birth
        final dobStr = getSafeString(value: userData['dob'], safeValue: '');
        _dob = dobStr.isNotEmpty ? DateTime.tryParse(dobStr) : null;

        // Load address fields - place of birth
        txtDobProvince.text = userData['pob_province'] != null
            ? AppLang.translate(
                lang: settingProvider.lang ?? 'kh',
                data: userData['pob_province'])
            : '';
        txtDobDistrict.text = userData['pob_district'] != null
            ? AppLang.translate(
                lang: settingProvider.lang ?? 'kh',
                data: userData['pob_district'])
            : '';
        txtDobCommune.text = userData['pob_commune'] != null
            ? AppLang.translate(
                lang: settingProvider.lang ?? 'kh',
                data: userData['pob_commune'])
            : '';
        txtDobVillage.text = userData['pob_village'] != null
            ? AppLang.translate(
                lang: settingProvider.lang ?? 'kh',
                data: userData['pob_village'])
            : '';
        txtDobStreetNumber.text = userData['pob_street_number'] != null
            ? AppLang.translate(
                lang: settingProvider.lang ?? 'kh',
                data: userData['pob_street_number'])
            : '';
        txtDobHomeNumber.text = userData['pob_home_number'] != null
            ? AppLang.translate(
                lang: settingProvider.lang ?? 'kh',
                data: userData['pob_home_number'])
            : '';

        // Load address fields - current address
        txtProvince.text = userData['province'] != null
            ? AppLang.translate(
                lang: settingProvider.lang ?? 'kh', data: userData['province'])
            : '';
        txtDistrict.text = userData['district'] != null
            ? AppLang.translate(
                lang: settingProvider.lang ?? 'kh', data: userData['district'])
            : '';
        txtCommune.text = userData['commune'] != null
            ? AppLang.translate(
                lang: settingProvider.lang ?? 'kh', data: userData['commune'])
            : '';
        txtVillage.text = userData['village'] != null
            ? AppLang.translate(
                lang: settingProvider.lang ?? 'kh', data: userData['village'])
            : '';
        txtStreetNumber.text = userData['street_number'] != null
            ? AppLang.translate(
                lang: settingProvider.lang ?? 'kh',
                data: userData['street_number'])
            : '';
        txtHomeNumber.text = userData['home_number'] != null
            ? AppLang.translate(
                lang: settingProvider.lang ?? 'kh',
                data: userData['home_number'])
            : '';

        // Load selected gender
        selectedGenderId = userData['sex']?['id'] is int
            ? userData['sex']['id'] as int
            : (userData['sex']?['id'] != null
                ? int.tryParse(userData['sex']['id'].toString())
                : null);

        selectedSaluteId = userData['salute']?['id']?.toString();

        _isDataLoaded = true;
      });
    });
  }

  void _handleSubmit() async {
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
        await _service.updatePersonalInfo(
          userId: widget.id!,
          nameKh: txtKhName.text,
          nameEn: txtEnName.text,
          phoneCode: '+855',
          phoneNumber: txtPhone.text,
          email: txtEmail.text,
          dob: DateFormat('yyyy-MM-dd').format(_dob!),
          identityCardNumber: txtIdentity.text,
          saluteId: selectedSaluteId?.toString(),
          sexId: selectedGenderId.toString(),
          statusCode: null,
          organizationId: null,
          officeId: null,
          positionId: null,
          rankPositionId: null,
          password: '',
          avatarId: null,

          // Current address fields
          homeNumber: txtHomeNumber.text,
          streetNumber: txtStreetNumber.text,
          villageCode: txtVillage.text,
          communeCode: txtCommune.text,
          districtCode: txtDistrict.text,
          provinceCode: txtProvince.text,

          // Place of birth address fields
          pobVillageCode: txtDobVillage.text,
          pobCommuneCode: txtDobCommune.text,
          pobDistrictCode: txtDobDistrict.text,
          pobProvinceCode: txtDobProvince.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ការស្នើសុំត្រូវបានបញ្ជូនដោយជោគជ័យ')),
          );
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => UpdatePersonalInfoProvider(),
        child: Consumer2<UpdatePersonalInfoProvider, SettingProvider>(
            builder: (context, updatePersonalProvider, settingProvider, child) {
          // Load existing data when provider data is available
          if (updatePersonalProvider.data?.data != null && !_isDataLoaded) {
            _loadExistingData(updatePersonalProvider, settingProvider);
          }
          final salutes =
              _buildSaluteSelectData(updatePersonalProvider, settingProvider);

          return Scaffold(
            // backgroundColor: Colors.grey[100],
            backgroundColor: Colors.white,
            // backgroundColor: HColors.darkgrey.withOpacity(0.1),
            appBar: AppBar(
              title:
                  Text(AppLang.translate(key: 'user_info_update', lang: 'kh')),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _handleSubmit();
                    },
                    child: Icon(
                      Icons.check,
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
              bottom: CustomHeader(),
            ),
            body: updatePersonalProvider.isLoading
                ? Center(
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
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TextFormField(
                              //   controller: txtSalute,
                              //   decoration: InputDecoration(
                              //     labelText: AppLang.translate(
                              //         key: "user_info_salute",
                              //         lang: settingProvider.lang ?? 'kh'),
                              //     border: OutlineInputBorder(
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(12.0)),
                              //     ),
                              //   ),
                              // ),
                              // Relative Type Selection
                              buildSelectionField(
                                context: context,
                                controller: txtSalute,
                                label: AppLang.translate(
                                    lang: settingProvider.lang ?? 'kh',
                                    key: 'user_info_salute'),
                                items: salutes,
                                selectedId: selectedSaluteId,
                                onSelected: (id, value) {
                                  setState(() {
                                    selectedSaluteId = id;
                                    txtSalute.text = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: buildTextField(
                                      controller: txtKhName,
                                      label:
                                          "${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'user_info_kh_name')} *",
                                      context: context,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: buildTextField(
                                      controller: txtEnName,
                                      label:
                                          "${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'user_info_en_name')} *",
                                      context: context,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: genderList.map((gender) {
                                  return Expanded(
                                    child: RadioListTile<int>(
                                      title: Text(gender['name_kh']),
                                      value: gender['id'],
                                      groupValue: selectedGenderId,
                                      onChanged: (int? value) {
                                        setState(() {
                                          selectedGenderId = value;
                                        });
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 24),
                              // TextFormField(
                              //   controller: txtPhone,
                              //   decoration: InputDecoration(
                              //     labelText: AppLang.translate(
                              //         key: "user_info_phone", lang: 'kh'),
                              //     border: const OutlineInputBorder(
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(12.0)),
                              //     ),
                              //   ),
                              //   keyboardType: TextInputType.phone,
                              // ),
                              buildTextField(
                                controller: txtPhone,
                                label: AppLang.translate(
                                    lang: settingProvider.lang ?? 'kh',
                                    key: 'user_info_phone'),
                                keyboardType: TextInputType.phone,
                                context: context,
                              ),
                              const SizedBox(height: 24),
                              // TextFormField(
                              //   controller: txtEmail,
                              //   decoration: InputDecoration(
                              //     labelText: AppLang.translate(
                              //         key: "user_info_email", lang: 'kh'),
                              //     border: const OutlineInputBorder(
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(12.0)),
                              //     ),
                              //   ),
                              //   keyboardType: TextInputType.emailAddress,
                              // ),
                              buildTextField(
                                controller: txtEmail,
                                label: AppLang.translate(
                                    lang: settingProvider.lang ?? 'kh',
                                    key: 'user_info_email'),
                                keyboardType: TextInputType.emailAddress,
                                context: context,
                              ),
                              const SizedBox(height: 24),
                              // TextFormField(
                              //   controller: txtIdentity,
                              //   decoration: InputDecoration(
                              //     labelText: AppLang.translate(
                              //         key: "user_info_card_id", lang: 'kh'),
                              //     border: const OutlineInputBorder(
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(12.0)),
                              //     ),
                              //   ),
                              // ),
                              buildTextField(
                                context: context,
                                controller: txtIdentity,
                                label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'user_info_card_id',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 24),

                              // Date of Birth
                              // buildTextField(
                              //   controller: txtDob,
                              // label: AppLang.translate(
                              //     lang: settingProvider.lang ?? 'kh',
                              //     key: 'user_info_date_of_birth'),
                              //   readOnly: true,
                              //   onTap: _selectDate,
                              //   suffixIcon: IconButton(
                              //     icon: Icon(
                              //       Icons.calendar_today_rounded,
                              //       color: Colors.grey,
                              //     ),
                              //     onPressed: _selectDate,
                              //   ),
                              // ),
                              DateInputField(
                                label: AppLang.translate(
                                    lang: settingProvider.lang ?? 'kh',
                                    key: 'user_info_date_of_birth'),
                                hint: 'សូមជ្រើសរើសកាលបរិច្ឆេទ',
                                initialDate: DateTime.now(),
                                selectedDate: _dob,
                                onDateSelected: (date) {
                                  setState(() {
                                    _dob = date;
                                  });
                                },
                              ),
                              const SizedBox(height: 24),
                              // TextFormField(
                              //   controller: txtNote,
                              //   maxLines: null,
                              //   decoration: InputDecoration(
                              //     labelText: AppLang.translate(
                              //         key: "user_info_note", lang: 'kh'),
                              //     border: const OutlineInputBorder(
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(12.0)),
                              //     ),
                              //   ),
                              // ),
                              buildTextField(
                                context: context,
                                controller: txtNote,
                                label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'user_info_note',
                                ),
                                // keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: HColors.darkgrey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: HColors.darkgrey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(AppLang.translate(
                                        key: "user_info_place_of_birth",
                                        lang: 'kh')),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    // child: TextFormField(
                                    //   controller: txtDobProvince,
                                    //   decoration: InputDecoration(
                                    //     labelText: AppLang.translate(
                                    //         key: "user_info_province",
                                    //         lang: 'kh'),
                                    //     border: const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(12.0)),
                                    //     ),
                                    //   ),
                                    // ),
                                    child: buildTextField(
                                      context: context,
                                      controller: txtDobProvince,
                                      label: AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'user_info_province',
                                      ),
                                      // keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    // child: TextFormField(
                                    //   controller: txtDobDistrict,
                                    //   decoration: InputDecoration(
                                    //     labelText: AppLang.translate(
                                    //         key: "user_info_district",
                                    //         lang: 'kh'),
                                    //     border: const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(12.0)),
                                    //     ),
                                    //   ),
                                    // ),
                                    child: buildTextField(
                                      context: context,
                                      controller: txtDobDistrict,
                                      label: AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'user_info_district',
                                      ),
                                      // keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    // child: TextFormField(
                                    //   controller: txtDobCommune,
                                    //   decoration: InputDecoration(
                                    //     labelText: AppLang.translate(
                                    //         key: "user_info_commune", lang: 'kh'),
                                    //     border: const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(12.0)),
                                    //     ),
                                    //   ),
                                    // ),
                                    child: buildTextField(
                                      context: context,
                                      controller: txtDobCommune,
                                      label: AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'user_info_commune',
                                      ),
                                      // keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    // child: TextFormField(
                                    //   controller: txtDobVillage,
                                    //   decoration: InputDecoration(
                                    //     labelText: AppLang.translate(
                                    //         key: "user_info_village", lang: 'kh'),
                                    //     border: const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(12.0)),
                                    //     ),
                                    //   ),
                                    // ),
                                    child: buildTextField(
                                      context: context,
                                      controller: txtDobVillage,
                                      label: AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'user_info_village',
                                      ),
                                      // keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    // child: TextFormField(
                                    //   controller: txtDobStreetNumber,
                                    //   decoration: InputDecoration(
                                    //     labelText: AppLang.translate(
                                    //         key: "user_info_street", lang: 'kh'),
                                    //     border: const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(12.0)),
                                    //     ),
                                    //   ),
                                    // ),
                                    child: buildTextField(
                                      context: context,
                                      controller: txtDobStreetNumber,
                                      label: AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'user_info_street',
                                      ),
                                      // keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    // child: TextFormField(
                                    //   controller: txtDobHomeNumber,
                                    //   decoration: InputDecoration(
                                    //     labelText: AppLang.translate(
                                    //         key: "user_info_number", lang: 'kh'),
                                    //     border: const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(12.0)),
                                    //     ),
                                    //   ),
                                    // ),
                                    child: buildTextField(
                                      context: context,
                                      controller: txtDobHomeNumber,
                                      label: AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'user_info_number',
                                      ),
                                      // keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: HColors.darkgrey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: HColors.darkgrey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(AppLang.translate(
                                        key: "user_info_current_address",
                                        lang: 'kh')),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    // child: TextFormField(
                                    //   controller: txtProvince,
                                    //   decoration: InputDecoration(
                                    //     labelText: AppLang.translate(
                                    //         key: "user_info_province",
                                    //         lang: 'kh'),
                                    //     border: const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(12.0)),
                                    //     ),
                                    //   ),
                                    // ),
                                    child: buildTextField(
                                      context: context,
                                      controller: txtProvince,
                                      label: AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'user_info_province',
                                      ),
                                      // keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    // child: TextFormField(
                                    //   controller: txtDistrict,
                                    //   decoration: InputDecoration(
                                    //     labelText: AppLang.translate(
                                    //         key: "user_info_district",
                                    //         lang: 'kh'),
                                    //     border: const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(12.0)),
                                    //     ),
                                    //   ),
                                    // ),
                                    child: buildTextField(
                                      context: context,
                                      controller: txtDistrict,
                                      label: AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'user_info_district',
                                      ),
                                      // keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    // child: TextFormField(
                                    //   controller: txtCommune,
                                    //   decoration: InputDecoration(
                                    //     labelText: AppLang.translate(
                                    //         key: "user_info_commune", lang: 'kh'),
                                    //     border: const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(12.0)),
                                    //     ),
                                    //   ),
                                    // ),
                                    child: buildTextField(
                                      context: context,
                                      controller: txtCommune,
                                      label: AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'user_info_commune',
                                      ),
                                      // keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    // child: TextFormField(
                                    //   controller: txtVillage,
                                    //   decoration: InputDecoration(
                                    //     labelText: AppLang.translate(
                                    //         key: "user_info_village", lang: 'kh'),
                                    //     border: const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(12.0)),
                                    //     ),
                                    //   ),
                                    // ),
                                    child: buildTextField(
                                      context: context,
                                      controller: txtVillage,
                                      label: AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'user_info_village',
                                      ),
                                      // keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
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
                                    child: buildTextField(
                                      context: context,
                                      controller: txtStreetNumber,
                                      label: AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'user_info_street',
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
                                    child: buildTextField(
                                      controller: txtHomeNumber,
                                      label: AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'user_info_number',
                                      ),
                                      context: context,
                                      // keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
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
            //         padding: const EdgeInsets.symmetric(vertical: 15),
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

  // Helper method to build relative types map from API data
  Map<String, String> _buildSaluteSelectData(
      UpdatePersonalInfoProvider provider, SettingProvider settingProvider) {
    final dataSetUp = provider.dataSetup?.data['salutes'];

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
}
