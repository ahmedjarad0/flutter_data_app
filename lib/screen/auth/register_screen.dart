import 'package:database/database/controllers/user_db_controller.dart';
import 'package:database/models/response_process.dart';
import 'package:database/models/user.dart';
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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Helpers {
  late TextEditingController _emailEditingController;
  late TextEditingController _nameEditingController;
  late TextEditingController _passwordEditingController;
  bool _obscureText = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailEditingController = TextEditingController();
    _passwordEditingController = TextEditingController();
    _nameEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    _nameEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.register,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.register_title,
              style: GoogleFonts.cairo(
                fontSize: 22.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(AppLocalizations.of(context)!.register_subtitle,
                style: GoogleFonts.cairo(
                    fontSize: 18.sp,
                    color: Colors.black38,
                    height: 1,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            AppTextField(
              textInputType: TextInputType.name,
              hintText: AppLocalizations.of(context)!.name,
              prefixIcon: Icons.person,
              controller: _nameEditingController,
            ),
            const SizedBox(
              height: 15,
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
                _performRegister();
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Text(
                AppLocalizations.of(context)!.register,
                style: GoogleFonts.cairo(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _performRegister() {
    if (_checkData()) {
      _register();
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

  Future<void> _register() async {
    ///TODO : Call database register function
    ProcessResponses processResponses =
        await UserDbController().register(user: user);
    if (processResponses.success) {
      Navigator.pop(context);
    }
    context.showSnackBar(
        message: processResponses.message, error: !processResponses.success);
  }

  User get user {
    User user = User();
    user.name = _nameEditingController.text;
    user.email = _emailEditingController.text;
    user.password = _passwordEditingController.text;
    return user;
  }
}
