import 'dart:html';
import 'dart:js' as js;

import 'package:dart_pub_badge_maker/badge_maker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

void main() => runApp(MyApp());

Uri getURI() {
  return Uri.tryParse(js.context['location']['href']);
}

List<String> getPackages() {
  var uri = getURI();
  if (uri == null) return [];
  final packages = uri.queryParameters["packages"];
  if (packages == null || packages == "") return [];
  return packages.split(",");
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final packages = getPackages();

    return MaterialApp(
      title: 'Pub.dev Package Watcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(34.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Pub.dev Package Watcher",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 42.0,
                    ),
                  ),
                  SizedBox(height: 6.0),
                  GestureDetector(
                    onTap: () => js.context.callMethod(
                        "open", ["https://twitter.com/modulovalue"]),
                    child: Text(
                      "Made by @modulovalue",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[700],
                        fontSize: 12.0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.0),
                  GestureDetector(
                    onTap: () => js.context.callMethod("open", [
                      "https://github.com/modulovalue/dart_pub_package_watcher"
                    ]),
                    child: Text(
                      "Github",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[700],
                        fontSize: 12.0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 18.0),
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                        "You can bookmark this page or share it with others!"),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      "(The packages are stored in the URL)",
                      style: TextStyle(fontSize: 10.0),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Text("Packages: ${packages.length}"),
                  SizedBox(height: 12.0),
                  ...packages.map((package) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(package),
                          subtitle: MarkdownBody(
                            data: pubDevBadge(package, BadgeStyle.flatSquare())
                                .makeMarkdownString(),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              window.location.href = getURI().replace(
                                queryParameters: {
                                  "packages":
                                      (getPackages()..remove(package)).join(",")
                                },
                              ).toString();
                            },
                          ),
                          onTap: () => js.context.callMethod(
                              "open", ["https://pub.dev/packages/$package"]),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 12.0),
                  Icon(Icons.arrow_drop_down),
                  SizedBox(height: 12.0),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "New Package",
                            helperText: "Press Enter to add"),
                        onSubmitted: (text) {
                          window.location.href = getURI().replace(
                            queryParameters: {
                              "packages": (getPackages()..add(text)).join(",")
                            },
                          ).toString();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
