import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


class RandomWordsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'RandomWordsAppTitle',

// Меняем тему
//      theme: new ThemeData(
//        primaryColor: Colors.white,
//      ),

      home: new Scaffold(
        body: new Center(
          child: new RandomWords(),
        ),
      ),
    );
  }
}

//Stateful widgets maintain state that might change during the lifetime of the widget.
//StatefulWidget сам по себе immutable, но благодаря вложенному State отображаемые данные могут изменяться
class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);

  final _saved = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),

        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),

      body: _buildSuggestions(),
    );
  }

  void nothing(){}

  void _pushSaved() {
    // Navigator управляет перемещениями между экранами. Сейчас мы вбрасываем
    // ему Scaffold со списком сохраненных элементов списка
    Navigator.of(context).push(getMaterialRoute(context));
  }

  PageRoute getMaterialRoute(BuildContext context){
    return new MaterialPageRoute(
      builder: (context) {

        // ListTile
        final tiles = _saved.map(
              (pair) {
            return new ListTile(
              title: new Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          },
        );

        final divided = ListTile
            .divideTiles(context: context,tiles: tiles).toList();

        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Saved Suggestions'),
          ),
          body: new ListView(children: divided),
        );


      },
    );
  }

  Widget _buildSuggestions() => new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        }
    );

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
        title: new Text(pair.asPascalCase, style: _biggerFont),
        trailing: new Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
    );
  }


}