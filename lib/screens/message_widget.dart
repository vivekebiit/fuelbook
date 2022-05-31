import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageWidget extends StatelessWidget {
  final String mileage;
  final String odometer;
  final String amount;
  final DateTime date;
  final String litre;
  final String previousOdometer;
  final String diff;

  const MessageWidget(this.diff, this.mileage, this.previousOdometer,
      this.odometer, this.amount, this.date, this.litre);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
        child: Card(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Meter Reading',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const Spacer(),
                        Text(odometer),
                        const Text(
                          " Km",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Previous Meter Reading',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const Spacer(),
                        Text(previousOdometer),
                        const Text(
                          " Km",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fuel Quantity',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const Spacer(),
                        Text(litre),
                        const Text(
                          " L",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Fuel Price',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const Spacer(),
                        Text(amount),
                        const Text(
                          " INR",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fuel Mileage',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const Spacer(),
                        Text(mileage),
                        const Text(
                          " Km/L",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('yyyy-MM-dd, kk:mm a')
                            .format(date)
                            .toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_sharp),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
