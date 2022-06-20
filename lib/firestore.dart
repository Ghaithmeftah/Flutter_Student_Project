import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';

class FireStore extends StatefulWidget {
  const FireStore({Key? key}) : super(key: key);

  @override
  State<FireStore> createState() => _FireStoreState();
}

class _FireStoreState extends State<FireStore> {
  @override
  Widget build(BuildContext context) {
    //travail personnel
    /*FirebaseFirestore db = FirebaseFirestore.instance;
                  final examsRef = db.collection("exams");
                  final namesQuery = examsRef
                      .where("name", isEqualTo: true)
                      .get()
                      .then((value) => print("successfully completed"),
                          onError: (e) => print("Error Completing :$e"));*/
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PDFs",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('exams')
            .where("name", isEqualTo: "FPGA")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("loading"));
          }
          if (snapshot.hasData) {
            return SizedBox(
              height: 600.0,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  QueryDocumentSnapshot tab = snapshot.data!.docs[i];
                  return ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          //View is a class in the bottom of the code to open the pdf using it's URL
                          builder: (context) => View(
                                URL: tab["URL"],
                              )),
                    ),
                    child: Text(tab["name"]),
                  );
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class View extends StatefulWidget {
  final URL;
  View({this.URL});

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  PdfViewerController? _pdfViewerController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDFView")),
      body: SizedBox(
        height: 800,
        child: SfPdfViewer.network(
          widget.URL,
          controller: _pdfViewerController,
        ),
      ),
    );
  }
}
