import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CoursDSExamenFireStore extends StatefulWidget {
  String matiere;
  QueryDocumentSnapshot coursestab;
  CoursDSExamenFireStore(this.matiere, this.coursestab);

  @override
  State<CoursDSExamenFireStore> createState() => _CoursDSExamenFireStoreState();
}

class _CoursDSExamenFireStoreState extends State<CoursDSExamenFireStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Couses",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("MatièreSemestre1")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("loading"),
            );
          }
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                      height: 40.0,
                      minWidth: 30.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text(
                        "cours " + widget.coursestab["name"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (widget.coursestab["name"] == widget.matiere) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            if (widget.coursestab["coursURL"] == "") {
                              return const NoURLFound();
                            }
                            return courseView(widget.coursestab["coursURL"]);
                          }));
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                      height: 40.0,
                      minWidth: 30.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text(
                        "DS " + widget.coursestab["name"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (widget.coursestab["name"] == widget.matiere) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            if (widget.coursestab["DSURL"] == "") {
                              return const NoURLFound();
                            }
                            return courseView(widget.coursestab["DSURL"]);
                          }));
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                      height: 40.0,
                      minWidth: 30.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text(
                        "Examen " + widget.coursestab["name"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (widget.coursestab["name"] == widget.matiere) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            if (widget.coursestab["ExamenURL"] == "") {
                              return const NoURLFound();
                            }
                            return courseView(widget.coursestab["ExamenURL"]);
                          }));
                        }
                      }),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

// ignore: camel_case_types
class courseView extends StatefulWidget {
  final URL;
  courseView(this.URL);

  @override
  State<courseView> createState() => _courseViewState();
}

// ignore: camel_case_types
class _courseViewState extends State<courseView> {
  PdfViewerController? _pdfViewercourseController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDFView")),
      body: SfPdfViewer.network(
        widget.URL,
        controller: _pdfViewercourseController,
      ),
    );
  }
}

class NoURLFound extends StatelessWidget {
  const NoURLFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "No url Found :",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
            child: const Text(
          "try to add course URL to Firebase console",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
