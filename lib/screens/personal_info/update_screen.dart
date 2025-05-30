import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/personalinfo/update_personal_info_provider.dart';
import 'package:mobile_app/services/personal_info/update_personal_info_service.dart';


import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/custom_header.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:provider/provider.dart';

class UpdatePersonalInfoScreen extends StatefulWidget {
  const UpdatePersonalInfoScreen({super.key, this.id});
  final String? id;
  @override
  State<UpdatePersonalInfoScreen> createState() =>
      _UpdatePersonalInfoScreenState();
}

class _UpdatePersonalInfoScreenState extends State<UpdatePersonalInfoScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(UpdatePersonalInfoProvider provider) async {
    return await provider.getHome();
  }

  final UpdatePersonalInfoService _service = UpdatePersonalInfoService();
  bool _isDataLoaded = false;

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
        txtDob.text =
            getSafeString(value: formatDate(userData['dob']), safeValue: '');

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
          dob: convertDateForApi(txtDob.text),
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

  Future<void> _selectDate() async {
    // Parse existing date if available
    DateTime? initialDate;
    if (txtDob.text.isNotEmpty && txtDob.text != 'N/A') {
      try {
        initialDate = DateTime.parse(txtDob.text);
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
        txtDob.text = "${picked.toLocal()}".split(' ')[0];
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
      print('Date conversion error: $e');
      return dateString; // Return original if conversion fails
    }
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
            appBar: AppBar(
              title:
                  Text(AppLang.translate(key: 'user_info_update', lang: 'kh')),
              centerTitle: true,
              bottom: CustomHeader(),
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.blue[800],
              backgroundColor: Colors.white,
              onRefresh: () => _refreshData(updatePersonalProvider),
              child: updatePersonalProvider.isLoading
                  ? Center(child: Text('Loading...'))
                  : SingleChildScrollView(
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
                            _buildSelectionField(
                              controller: txtSalute,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'user_info_salute'),
                              items: salutes,
                              onSelected: (id, value) {
                                setState(() {
                                  selectedSaluteId = id;
                                  txtSalute.text = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: txtKhName,
                                    label:
                                        "${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'user_info_kh_name')} *",
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    controller: txtEnName,
                                    label:
                                        "${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'user_info_en_name')} *",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
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
                            const SizedBox(height: 16),
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
                            _buildTextField(
                              controller: txtPhone,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'user_info_phone'),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
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
                            _buildTextField(
                              controller: txtEmail,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'user_info_email'),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
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
                            _buildTextField(
                              controller: txtIdentity,
                              label: AppLang.translate(
                                lang: settingProvider.lang ?? 'kh',
                                key: 'user_info_card_id',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),

                            // Date of Birth
                            _buildTextField(
                              controller: txtDob,
                              label: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'user_info_date_of_birth'),
                              readOnly: true,
                              onTap: _selectDate,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.grey,
                                ),
                                onPressed: _selectDate,
                              ),
                            ),
                            const SizedBox(height: 16),
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
                            _buildTextField(
                              controller: txtNote,
                              label: AppLang.translate(
                                lang: settingProvider.lang ?? 'kh',
                                key: 'user_info_note',
                              ),
                              // keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(AppLang.translate(
                                      key: "user_info_place_of_birth",
                                      lang: 'kh')),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
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
                                  child: _buildTextField(
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
                                  child: _buildTextField(
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
                            const SizedBox(height: 15),
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
                                  child: _buildTextField(
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
                                  child: _buildTextField(
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
                            const SizedBox(height: 15),
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
                                  child: _buildTextField(
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
                                  child: _buildTextField(
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
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.grey,
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
                                  child: _buildTextField(
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
                                  child: _buildTextField(
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
                                  child: _buildTextField(
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
                                  child: _buildTextField(
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
                                  child: _buildTextField(
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
                                  child: _buildTextField(
                                    controller: txtHomeNumber,
                                    label: AppLang.translate(
                                      lang: settingProvider.lang ?? 'kh',
                                      key: 'user_info_number',
                                    ),
                                    // keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
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
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    _handleSubmit();
                  },
                  child: Text(
                    AppLang.translate(
                        lang: settingProvider.lang ?? 'kh', key: 'update'),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    int maxLines = 1,
    TextInputType? keyboardType,
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
}
