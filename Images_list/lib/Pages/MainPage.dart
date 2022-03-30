import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:images_list/Class/Cards.dart' as ClassCards;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageSate createState() => _MainPageSate();
}

class _MainPageSate extends State {
  final List<ClassCards.Cards> _CardsList = [];

  void getData() async {
    var url = Uri.parse(
        "https://api.unsplash.com/photos/?per_page=30&client_id=lzoPKe3sa2NvLf_GqHYC9ydpGdhXEkN7b1hkaK9wXjg");
    final res = await http.get(url);
    setState(() {
      var _urlData = jsonDecode(res.body);
      for (int i = 0; i < 30; i++) {
        var c = ClassCards.Cards(
            userName: _urlData[i]['user']['name'],
            img: _urlData[i]['urls']['full'],
            description: _urlData[i]['description'] == null ? 'none' : _urlData[i]['description']);
        _CardsList.add(c);
        //print(_urlData);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images list'),
        centerTitle: true,
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: _refreshLocalGallery,
          child: _CardsList == null
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemCount: _CardsList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.all(10.0),
                        child: Column(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _CardsList[index].userName,
                                  style: TextStyle(fontSize: 20),
                                )),
                          ),
                          Image(
                            image: NetworkImage(_CardsList[index].img),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              _CardsList[index].description,
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ]),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Container(
                                      child: Image(
                                        image:
                                            NetworkImage(_CardsList[index].img),
                                      ),
                                    )));
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }

  Future<void> _refreshLocalGallery() async {
    getData();
  }
}
