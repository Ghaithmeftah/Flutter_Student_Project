import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../CoursDSExamenFireStore.dart';

class MatiereSemestreFireStore extends StatefulWidget {
  String semestre;
  MatiereSemestreFireStore(this.semestre);

  @override
  State<MatiereSemestreFireStore> createState() =>
      _MatiereSemestreFireStoreState();
}

class _MatiereSemestreFireStoreState extends State<MatiereSemestreFireStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Les Matières",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(widget.semestre)
            .orderBy("name")
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
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                      height: 40.0,
                      minWidth: 30.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CoursDSExamenFireStore(
                                    coursestab["name"], coursestab)));
                      },
                      child: Text(
                        coursestab["name"],
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
