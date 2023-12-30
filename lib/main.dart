import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CurrencyConverter(),
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  TextEditingController amountController = TextEditingController();

  String dropdownValue1 = 'USD';
  String dropdownValue2 = 'INR';
  String convertedValue = '';

  Future<double> getConvertedValue(String amount, String from, String to) async {
    var response = await http.get(
        Uri.parse("https://api.exchangerate-api.com/v4/latest/USD?base=${from}&symbols=${to}"));

    var data = jsonDecode(response.body);
    double rate = data['rates'][to];
    double convertedAmount = double.parse(amount) * rate;
    return convertedAmount;
  }

  void _handleSubmit() async {
    double amount = double.parse(amountController.text);
    String from = dropdownValue1;
    String to = dropdownValue2;
    double convertedAmount = await getConvertedValue(amount.toString(), from, to);
    setState(() {
      convertedValue = convertedAmount.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.circular(5),
    );
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        title: Text('Currency Converter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                iconSize: 50,
                value: dropdownValue1,
                onChanged: (String? newValue) => setState(() {
                    dropdownValue1 = newValue!;
                  }),
                items: <String>['USD', 'EUR', 'GBP', 'INR']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Amount',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(10),
                iconSize: 50,
                value: dropdownValue2,
                onChanged: (String? newValue) => setState(() {
                  dropdownValue2 = newValue!;
                }),
                items: <String>['USD', 'EUR', 'GBP', 'INR']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 44, 42, 42),
                    foregroundColor: Color.fromARGB(255, 236, 230, 230),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                   
                  ),
                child: Text('Convert'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(26.0),
              child: Text('Converted Value: $convertedValue   $dropdownValue2', 
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}