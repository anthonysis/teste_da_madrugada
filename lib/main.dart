import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Musica',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Sportify Da Shoppe'),
        '/tela_de_perfil': (context) =>  TelaDePerfil(),
        '/tela_de_musica': (context) =>  TelaDeMusicas(),

      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/tela_de_perfil');
              },
              child: const Text('Perfil'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/tela_de_musica');
              },
              child: const Text('Musica'),
            ),

          ],
        ),
      ),

    );
  }
}
class ApiService {
  static const _baseUrl = 'https://api.vagalume.com.br';

  static Future<String> getLetraDaMusica(String nome, String artista) async {
    final response = await http.get(Uri.parse('$_baseUrl/search.php?art=$artista&mus=$nome'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['type'] == 'exact') {
        final idMusica = data['mus'][0]['id'];
        final responseLetra = await http.get(Uri.parse('$_baseUrl/search.php?musid=$idMusica'));

        if (responseLetra.statusCode == 200) {
          final dataLetra = json.decode(responseLetra.body);

          if (dataLetra['type'] == 'exact') {
            return dataLetra['mus'][0]['text'];
          }
        }
      }
    }

    return '';
  }
}


class TelaDePerfil extends StatefulWidget {
  @override
  _TelaDePerfilState createState() => _TelaDePerfilState();
}

class _TelaDePerfilState extends State<TelaDePerfil> {
  final _emailController = TextEditingController();
  final _perfilController = TextEditingController();

  void _limparCampos() {
    _perfilController.clear();
    _emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        actions: [
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2019/11/30/12/10/girl-4663125_1280.jpg'),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _perfilController,
            decoration: InputDecoration(
              hintText: 'Nome do usuário',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'E-mail do usuário',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 16),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            child: Text('Salvar'),
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: _limparCampos,
          ),

          SizedBox(height: 10),
          Text(
            'Informações do usuário:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            'Nome:',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            _perfilController.text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            'E-mail:',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            _emailController.text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
class LetraDaMusica extends StatelessWidget {
  final String letra;

  const LetraDaMusica({Key? key, required this.letra}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Letra da música'),
      ),
      body: Center(
        child: Text(
          letra,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}



class TelaDeMusicas extends StatelessWidget {
  final List<Map<String, dynamic>> _musicas = [
    {'nome': 'Liberdade Provisória', 'capa': 'https://cdn.pixabay.com/photo/2014/12/16/22/25/sunset-570881_1280.jpg'},
    {'nome': 'Barzinho Aleatório', 'capa': 'https://cdn.pixabay.com/photo/2013/11/12/01/29/bar-209148_1280.jpg'},
    {'nome': 'Graveto', 'capa': 'https://cdn.pixabay.com/photo/2016/12/31/17/26/smoke-1943398_1280.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de músicas'),
      ),
      body: ListView.builder(
        itemCount: _musicas.length,
        itemBuilder: (context, index) {
          final musica = _musicas[index];
          return ListTile(
            leading: Image.network(
              musica['capa'],
              width: 50,
              height: 50,
            ),
            title: Text(musica['nome']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LetraDaMusica(letra: 'Letra da música ${musica['nome']}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
