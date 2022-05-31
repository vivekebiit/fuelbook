import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuelbook/data/fuel_logo_dao.dart';
import 'package:fuelbook/screens/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  TextEditingController odometerEditingController = TextEditingController();
  late SharedPreferences prefs;
  final messageDao = MessageDao();

  @override
  void initState() {
    initSharedPref();
    super.initState();
  }

  initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: odometerEditingController,
              textInputAction: TextInputAction.done,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                  labelText: 'Odometer Start Reading',
                  hintText: 'Odometer Start Reading',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    width: 5,
                    color: Colors.red,
                    style: BorderStyle.solid,
                  ))),
              autofocus: true,
              onSubmitted: (value) {
                startDashboard();
              },
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () {
                      startDashboard();
                    },
                    child: const Text('Save')))
          ],
        ),
      ),
    );
  }

  void startDashboard() {
    int odometer = int.parse(odometerEditingController.text.toString());
    prefs.setInt('odometer', odometer);
    prefs.setBool('logged_in', true);

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const DashboardScreen()));
  }
}
