import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:loginphone/screen/otp_controller_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String indicatifPays = "+00";
  TextEditingController numero = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28.0, right: 28.0),
              child: Image.asset("images/login.jpg"),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
              ),
              child: const Center(
                child: Text(
                  "Authentification OTP",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 400,
              height: 60,
              child: CountryCodePicker(
                onChanged: (country) {
                  setState(() {
                    indicatifPays = country.dialCode!;
                  });
                },
                initialSelection: "IT",
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                favorite: const ["+225", "CI", "+1", "US"],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
              ),
              child: TextFormField(
                controller: numero,
                decoration: InputDecoration(
                  hintText: "Numéro",
                  prefix: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(indicatifPays),
                  ),
                ),
                maxLength: 12,
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => OtpControllerScreen(
                            phone: numero.text,
                            indic: indicatifPays,
                          )),
                    ),
                  );
                },
                child: const Text(
                  "Suivant",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
