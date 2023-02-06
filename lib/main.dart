/* By Abdullah As-Sadeed*/

import "dart:convert";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:sadeed_nasa_mars_rover_photos/modelApiData.dart";
import 'package:sadeed_nasa_mars_rover_photos/apiKey.dart';
import 'package:lottie/lottie.dart';
import 'package:transparent_image/transparent_image.dart';
import "package:url_launcher/url_launcher.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData.dark(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List imagesID = [];
  List imagesCameraShortName = [];
  List imagesCameraFullName = [];
  List imagesURL = [];
  List imagesDate = [];
  List imagesRoverID = [];
  List imagesRoverName = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<String> fetchDataFromApi() async {
    var jsonData = await http.get(Uri.parse(
        "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=" +
            apiKey));

    var fetchData = modelApiData.fromJson(jsonDecode(jsonData.body));

    setState(() {
      fetchData.photos!.forEach((element) {
        imagesID.add(element!.id);
        imagesCameraShortName.add(element.camera!.name);
        imagesCameraFullName.add(element.camera!.fullName!);
        imagesURL.add(element.imgSrc);
        imagesDate.add(element.earthDate);
        imagesRoverID.add(element.rover!.id);
        imagesRoverName.add(element.rover!.name);
      });
    });
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sadeed Mars Observatory"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(76, 175, 80, 1),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(76, 175, 80, 1),
              ),
              child: Text.rich(
                TextSpan(
                  text: "About Developer\n\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Abdullah As-Sadeed",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20.0,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    TextSpan(
                      text:
                          "\n\nStudent ID No. 200061117\nDepartment of BTM,\nIUT, OIC.",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text("Developer Page"),
              onTap: () {
                launch("https://sadeed.service-ways.com/");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: imagesURL.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            decoration: BoxDecoration(
              color: Colors.brown,
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Image ID # " + imagesID[index].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Center(
                    child: Stack(
                      children: [
                        Lottie.asset("lib/loading.json"),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: imagesURL[index],
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: "Date: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: imagesDate[index],
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: "Rover: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: imagesRoverName[index] + " (",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text: "ID: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: imagesRoverID[index].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text: ")",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: "Camera: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: imagesCameraFullName[index] +
                            " (" +
                            imagesCameraShortName[index] +
                            ")",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
