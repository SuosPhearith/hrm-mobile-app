import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/sample_provider.dart';
import 'package:mobile_app/services/personal_info/create_service.dart';
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
  Future<void> _refreshData(SampleProvider provider) async {
    return await provider.getHome();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _langauge = TextEditingController();
  final TextEditingController _speakingLevel = TextEditingController();
  final TextEditingController _readingLevel = TextEditingController();
  final TextEditingController _writtingLevel = TextEditingController();
  final TextEditingController _listeningLevel = TextEditingController();

  final CreatePersonalService _service = CreatePersonalService();

  String? selectedGender;
  String? selectedProvince;
  String? selectedDistrict;
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

  // Handle form submission
  Future<void> _handleSubmit() async {
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

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final result = await _service.createUserLanguage(
        userId: widget.id ?? '',
        languageId: selectedLanguageId!,
        speakingLevelId: selectedSpeakingLevelId!,
        writingLevelId: selectedWritingLevelId!,
        listeningLevelId: selectedListeningLevelId!,
        readingLevelId: selectedReadingLevelId!,
      );

      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('បង្កើតបានជោគជ័យ')),
      );

      Navigator.of(context).pop(result); // Return to previous screen
    } on DioException catch (dioError) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog

      String errorMessage = 'បញ្ហាក្នុងការបង្កើត';
      if (dioError.response?.data != null) {
        errorMessage += ': ${dioError.response?.data['message'] ?? ''}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('បញ្ហាមិនដឹងមូលហេតុ: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => SampleProvider(),
        child: Consumer2<SampleProvider, SettingProvider>(
            builder: (context, evaluateProvider, settingProvider, child) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text(
                  AppLang.translate(lang: 'kh', key: 'user_info_language_add')),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.blue[800],
              backgroundColor: Colors.white,
              onRefresh: () => _refreshData(evaluateProvider),
              child: evaluateProvider.isLoading
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
                              TextFormField(
                                controller: _langauge,
                                readOnly: true,
                                onTap: () async {
                                  await _showSelectionBottomSheet(
                                    context: context,
                                    title: AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'choose language'),
                                    items: languages,
                                    onSelected: (id, value) {
                                      setState(() {
                                        selectedLanguageId = id;
                                        _langauge.text = value;
                                      });
                                    },
                                  );
                                },
                                decoration: InputDecoration(
                                  labelText:
                                      "${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'user_info_language')} *",
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLang.translate(
                                        lang: settingProvider.lang ?? 'kh',
                                        key: 'please select language');
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Speaking and Reading Levels
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _speakingLevel,
                                      readOnly: true,
                                      onTap: () async {
                                        await _showSelectionBottomSheet(
                                          context: context,
                                          title: AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              key: 'speaking level'),
                                          items: proficiencyLevels,
                                          onSelected: (id, value) {
                                            setState(() {
                                              selectedSpeakingLevelId = id;
                                              _speakingLevel.text = value;
                                            });
                                          },
                                        );
                                      },
                                      decoration: InputDecoration(
                                        labelText:
                                            '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'speaking level')} *',
                                        border: OutlineInputBorder(),
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              key: 'please select level');
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _readingLevel,
                                      readOnly: true,
                                      onTap: () async {
                                        await _showSelectionBottomSheet(
                                          context: context,
                                          title: AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              key: 'reading level'),
                                          items: proficiencyLevels,
                                          onSelected: (id, value) {
                                            setState(() {
                                              selectedReadingLevelId = id;
                                              _readingLevel.text = value;
                                            });
                                          },
                                        );
                                      },
                                      decoration: InputDecoration(
                                        labelText:
                                            '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'reading level')} *',
                                        border: OutlineInputBorder(),
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              key: 'please select level');
                                        }
                                        return null;
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
                                    child: TextFormField(
                                      controller: _writtingLevel,
                                      readOnly: true,
                                      onTap: () async {
                                        await _showSelectionBottomSheet(
                                          context: context,
                                          title: AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              key: 'writting level'),
                                          items: proficiencyLevels,
                                          onSelected: (id, value) {
                                            setState(() {
                                              selectedWritingLevelId = id;
                                              _writtingLevel.text = value;
                                            });
                                          },
                                        );
                                      },
                                      decoration: InputDecoration(
                                        labelText:
                                            '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'writting level')} *',
                                        border: OutlineInputBorder(),
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              key: 'please select level');
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _listeningLevel,
                                      readOnly: true,
                                      onTap: () async {
                                        await _showSelectionBottomSheet(
                                          context: context,
                                          title: AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              key: 'listenning level'),
                                          items: proficiencyLevels,
                                          onSelected: (id, value) {
                                            setState(() {
                                              selectedListeningLevelId = id;
                                              _listeningLevel.text = value;
                                            });
                                          },
                                        );
                                      },
                                      decoration: InputDecoration(
                                        labelText:
                                            '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'listenning level')} *',
                                        border: OutlineInputBorder(),
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              key: 'please select level');
                                        }
                                        return null;
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
                  onPressed: _handleSubmit,
                  child: Text(
                    AppLang.translate(
                        lang: settingProvider.lang ?? 'kh', key: 'create'),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        }));
  }

  //static data
  final Map<String, String> languages = {
    '1': 'ភាសាខ្មែរ',
    '2': 'ភាសាអង់គ្លេស',
    '3': 'ភាសាចិន',
    '4': 'ភាសាថៃ',
    '5': 'ភាសាបារាំង',
  };

  final Map<String, String> proficiencyLevels = {
    '1': 'កម្រិតដំបូង',
    '2': 'កម្រិតមធ្យម',
    '3': 'កម្រិតខ្ពស់',
    '4': 'ជាភាសាកំណើត',
  };

  //bottom sheet selector
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
              child: ListView(
                children: items.entries
                    .map((entry) => ListTile(
                          title: Text(entry.value),
                          onTap: () {
                            onSelected(entry.key, entry.value);
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
