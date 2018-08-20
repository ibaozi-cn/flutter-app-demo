import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      theme: new ThemeData(primaryColor: Colors.white),
      home: new WordRandoms(),
    );
  }
}

class WordRandoms extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new RandomWordState();

}

class RandomWordState extends State<StatefulWidget> {

  final _suggestions = <WordPair>[];
  final _biggerFonts = const TextStyle(fontSize: 18.0);
  final _saved = new Set<WordPair>();

  Widget _buildSuggestions() =>
      new ListView.builder(
          padding: const EdgeInsets.all(6.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return new Divider();
            final index = i ~/ 2;
            if (index >= _suggestions.length) {
              _suggestions.addAll(generateWordPairs().take(10));
            }
            return _buildRow(_suggestions[index]);
          });

  Widget _buildRow(WordPair wordPair) {
    final alreadySaved = _saved.contains(wordPair);
    return new ListTile(
      title: new Text(
        wordPair.asPascalCase,
        style: _biggerFonts,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,),
      onTap: (){
        setState(() {
          if(alreadySaved){
            _saved.remove(wordPair);
          }else{
            _saved.add(wordPair);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Startup Name Generator"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.view_list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context){
        final tiles = _saved.map((pair){
          return new ListTile(
            title: new Text(pair.asPascalCase,style: _biggerFonts,),
          );
        });
        final divided = ListTile.divideTiles(tiles: tiles,context: context).toList();

        return new Scaffold(
          appBar: new AppBar(
            title: new Text("Saved Suggestions"),
          ),
          body: new ListView(children: divided),
        );
      })
    );
  }
}
