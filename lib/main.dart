import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spacer Translator',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomeStateState createState() => _MyHomeStateState();
}

enum TtsState { playing, stopped }

class _MyHomeStateState extends State<MyHomePage> {
  String _toLanuage;
  String _fromLanuage;
  String _homeLanuage;
  Map _map = {
    'English': 'en',
    'Hindi': 'hi',
    'French': 'fr',
    'Japanese': 'ja',
    'German': 'de',
    'Italian': 'it',
    'Danish': 'da',
    'Dutch': 'nl',
    'Finnish': 'fi',
    'Nepali': 'ne',
    'Indonesian': 'id',
    'Portuguese': 'pt',
  };
  TextEditingController _txt1 = TextEditingController();
  TextEditingController _txt2 = TextEditingController();
  int position = 0;
  int currentPage = 0;
  String _ans1 = "";
  String _ans2 = "";
  dynamic languages;
  List<DropdownMenuItem> _list = List<DropdownMenuItem>();
  FlutterTts flutterTts = new FlutterTts();
  TtsState ttsState = TtsState.stopped;

  @override
  void initState() {
    super.initState();
    _map.forEach((dynamic key, dynamic value) {
      _list.add(_getDropDown(key, value));
    });
  }

  Widget _getDropDown(String _key, String _value) {
    return new DropdownMenuItem(
      child: Text(_key),
      value: _value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        cursorColor: Colors.purple,
        primaryColor: Colors.purple[600],
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Text Translator'),
        ),
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(iconData: Icons.translate, title: "Home"),
            TabData(iconData: Icons.g_translate, title: "Basket")
          ],
          onTabChangedListener: (position) {
            setState(() {
              currentPage = position;
            });
          },
        ),
        floatingActionButton: IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: () async {
              if (currentPage == 0) {
                flutterTts.setLanguage(_homeLanuage);
                var result = await flutterTts.speak(_ans1);
                if (result == 1) setState(() => ttsState = TtsState.playing);
              } else {
                flutterTts.setLanguage(_toLanuage);
                var result = await flutterTts.speak(_ans2);
                if (result == 1) setState(() => ttsState = TtsState.playing);
              }
            }),
        body: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Center(
                child: _getPage(currentPage),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getPage(int page) {
    Locale myLocale = Localizations.localeOf(context);
    _homeLanuage = myLocale.toString().substring(0, 2);
    _homeLanuage = 'hi';
    final translator = GoogleTranslator();
    switch (page) {
      case 0:
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _txt1,
                  decoration: InputDecoration(
                    labelText: "Text",
                    hintText: "Enter Your text",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RaisedButton(
                    color: Colors.purple,
                    onPressed: () {
                      setState(() {
                        if (_txt1.text != "") {
                          translator
                              .translate(_txt1.text, to: _homeLanuage)
                              .then((s) => _ans1 = s);
                        } else {
                          _ans1 = 'Please enter Some Text';
                        }
                      });
                    },
                    child: Text(
                      "Translate",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                (_ans1 == "")
                    ? Container()
                    : SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 8,
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(_ans1),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _txt2,
                  decoration: InputDecoration(
                    labelText: "Text",
                    hintText: "Enter Your text",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: _from(),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: _to(),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RaisedButton(
                    color: Colors.purple,
                    onPressed: () {
                      setState(() {
                        if (_txt2.text != "") {
                          translator
                              .translate(_txt2.text,
                                  from: _fromLanuage, to: _toLanuage)
                              .then((s) => _ans2 = s);
                        } else {
                          _ans2 = 'Please enter a Some Text';
                        }
                      });
                    },
                    child: Text(
                      "Translate",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                (_ans2 == "")
                    ? Container()
                    : SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 8,
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(_ans2),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
    }
  }

  Widget _from() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("From :"),
        ),
        DropdownButton(
          items: _list,
          onChanged: (s) {
            setState(() {
              _fromLanuage = s.toString();
            });
          },
          value: _fromLanuage,
          hint: Text("Select Language"),
        )
      ],
    );
  }

  Widget _to() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("To :"),
        ),
        DropdownButton(
          items: _list,
          onChanged: (s) {
            setState(() {
              _toLanuage = s.toString();
            });
          },
          value: _toLanuage,
          hint: Text("Select Language"),
        )
      ],
    );
  }
}
