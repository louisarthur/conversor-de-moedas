import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

class ConversorScreen extends StatefulWidget {
  @override
  _ConversorScreenState createState() => _ConversorScreenState();
}

class _ConversorScreenState extends State<ConversorScreen> {
  TextEditingController _realController = TextEditingController();
  TextEditingController _dolarController = TextEditingController();
  TextEditingController _euroController = TextEditingController();
  final String urlRequest =
      'https://api.hgbrasil.com/finance?format=json&key=48833b20';

  double dolar;
  double euro;
  Future<Map> _getApi() async {
    Dio dio = Dio();
    Response response = await dio.get(urlRequest);
    return response.data;
  }

  void _clearControllers() {
    _realController.clear();
    _dolarController.clear();
    _euroController.clear();
  }

  void _realChanged(text) {
    double real = double.parse(text);
    _dolarController.text = (real / dolar).toStringAsFixed(2);
    _euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(text) {
    double dolar = double.parse(text);
    _realController.text = (dolar * this.dolar).toStringAsFixed(2);
    _euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(text) {
    double euro = double.parse(text);
    _realController.text = (euro * this.euro).toStringAsFixed(2);
    _dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Color(0xFFFFFFfF),
              ),
              onPressed: _clearControllers)
        ],
        title: Text('Conversor de Moedas',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
            )),
        centerTitle: true,
        backgroundColor: Color(0xFF7159C1),
      ),
      body: _body,
    );
  }

  Widget get _body {
    return FutureBuilder<Map>(
      future: _getApi(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Icon(Icons.show_chart_rounded,
                  size: 150, color: Color(0xFF7159C1)),
            );
          default:
            if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar dados'));
            } else {
              dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
              euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
              return SingleChildScrollView(
                child: Padding(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.show_chart_rounded,
                              size: 150, color: Color(0xFF7159C1)),
                          BuilderTextField(
                              "Real", "R\$", _realController, _realChanged),
                          BuilderTextField(
                              "Dolar", "\$", _dolarController, _dolarChanged),
                          BuilderTextField(
                              "Euro", "€", _euroController, _euroChanged),
                        ]),
                    padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0)),
              );
            }
        }
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget BuilderTextField(String coin, String symble,
      TextEditingController controler, Function changeFunction) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: TextField(
          onChanged: changeFunction,
          controller: controler,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: coin,
              prefixText: symble,
              labelStyle: TextStyle(color: Color(0xFF7159C1)),
              border: OutlineInputBorder()),
        ));
  }
}
