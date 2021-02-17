import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter REST API ',
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Flutter REST API')),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            //future: updateAlbum('Updated title','Body Updated'),
            //future: deleteAlbum(1),
            future: sendAlbum(
                1,2,
                'Title updated by post method',
                'Body updated by post method') ,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child:Text('${snapshot.data.id.toString()}'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child:Text('${snapshot.data.userId.toString()}'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child:Text('${snapshot.data.title}'),
                      //child: Image.network('${snapshot.data.title}',
                      //width: 100,height: 100,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child:Text('${snapshot.data.body}'),

                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<Album> fetchPost() async {

  final response = await http.get('http://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=921dfa03539246f28c1f24bcc5e1ca7e');

  if (response.statusCode == 200) {
    return Album.fromJson(json.decode(response.body),response.statusCode,'Data found');
  } else {
    return Album.fromJson({},response.statusCode,'Data Not found');
  }
}

Future<Album> updateAlbum(String title,String body) async {
  final http.Response response = await http.put('https://jsonplaceholder.typicode.com/posts/1',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'body': body,
    }),
  );

  if (response.statusCode == 200) {
    return Album.fromJson(json.decode(response.body),response.statusCode,'Data found');
  } else {
    return Album.fromJson({},response.statusCode,'Data Not found');
  }
}

Future<Album> deleteAlbum(int id) async {
  final http.Response response = await http.delete('https://jsonplaceholder.typicode.com/posts/1',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return Album.fromJson(json.decode(response.body),response.statusCode,'Data found');
  } else {

    return Album.fromJson({},response.statusCode,'Data Not found');
  }
}

Future<Album> sendAlbum(
    int userId, int id, String title, String body) async {
   // final http.Response response = await http.post('https://jsonplaceholder.typicode.com/posts',
        final http.Response response = await http.post('https://jsonplaceholder.typicode.com/posts',
    headers: <String,String> {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String> {
      'userId':userId.toString(),
       'id': id.toString(),
      'title': title,
      'body':body,
    }),
  );
     // Album ad = Album();
     // ad = Album(userId: '101',id: 1,title: 'Title',body: 'body');
  if (response.statusCode == 201) {
    return Album.fromJson(json.decode(response.body),response.statusCode,'Data found');
  } else {
    return Album.fromJson({},response.statusCode,'Data Not found');
  }
}

class Album {
  Album({
    this.userId,
    this.id,
    this.title,
    this.body,
    this.statusCode,
    this.failureResponse,
  });

  String userId;
  int id;
  int statusCode;
  String failureResponse;
  String title;
  String body;

  factory Album.fromJson(Map<String, dynamic> json,int statusCode, String failureresponse) => Album(
    userId: statusCode == 200 || statusCode == 201 ? json["userId"] : '',
    id: statusCode == 200 || statusCode == 201 ? json["id"] : 0,
    title: statusCode == 200 || statusCode == 201 ? json["title"] : '',
    body:statusCode == 200 || statusCode == 201 ? json["body"] : '',
    statusCode: statusCode,
    failureResponse: failureresponse,
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "body": body,
  };
 // String get userId => _userId;
}
///Get
// class Album {
//   Album({
//     this.status,
//     this.totalResults,
//     this.articles,
//   });
//
//   String status;
//   int totalResults;
//   List<Article> articles;
//
//   factory Album.fromJson(Map<String, dynamic> json) => Album(
//     status: json["status"],
//     totalResults: json["totalResults"],
//     articles: List<Article>.from(json["articles"].map((x) => Article.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "totalResults": totalResults,
//     "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
//   };
// }
//
// class Article {
//   Article({
//     this.source,
//     this.author,
//     this.title,
//     this.description,
//     this.url,
//     this.urlToImage,
//     this.publishedAt,
//     this.content,
//   });
//
//   Source source;
//   String author;
//   String title;
//   String description;
//   String url;
//   String urlToImage;
//   DateTime publishedAt;
//   String content;
//
//   factory Article.fromJson(Map<String, dynamic> json) => Article(
//     source: Source.fromJson(json["source"]),
//     author: json["author"],
//     title: json["title"],
//     description: json["description"],
//     url: json["url"],
//     urlToImage: json["urlToImage"],
//     publishedAt: DateTime.parse(json["publishedAt"]),
//     content: json["content"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "source": source.toJson(),
//     "author": author,
//     "title": title,
//     "description": description,
//     "url": url,
//     "urlToImage": urlToImage,
//     "publishedAt": publishedAt.toIso8601String(),
//     "content": content,
//   };
// }
//
// class Source {
//   Source({
//     this.id,
//     this.name,
//   });
//
//   Id id;
//   Name name;
//
//   factory Source.fromJson(Map<String, dynamic> json) => Source(
//     id: idValues.map[json["id"]],
//     name: nameValues.map[json["name"]],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": idValues.reverse[id],
//     "name": nameValues.reverse[name],
//   };
// }
//
// enum Id { TECHCRUNCH }
//
// final idValues = EnumValues({
//   "techcrunch": Id.TECHCRUNCH
// });
//
// enum Name { TECH_CRUNCH }
//
// final nameValues = EnumValues({
//   "TechCrunch": Name.TECH_CRUNCH
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
