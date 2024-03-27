import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bar_chart.dart';
import 'pie_chart.dart';
import 'package:collection/collection.dart';
import 'line_chart.dart'; // Asegúrate de importar el archivo correcto

import 'post_modal.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<dynamic> dataPosts =
      []; // Variable global para almacenar los datos de los posts

  Future<List<dynamic>> _loadData() async {
    final response = await http.get(
        Uri.parse('https://cookie-beta-post-mobile-m5j8.onrender.com/post'));

    if (response.statusCode == 200) {
      dataPosts = jsonDecode(
          response.body); // Guarda los datos de los posts en dataPosts
      var groupedData = groupByUser(dataPosts);
      return groupedData;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  List<dynamic> groupByUser(List<dynamic> data) {
    var userPostCounts = <String, int>{};

    for (var post in data) {
      var user = post['NickName'];
      if (userPostCounts.containsKey(user)) {
        userPostCounts[user] = userPostCounts[user]! + 1;
      } else {
        userPostCounts[user] = 1;
      }
    }

    var groupedData = userPostCounts.entries.map((entry) {
      return {
        'NickName': entry.key,
        'PostCount': entry.value,
      };
    }).toList();

    // Ordena los datos por el conteo de posts en orden descendente y toma el top 5
    groupedData.sort(
        (a, b) => (b['PostCount'] as int).compareTo(a['PostCount'] as int));

    return groupedData.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    var groupedPosts = groupBy(dataPosts, (obj) => obj['Post']['IsDisable']);

    // Aquí debes reemplazar con tus datos reales
    List<Post> data = [
      Post(date: DateTime.now(), count: 5),
      Post(date: DateTime.now().add(Duration(days: 1)), count: 7),
      // Añade más datos aquí
    ];

    // Calcula el promedio de posts por usuario (X)
    double averagePosts = dataPosts.length / 4;

// Calcula el porcentaje de posts con imágenes (Y)
    int postsWithImages =
        dataPosts.where((post) => post['Post']['ImageURL'] != null).length;
    double percentageImages = (postsWithImages / dataPosts.length) * 100;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: FutureBuilder<List<dynamic>>(
            future: _loadData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error al cargar los datos.'));
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.infinity,
                                child: Text(
                                  'Vistazo Rápido a las Posts',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: Text(
                                  'En promedio, un usuario realiza $averagePosts Posts',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: Text(
                                  'El porcentaje de Posts con imágenes es $percentageImages%',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => showPostsModal(context),
                          child: const Text('Mostrar posts'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(
                              20), // Aumenta el relleno de la tarjeta
                          child: Column(
                            children: [
                              if (snapshot.data != null)
                                SizedBox(
                                  height:
                                      200, // Ajusta este valor para cambiar la altura de la tarjeta
                                  child: BarChart(data: snapshot.data!),
                                ),
                              const Align(
                                alignment: Alignment.bottomCenter,
                                child: Text('Top 5 Usuarios con más posts',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              const Text(
                                  'Los 5 Usuarios con mas posts Realizados son: ',
                                  style: TextStyle(fontSize: 13))
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(
                              20), // Aumenta el relleno de la tarjeta
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width:
                                    150, // Ajusta este valor para cambiar el ancho del texto
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          'Posts Habilitados vs Inhablitados',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    const Text(
                                        'Enuncido donde se indica el porcentaje de posts Habilitados vs inhablitados',
                                        style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                              if (snapshot.data != null)
                                SizedBox(
                                    height: 150,
                                    child: CustomPieChart(
                                      data: [
                                        PieChartData(
                                            'Habilitados',
                                            (groupedPosts[false]?.length ?? 0)
                                                .toInt(),
                                            Color.fromARGB(255, 134, 217, 255)),
                                        PieChartData(
                                            'Inhabilitados',
                                            (groupedPosts[true]?.length ?? 0)
                                                .toInt(),
                                            Color.fromARGB(255, 250, 100, 100)),
                                      ],
                                    )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 300, // Ajusta este valor según tus necesidades
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'Comportamiento de los Posts',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Este gráfico muestra el número de posts a lo largo del tiempo, lo que nos permite entender mejor el comportamiento de los usuarios en nuestra aplicación.',
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(height: 30),
                                Expanded(
                                  child: LineChart(data: data),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(PostPage());
}