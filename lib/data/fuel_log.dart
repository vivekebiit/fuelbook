class FuelLog {
  final String mileage;
  final String odometer;
  final String amount;
  final DateTime date;
  final String litre;
  final String previousOdometer;
  final String diff;

  FuelLog(this.diff, this.mileage, this.previousOdometer, this.odometer,
      this.amount, this.litre, this.date);

  FuelLog.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        odometer = json['odometer'] as String,
        amount = json['amount'] as String,
        litre = json['litre'] as String,
        previousOdometer = json['previousOdometer'] as String,
        diff = json['diff'] as String,
        mileage = json['mileage'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'date': date.toString(),
        'mileage': mileage,
        'odometer': odometer,
        'amount': amount,
        'previousOdometer': previousOdometer,
        'diff': diff,
        'litre': litre
      };
}
