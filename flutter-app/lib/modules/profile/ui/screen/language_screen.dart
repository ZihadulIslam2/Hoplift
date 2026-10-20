import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_gap.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/text_style.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool fromOnboarding;
  const LanguageSelectionScreen._({super.key, required this.fromOnboarding});

  factory LanguageSelectionScreen.fromOnboarding({bool fromOnboarding = false}) => LanguageSelectionScreen._(fromOnboarding: fromOnboarding);
  factory LanguageSelectionScreen.general() => LanguageSelectionScreen._(fromOnboarding: false);
  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  int _selectedIndex = -1;

  final List<Map<String, String>> languages = [
    {"label": "English", "flag": "🇺🇸", "locale": "en"},
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale');

    if (savedLocale != null) {
      final index = languages.indexWhere((lang) => lang['locale'] == savedLocale);
      if (index != -1) {
        setState(() {
          _selectedIndex = index;
        });
      }
    }
  }

  Future<void> _saveLanguage() async {
    if (_selectedIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a language.'.tr(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final selectedLocaleCode = languages[_selectedIndex]['locale']!;
    final selectedLanguageName = languages[_selectedIndex]['label']!;

    await context.setLocale(Locale(selectedLocaleCode));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', selectedLocaleCode);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Language has been set to $selectedLanguageName'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context); // ✅ Go back to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose your language".tr(),),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Gap.h16,
              if(widget.fromOnboarding) Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "You can change this later in settings".tr(),
                      style: AppText.smRegular_14_400.copyWith(
                        color: AppColors.secondaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gap.h24,
                ],
              ),
              
              Expanded(
                child: ListView.separated(
                  itemCount: languages.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: Colors.white10, height: 1),
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    return ListTile(
                      leading: Text(
                        lang['flag']!,
                        style: const TextStyle(fontSize: 20),
                      ),
                      title: Text(
                        lang['label']!,
                        style: const TextStyle(
                          color: AppColors.primaryTextblack,
                          fontSize: 16,
                        ),
                      ),
                      trailing: _selectedIndex == index
                          ? const Icon(Icons.check,
                              color: AppColors.primarybutton)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    );
                  },
                ),
              ),
              Gap.h24,
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveLanguage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primarybutton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Save'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
