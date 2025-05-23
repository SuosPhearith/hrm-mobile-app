import 'package:flutter/material.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/personalinfo/update_personal_info_provider.dart';
import 'package:mobile_app/utils/help_util.dart';
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

  @override
  void dispose() {
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
  final List<Map<String, dynamic>> genderList = [
    {"id": 1, "name_kh": "ប្រុស", "name_en": "Male"},
    {"id": 2, "name_kh": "ស្រី", "name_en": "Female"},
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => UpdatePersonalInfoProvider(),
        child: Consumer2<UpdatePersonalInfoProvider, SettingProvider>(
            builder: (context, updatePersonalProvider, settingProvider, child) {
          final salute = updatePersonalProvider.data?.data['user']['salute'];
          int? selectedGenderId =
              updatePersonalProvider.data?.data['user']?['sex']?['id'];

          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title:
                  Text(AppLang.translate(key: 'user_info_update', lang: 'kh')),
              centerTitle: true,
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
                            TextFormField(
                              controller: txtSalute
                                ..text = salute != null
                                    ? AppLang.translate(
                                        data: salute,
                                        lang: settingProvider.lang ?? 'kh')
                                    : '',
                              decoration: InputDecoration(
                                labelText: AppLang.translate(
                                    key: "user_info_salute",
                                    lang: settingProvider.lang ?? 'kh'),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            // AppLang.translate(
                            //     lang: lang ?? 'kh',
                            //     key: getSafeString(
                            //         value: updatePersonalProvider
                            //             .data?.data['user']?['salute']['name_kh'],
                            //         safeValue: 'N/A')),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: txtKhName
                                      ..text = getSafeString(
                                          value: updatePersonalProvider
                                              .data?.data['user']?['name_kh'],
                                          safeValue: 'N/A'),
                                    decoration: InputDecoration(
                                      labelText: AppLang.translate(
                                          key: "user_info_kh_name", lang: 'kh'),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: txtEnName
                                      ..text = getSafeString(
                                        value: updatePersonalProvider
                                            .data?.data['user']?['name_en'],
                                        safeValue: 'N/A',
                                      ),
                                    decoration: InputDecoration(
                                      labelText: AppLang.translate(
                                          key: "user_info_en_name", lang: 'kh'),
                                      border: const OutlineInputBorder(),
                                    ),
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
                            TextFormField(
                              controller: txtPhone
                                ..text = getSafeString(
                                    value: updatePersonalProvider
                                        .data?.data['user']?['phone_number'],
                                    safeValue: 'N/A'),
                              decoration: InputDecoration(
                                labelText: AppLang.translate(
                                    key: "user_info_phone", lang: 'kh'),
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: txtEmail
                                ..text = getSafeString(
                                    value: updatePersonalProvider
                                        .data?.data['user']?['email'],
                                    safeValue: 'N/A'),
                              decoration: InputDecoration(
                                labelText: AppLang.translate(
                                    key: "user_info_email", lang: 'kh'),
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: txtIdentity
                                ..text = getSafeString(
                                    value: updatePersonalProvider.data
                                        ?.data['user']?['identity_card_number'],
                                    safeValue: 'N/A'),
                              decoration: InputDecoration(
                                labelText: AppLang.translate(
                                    key: "user_info_card_id", lang: 'kh'),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: txtDob
                                ..text = getSafeString(
                                    value: formatDate(updatePersonalProvider
                                        .data?.data['user']?['dob']),
                                    safeValue: 'N/A'),
                              decoration: InputDecoration(
                                labelText: AppLang.translate(
                                    key: "user_info_date_of_birth", lang: 'kh'),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () {
                                    // Show date picker logic here
                                  },
                                ),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: txtNote
                                ..text = getSafeString(
                                    value: updatePersonalProvider
                                        .data?.data['user']?['note'],
                                    safeValue: 'N/A'),
                              maxLines: null,
                              decoration: InputDecoration(
                                labelText: AppLang.translate(
                                    key: "user_info_note", lang: 'kh'),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // _buildAddressSection(
                            //     titleKey: "user_info_place_of_birth",
                            //     isCurrentAddress: false),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on_outlined),
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
                                  child: TextFormField(
                                    controller: txtDobProvince
                                      ..text = updatePersonalProvider
                                                      .data?.data['user']
                                                  ['pob_province'] !=
                                              null
                                          ? AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              data: updatePersonalProvider
                                                      .data?.data['user']
                                                  ['pob_province'])
                                          : 'N/A',
                                    decoration: InputDecoration(
                                      labelText: AppLang.translate(
                                          key: "user_info_province",
                                          lang: 'kh'),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: txtDobDistrict
                                      ..text = updatePersonalProvider
                                                      .data?.data['user']
                                                  ['pob_district'] !=
                                              null
                                          ? AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              data: updatePersonalProvider
                                                      .data?.data['user']
                                                  ['pob_district'])
                                          : 'N/A',
                                    decoration: InputDecoration(
                                      labelText: AppLang.translate(
                                          key: "user_info_district",
                                          lang: 'kh'),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: txtDobCommune
                                      ..text = updatePersonalProvider
                                                      .data?.data['user']
                                                  ['pob_commune'] !=
                                              null
                                          ? AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              data: updatePersonalProvider.data
                                                  ?.data['user']['pob_commune'])
                                          : 'N/A',
                                    decoration: InputDecoration(
                                      labelText: AppLang.translate(
                                          key: "user_info_commune", lang: 'kh'),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: txtDobVillage
                                      ..text = updatePersonalProvider
                                                      .data?.data['user']
                                                  ['pob_village'] !=
                                              null
                                          ? AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              data: updatePersonalProvider.data
                                                  ?.data['user']['pob_village'])
                                          : 'N/A',
                                    decoration: InputDecoration(
                                      labelText: AppLang.translate(
                                          key: "user_info_village", lang: 'kh'),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: txtDobStreetNumber
                                      ..text = updatePersonalProvider
                                                      .data?.data['user']
                                                  ['pob_street_number'] !=
                                              null
                                          ? AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              data: updatePersonalProvider
                                                      .data?.data['user']
                                                  ['pob_street_number'])
                                          : 'N/A',
                                    decoration: InputDecoration(
                                      labelText: AppLang.translate(
                                          key: "user_info_street", lang: 'kh'),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: txtDobHomeNumber
                                      ..text = updatePersonalProvider
                                                      .data?.data['user']
                                                  ['pob_home_number'] !=
                                              null
                                          ? AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              data: updatePersonalProvider
                                                      .data?.data['user']
                                                  ['pob_home_number'])
                                          : 'N/A',
                                    decoration: InputDecoration(
                                      labelText: AppLang.translate(
                                          key: "user_info_number", lang: 'kh'),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // _buildAddressSection(
                            //     titleKey: "user_info_current_address",
                            //     isCurrentAddress: true),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on_outlined),
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
                                  child: TextFormField(
                                    controller: txtProvince
                                      ..text = updatePersonalProvider.data
                                                  ?.data['user']['province'] !=
                                              null
                                          ? AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              data: updatePersonalProvider.data
                                                  ?.data['user']['province'])
                                          : 'N/A',
                                    decoration: InputDecoration(
                                      labelText: AppLang.translate(
                                          key: "user_info_province",
                                          lang: 'kh'),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: txtDistrict
                                      ..text = updatePersonalProvider.data
                                                  ?.data['user']['district'] !=
                                              null
                                          ? AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              data: updatePersonalProvider.data
                                                  ?.data['user']['district'])
                                          : 'N/A',
                                    decoration: InputDecoration(
                                      labelText: AppLang.translate(
                                          key: "user_info_district",
                                          lang: 'kh'),
                                      border: const OutlineInputBorder(),
                                    ),
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
                                  child: TextFormField(
                                    controller: txtCommune
                                      ..text = updatePersonalProvider.data
                                                  ?.data['user']['commune'] !=
                                              null
                                          ? AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              data: updatePersonalProvider.data
                                                  ?.data['user']['commune'])
                                          : 'N/A',
                                    decoration: InputDecoration(
                                      labelText: AppLang.translate(
                                          key: "user_info_commune", lang: 'kh'),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: txtVillage
                                      ..text = updatePersonalProvider.data
                                                  ?.data['user']['village'] !=
                                              null
                                          ? AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              data: updatePersonalProvider.data
                                                  ?.data['user']['village'])
                                          : 'N/A',
                                    decoration: InputDecoration(
                                      labelText: AppLang.translate(
                                          key: "user_info_village", lang: 'kh'),
                                      border: const OutlineInputBorder(),
                                    ),
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
                                  child: TextFormField(
                                    controller: txtStreetNumber
                                      ..text = updatePersonalProvider
                                                      .data?.data['user']
                                                  ['street_number'] !=
                                              null
                                          ? AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              data: updatePersonalProvider
                                                      .data?.data['user']
                                                  ['street_number'])
                                          : 'N/A',
                                    decoration: InputDecoration(
                                      labelText: AppLang.translate(
                                          key: "user_info_street", lang: 'kh'),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: txtHomeNumber
                                      ..text = updatePersonalProvider
                                                      .data?.data['user']
                                                  ['home_number'] !=
                                              null
                                          ? AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              data: updatePersonalProvider.data
                                                  ?.data['user']['home_number'])
                                          : 'N/A',
                                    decoration: InputDecoration(
                                      labelText: AppLang.translate(
                                          key: "user_info_number", lang: 'kh'),
                                      border: const OutlineInputBorder(),
                                    ),
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
                    // if (_formKey.currentState!.validate()) {
                    //   // Submit logic
                    // }
                  },
                  child:  Text(
                    AppLang.translate(lang: settingProvider.lang??'kh',key: 'update'),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
