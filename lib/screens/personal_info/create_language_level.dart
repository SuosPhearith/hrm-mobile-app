import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/personalinfo/create_education_provider.dart';
import 'package:mobile_app/services/personal_info/create_personalinfo_service.dart';
import 'package:mobile_app/shared/component/build_selection.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/custom_header.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:provider/provider.dart';

class CreateLanguageLevel extends StatefulWidget {
  const CreateLanguageLevel({super.key, this.id});
  final String? id;
  @override
  State<CreateLanguageLevel> createState() => _CreateLanguageLevelState();
}

class _CreateLanguageLevelState extends State<CreateLanguageLevel> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(CreateEducationProvider provider) async {
    return await provider.getHome();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _langauge = TextEditingController();
  final TextEditingController _speakingLevel = TextEditingController();
  final TextEditingController _readingLevel = TextEditingController();
  final TextEditingController _writtingLevel = TextEditingController();
  final TextEditingController _listeningLevel = TextEditingController();

  final CreatePersonalService _service = CreatePersonalService();
  // Variables to store selected IDs
  String? selectedLanguageId;
  String? selectedSpeakingLevelId;
  String? selectedReadingLevelId;
  String? selectedWritingLevelId;
  String? selectedListeningLevelId;

  @override
  void dispose() {
    _langauge.dispose();
    _speakingLevel.dispose();
    _readingLevel.dispose();
    _writtingLevel.dispose();
    _listeningLevel.dispose();
    super.dispose();
  }

  void _clearAllControllers() {
    _langauge.clear();
    _speakingLevel.clear();
    _readingLevel.clear();
    _writtingLevel.clear();
    _listeningLevel.clear();

    // Also clear any selected IDs if needed
    setState(() {
      selectedLanguageId = null;
      selectedSpeakingLevelId = null;
      selectedReadingLevelId = null;
      selectedWritingLevelId = null;
      selectedListeningLevelId = null;
    });
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate required fields
    if (selectedLanguageId == null ||
        selectedSpeakingLevelId == null ||
        selectedReadingLevelId == null ||
        selectedWritingLevelId == null ||
        selectedListeningLevelId == null) {
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
        await _service.createUserLanguage(
          userId: widget.id ?? '',
          languageId: selectedLanguageId!,
          speakingLevelId: selectedSpeakingLevelId!,
          writingLevelId: selectedWritingLevelId!,
          listeningLevelId: selectedListeningLevelId!,
          readingLevelId: selectedReadingLevelId!,
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
        create: (_) => CreateEducationProvider(),
        child: Consumer2<CreateEducationProvider, SettingProvider>(
            builder: (context, provider, settingProvider, child) {
          final languages = _buildEducationSelectionMap(
              apiData: provider.data,
              dataKey: 'languages',
              settingProvider: settingProvider);
          final proficiencyLevels = _buildEducationSelectionMap(
              apiData: provider.data,
              dataKey: 'language_levels',
              settingProvider: settingProvider);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                  AppLang.translate(lang: 'kh', key: 'user_info_language_add')),
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
                              // Language Selection
                              buildSelectionField(
                                context: context,
                                controller: _langauge,
                                label:
                                    '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'user_info_language')} *',
                                items: languages,
                                selectedId:
                                    selectedLanguageId, // Pass current selection
                                onSelected: (id, value) {
                                  setState(() {
                                    selectedLanguageId = id;
                                    _langauge.text = value;
                                  });
                                },
                              ),

                              const SizedBox(height: 16),

                              // Speaking and Reading Levels
                              Row(
                                children: [
                                  Expanded(
                                    child: buildSelectionField(
                                      controller: _speakingLevel,
                                      label:
                                          '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'speaking level')} *',
                                      items: proficiencyLevels,
                                      selectedId:
                                          selectedSpeakingLevelId, // Pass current selection
                                      onSelected: (id, value) {
                                        setState(() {
                                          selectedSpeakingLevelId = id;
                                          _speakingLevel.text = value;
                                        });
                                      },
                                      context: context,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: buildSelectionField(
                                      context: context,
                                      controller: _readingLevel,
                                      label:
                                          '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'reading level')} *',
                                      items: proficiencyLevels,
                                      selectedId:
                                          selectedReadingLevelId, // Pass current selection
                                      onSelected: (id, value) {
                                        setState(() {
                                          selectedReadingLevelId = id;
                                          _readingLevel.text = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Writing and Listening Levels
                              Row(
                                children: [
                                  Expanded(
                                    child: buildSelectionField(
                                      context: context,
                                      controller: _writtingLevel,
                                      label:
                                          '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'writting level')} *',
                                      items: proficiencyLevels,
                                      selectedId:
                                          selectedWritingLevelId, // Pass current selection
                                      onSelected: (id, value) {
                                        setState(() {
                                          selectedWritingLevelId = id;
                                          _writtingLevel.text = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: buildSelectionField(
                                      context: context,
                                      controller: _listeningLevel,
                                      label:
                                          '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'listenning level')} *',
                                      items: proficiencyLevels,
                                      selectedId:
                                          selectedListeningLevelId, // Pass current selection
                                      onSelected: (id, value) {
                                        setState(() {
                                          selectedListeningLevelId = id;
                                          _listeningLevel.text = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
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
}
