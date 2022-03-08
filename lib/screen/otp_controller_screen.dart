import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginphone/screen/alert_dialog.dart';
import 'package:loginphone/screen/dasboard_screen.dart';
import 'package:pinput/pinput.dart';

class OtpControllerScreen extends StatefulWidget {
  final String indic;
  final String phone;
  const OtpControllerScreen(
      {Key? key, required this.phone, required this.indic})
      : super(key: key);

  @override
  State<OtpControllerScreen> createState() => _OtpControllerScreenState();
}

class _OtpControllerScreenState extends State<OtpControllerScreen> {
  TextEditingController pinOtpController = TextEditingController();
  final BoxDecoration pinOtpDecoration = BoxDecoration(
    color: Colors.blueAccent,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: Colors.grey,
    ),
  );

  final FocusNode pinOtpFocus = FocusNode();
  final GlobalKey<ScaffoldState> scafoldkey = GlobalKey<ScaffoldState>();
  String? verifCode;

  verifierPhone() async {
    AlertLoading(context: context, message: "Vérification en cour....");
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "${widget.indic}${widget.phone}",
      verificationCompleted: (PhoneAuthCredential mycredential) async {
        await FirebaseAuth.instance
            .signInWithCredential(mycredential)
            .then((value) {
          if (value.user != null) {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) => DashboardScreen(phone: widget.phone)),
              ),
            );
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.message.toString(),
              style: const TextStyle(color: Colors.red),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      },
      codeSent: (String vID, int? resentToken) {
        //AlertLoading(context: context, message: "Vérification en cour....");
        setState(() {
          verifCode = vID;
        });
      },
      codeAutoRetrievalTimeout: (String vID) {
        //AlertLoading(context: context, message: "Vérification en cour....");
        setState(() {
          verifCode = vID;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }

  @override
  void initState() {
    super.initState();
    verifierPhone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldkey,
      appBar: AppBar(
        title: const Text("Verification OTP"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("images/otp.png"),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  verifierPhone();
                },
                child: Text(
                  "vérifier: ${widget.indic}-${widget.phone}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 14,
            width: MediaQuery.of(context).size.width / 1.2,
            child: Pinput(
              length: 6,
              defaultPinTheme: const PinTheme(
                textStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 25.0,
                ),
                height: 100.0,
                width: 100.0,
              ),
              focusNode: pinOtpFocus,
              controller: pinOtpController,
              submittedPinTheme: PinTheme(decoration: pinOtpDecoration),
              focusedPinTheme: PinTheme(decoration: pinOtpDecoration),
              followingPinTheme: PinTheme(decoration: pinOtpDecoration),
              pinAnimationType: PinAnimationType.rotation,
              onSubmitted: (pin) async {
                AlertLoading(
                    context: context, message: "Vérification en cour....");
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(
                    PhoneAuthProvider.credential(
                      verificationId: verifCode!,
                      smsCode: pin,
                    ),
                  )
                      .then((value) {
                    if (value.user != null) {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) =>
                              DashboardScreen(phone: widget.phone)),
                        ),
                      );
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Code OTP invalide ???",
                        style: TextStyle(color: Colors.red),
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
