import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

String input;

const request = "https://api.hgbrasil.com/finance/stock_price?key=c30c7b02";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Color.fromARGB(255, 134, 218, 0),
        primaryColor: Color.fromARGB(255, 134, 218, 0)),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final inputTextController = TextEditingController();
  final showTextController = TextEditingController();

  double price;
  String name;

  void _change(String text) {
    input = "";
    input = text;
    showTextController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text("\$ Bolsas de Valores \$"),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 129, 226, 2)),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    "Carregando dados...",
                    style: TextStyle(
                        color: Color.fromARGB(255, 129, 226, 2),
                        fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Erro ao carregar dados...",
                      style: TextStyle(
                          color: Color.fromARGB(255, 129, 226, 2),
                          fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,
                              size: 150.0,
                              color: Color.fromARGB(255, 129, 226, 2)),
                          Divider(),
                          buildTextFormField(
                              "Simbolo", inputTextController, _change),
                          Divider(),
                          IconButton(
                              onPressed: () async {
                                try {
                                  String request =
                                      "https://api.hgbrasil.com/finance/stock_price?key=c30c7b02&symbol=" +
                                          input;
                                  http.Response response =
                                      await http.get(request);
                                  Map<dynamic, dynamic> snap =
                                      json.decode(response.body);
                                  price = snap["results"][input.toUpperCase()]
                                      ["price"];
                                  name = snap["results"][input.toUpperCase()]
                                      ["name"];
                                  showTextController.text = "Nome: " +
                                      name +
                                      "\n" +
                                      "Preço: " +
                                      price.toString();
                                } on NoSuchMethodError catch (e) {
                                  showTextController.text =
                                      "Símbolo não encontrado";
                                }
                              },
                              icon: Icon(
                                Icons.search,
                                size: 50,
                                color: Color.fromARGB(255, 129, 226, 2),
                              )),
                          Divider(),
                          Divider(),
                          TextField(
                              controller: showTextController,
                              decoration: InputDecoration.collapsed(
                                  hintText: "Insira um código",
                                  fillColor: Color.fromARGB(255, 129, 226, 2)),
                              style: TextStyle(
                                  color: Color.fromARGB(255, 129, 226, 2),
                                  fontSize: 30),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.none)
                        ],
                      ),
                    );
                  }
              }
            }));
  }

  Widget buildTextFormField(
      String label, TextEditingController controller, Function f) {
    return TextField(
      onChanged: f,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color.fromARGB(255, 129, 226, 2)),
        border: OutlineInputBorder(),
      ),
      style: TextStyle(color: Color.fromARGB(255, 129, 226, 2), fontSize: 25.0),
      keyboardType: TextInputType.text,
    );
  }
}