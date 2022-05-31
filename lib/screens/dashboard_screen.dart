import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuelbook/data/fuel_log.dart';
import 'package:fuelbook/data/fuel_logo_dao.dart';
import 'package:fuelbook/screens/message_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> milageList = [];

  TextEditingController odoMeterEditingController = TextEditingController();
  TextEditingController petrolPriceEditingController = TextEditingController();
  TextEditingController amountEditingController = TextEditingController();
  late SharedPreferences prefs;
  final ScrollController _scrollController = ScrollController();
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
      appBar: AppBar(title: const Text("Dasbhoard")),
      body: Column(
        children: [
          _getMessageList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => {
          _modalBottomSheetMenu(),
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _modalBottomSheetMenu() {
    int previousOdometerVal = prefs.getInt('odometer') ?? 0;
    String pertrolPrice = prefs.getString('petrol_price') ?? "";
    setState(() {
      petrolPriceEditingController.text = pertrolPrice;
    });

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: 350.0,
              color:
                  Colors.transparent, //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Previous Odometer Reading : $previousOdometerVal',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextField(
                            controller: odoMeterEditingController,
                            textInputAction: TextInputAction.done,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                                labelText: 'Current Odometer Reading',
                                hintText: 'Current Odometer Reading',
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
                            autofocus: false,
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: petrolPriceEditingController,
                                  decoration: const InputDecoration(
                                      labelText: 'Fuel Price',
                                      hintText: 'Fuel Price',
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
                                  autofocus: false,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: amountEditingController,
                                  decoration: const InputDecoration(
                                      labelText: 'Amount',
                                      hintText: 'Amount',
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
                                  autofocus: false,
                                  keyboardType: TextInputType.number,
                                  onChanged: (content) {
                                    var petrolPrice = double.parse(
                                        petrolPriceEditingController.text
                                            .toString());
                                    var amount = double.parse(
                                        amountEditingController.text
                                            .toString());
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(),
                                  onPressed: () {
                                    setState(() {
                                      var petrolPrice = double.parse(
                                          petrolPriceEditingController.text
                                              .toString());
                                      var amount = double.parse(
                                          amountEditingController.text
                                              .toString());
                                      var litter = amount / petrolPrice;
                                      var currentOdometer = int.parse(
                                          odoMeterEditingController.text
                                              .toString());

                                      var finalOdometerValue =
                                          currentOdometer - previousOdometerVal;

                                      var mileage = finalOdometerValue / litter;
                                      _sendMessage(
                                        finalOdometerValue.toString(),
                                        mileage.toStringAsFixed(2).toString(),
                                        previousOdometerVal.toString(),
                                        currentOdometer.toString(),
                                        amount.toString(),
                                        litter.toString(),
                                      );

                                      prefs.setString(
                                          'petrol_price',
                                          petrolPriceEditingController.text
                                              .toString());

                                      int odometer = int.parse(
                                          odoMeterEditingController.text
                                              .toString());
                                      prefs.setInt('odometer', odometer);
                                      amountEditingController.clear();
                                      odoMeterEditingController.clear();
                                      Navigator.pop(
                                        context,
                                        "This string will be passed back to the parent",
                                      );
                                    });
                                  },
                                  child: const Text('Save')))
                        ]),
                  )),
            ),
          );
        });
  }

  Widget _getMessageList() {
    return Expanded(
      child: FirebaseAnimatedList(
        controller: _scrollController,
        query: messageDao.getMessageQuery(),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          print(json);
          final message = FuelLog.fromJson(json);
          return MessageWidget(
              message.diff,
              message.mileage,
              message.previousOdometer,
              message.odometer,
              message.amount,
              message.date,
              message.litre);
        },
      ),
    );
  }

  void _sendMessage(String diff, String mileage, String previousOdometer,
      String odometer, String amount, String litre) {
    final message = FuelLog(diff, mileage, previousOdometer, odometer, amount,
        litre, DateTime.now());
    messageDao.saveMessage(message);
    setState(() {});
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
