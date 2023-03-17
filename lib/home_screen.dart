import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Biometrics Authentication'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (_supportState)
            const Text('This device is supported')
          else
            const Text('This device is not supported'),

          const Divider(height: 100),
          // get avaiable biometrics type
          ElevatedButton(
            onPressed: _getAvailableBiometrics,
            child: const Text('Get available biometrics'),
          ),

          // const Divider(height: 100),
          // // Authenticate
          // ElevatedButton(
          //   onPressed: _authenticate,
          //   child: Text('Authenticate'),
          // )
        ],
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason:
            'Subcribe or you will never find any stack overflow answer',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      print("Authenticated : $authenticated");
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) {
      return;
    }
    // we can call setState here
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    print("List of availableBiometrics : $availableBiometrics");

    if (!mounted) {
      return;
    }
    // than we can call setState
  }
}
