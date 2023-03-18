import 'package:database/database/controllers/user_db_controller.dart';
import 'package:database/models/response_process.dart';
import 'package:database/pref/shared_pref.dart';
import 'package:database/utils/extension.dart';
import 'package:database/utils/helper.dart';
import 'package:database/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../provider/language_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Helpers {
  late TextEditingController _emailEditingController;
  late TextEditingController _passwordEditingController;
  bool _obscureText = true;
  late String _language;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _language = SharedPerfController().language;
    _emailEditingController = TextEditingController();
    _passwordEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.login,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _selectedLanguage();
              },
              icon: const Icon(Icons.language)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.login_title,
              style: GoogleFonts.cairo(
                fontSize: 22.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(AppLocalizations.of(context)!.login_subtitle,
                style: GoogleFonts.cairo(
                    fontSize: 18.sp,
                    color: Colors.black38,
                    height: 1,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            AppTextField(
              textInputType: TextInputType.emailAddress,
              hintText: AppLocalizations.of(context)!.email,
              prefixIcon: Icons.email,
              controller: _emailEditingController,
            ),
            const SizedBox(
              height: 15,
            ),
            AppTextField(
              textInputType: TextInputType.text,
              hintText: AppLocalizations.of(context)!.password,
              prefixIcon: Icons.lock,
              obscure: _obscureText,
              controller: _passwordEditingController,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off)),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _performLogin();
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Text(
                AppLocalizations.of(context)!.login,
                style: GoogleFonts.cairo(fontSize: 16),
              ),
            ),
            Row(
              children: [
                Text(AppLocalizations.of(context)!.register_below),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register_screen');
                    },
                    child: Text(AppLocalizations.of(context)!.register_create))
              ],
            )
          ],
        ),
      ),
    );
  }

  void _selectedLanguage() async {
    String? langCode = await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        clipBehavior: Clip.antiAlias,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.change_language,
                            style: GoogleFonts.cairo(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                height: 1),
                          ),
                          Text(
                            AppLocalizations.of(context)!.selected_language,
                            style: GoogleFonts.cairo(
                              color: Colors.black87,
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                          ),
                          const Divider(),
                          RadioListTile<String>(
                              title: Text(
                                'English',
                                style: GoogleFonts.cairo(
                                  fontSize: 18,
                                ),
                              ),
                              value: 'en',
                              groupValue: _language,
                              onChanged: (String? value) {
                                setState(() {
                                  if (value != null) {
                                    _language = value;
                                  }
                                });
                                Navigator.pop(context, 'en');
                              }),
                          RadioListTile<String>(
                              title: Text(
                                'العربية',
                                style: GoogleFonts.cairo(
                                  fontSize: 18,
                                ),
                              ),
                              value: 'ar',
                              groupValue: _language,
                              onChanged: (String? value) {
                                setState(() {
                                  if (value != null) {
                                    _language = value;
                                  }
                                });
                                Navigator.pop(context, 'ar');
                              }),
                        ]),
                  );
                },
              );
            },
          );
        });
    if (langCode != null) {
      Provider.of<LanguageProvider>(context, listen: false).changeLanguage();
    }
  }

  void _performLogin() {
    if (_checkData()) {
      _login();
    }
  }

  bool _checkData() {
    if (_emailEditingController.text.isNotEmpty &&
        _passwordEditingController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: 'Enter required Data', error: true);
    return false;
  }

  Future<void> _login() async {
    ///TODO : Call database login function
    ProcessResponses processResponses = await UserDbController().login(
        email: _emailEditingController.text,
        password: _passwordEditingController.text);
    if (processResponses.success) {
      Navigator.pushReplacementNamed(context, '/products_screen');
    }
    context.showSnackBar(
        message: processResponses.message, error: !processResponses.success);
  }
}
