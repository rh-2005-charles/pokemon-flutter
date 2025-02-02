import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

enum HTTP_STATES { INITIAL, LOADING, ERROR, SUCCESS }

class MiniPokedexPage extends StatefulWidget {
  const MiniPokedexPage({Key? key}) : super(key: key);

  @override
  State<MiniPokedexPage> createState() => _MiniPokedexPageState();
}

class _MiniPokedexPageState extends State<MiniPokedexPage> {
  List<Map<String, dynamic>> pkmns = [];
  int n = 1;
  HTTP_STATES state = HTTP_STATES.INITIAL; // loading, succes, error
  @override
  void initState() {
    super.initState();
    final dio = Dio();

    dio.get('https://pokeapi.co/api/v2/pokemon').then((value) {
      print("GET DATA FROM API");
      List<Map<String, dynamic>> pkmnsTmp = [];
      for (dynamic el in value.data["results"]) {
        pkmnsTmp.add(el);
      }
      Future.delayed(Duration(seconds: 2)).then((value) {
        setState(() {
          this.pkmns = pkmnsTmp;
          this.state = HTTP_STATES.SUCCESS;
        });
      });
    }).onError((error, stackTrace) {
      setState(() {
        this.state = HTTP_STATES.ERROR;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Pokedex XD")),
        body: stateController(state, context));
  }

  Widget stateController(HTTP_STATES state, BuildContext context) {
    switch (state) {
      case HTTP_STATES.SUCCESS:
        return bodyWithPkmns(context);
      case HTTP_STATES.ERROR:
        return error(context);
      case HTTP_STATES.INITIAL:
      case HTTP_STATES.LOADING:
      default:
        return loading(context);
    }
  }

  Widget loading(BuildContext context) {
    return Center(
      child: Text("Cargando, por favor espere"),
    );
  }

  Widget error(BuildContext context) {
    return Container(
        color: Colors.red,
        child: Center(
          child: Text("ERROR!!! NOS VAMOS A MORIR"),
        ));
  }

  Widget bodyWithPkmns(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: this.pkmns.map((e) {
            List<String> strList = (e["url"] as String).split("/");
            String pkmnId = strList[strList.length - 2];
            return Card(
                child: InkWell(
                    onTap: () {
                      setState(() {
                        n = n + 1;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.all(12),
                        width: double.maxFinite,
                        height: 120,
                        child: Row(
                          children: [
                            Image.network(
                              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pkmnId}.png",
                              width: 120,
                            ),
                            Text(e["name"]),
                          ],
                        ))));
          }).toList(),
        ),
      ),
    );
  }
}
