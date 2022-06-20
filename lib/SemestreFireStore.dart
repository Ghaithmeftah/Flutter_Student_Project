import 'MatiereSemestreFireStore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SemestreFireStore extends StatefulWidget {
  const SemestreFireStore({Key? key}) : super(key: key);

  @override
  State<SemestreFireStore> createState() => _SemestreFireStore();
}

class _SemestreFireStore extends State<SemestreFireStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Semestre",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("smestre")
            .orderBy("semestre")
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
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, i) {
                QueryDocumentSnapshot coursestab = snapshot.data!.docs[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 30.0),
                  child: MaterialButton(
                      height: 80.0,
                      minWidth: 200.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        switch (coursestab["semestre"]) {
                          case "semestre 1":
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MatiereSemestreFireStore(
                                              "MatièreSemestre1")));
                              break;
                            }

                          case "semestre 2":
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MatiereSemestreFireStore(
                                              "MatièreSemestre2")));
                              break;
                            }
                          case "semestre 3":
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MatiereSemestreFireStore(
                                              "MatièreSemestre3")));
                              break;
                            }
                          case "semestre 4":
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MatiereSemestreFireStore(
                                              "MatièreSmestre4")));
                              break;
                            }
                          case "semestre 5":
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MatiereSemestreFireStore(
                                              "MatièreSemestre5")));
                              break;
                            }
                        }
                        // if (coursestab["semestre"] == "semestre 1") {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => const NewView()));
                        // }
                        // if (coursestab["semestre"] == "semestre 2") {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => const NewView2()));
                        // }
                      },
                      child: Text(
                        coursestab["semestre"],
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      )),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
