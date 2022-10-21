import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_test/Widgets/Card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _pricecontroller = TextEditingController();

  Future<void> _create() async {
    await showModalBottomSheet(
        isScrollControlled: true,

        context: context, builder: (BuildContext ctx) {
      return Padding(padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery
              .of(ctx)
              .viewInsets
              .bottom + 20),

          child: Container(

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                TextFormField(

                  cursorColor: Colors.grey[700],
                  style: TextStyle(
                      color: Colors.grey[700]
                  ),

                  controller: _namecontroller,
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(
                        color: Colors.grey[700]
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black26
                        )
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                TextFormField(

                  cursorColor: Colors.grey[700],
                  style: TextStyle(
                      color: Colors.grey[700]
                  ),

                  keyboardType: TextInputType.numberWithOptions(decimal: true),

                  controller: _pricecontroller,
                  decoration: InputDecoration(
                    labelText: "Price",
                    labelStyle: TextStyle(
                        color: Colors.grey[700]
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black26
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                GestureDetector(
                  onTap: () async {
                    final String _name = _namecontroller.text;
                    final double? _price = double.tryParse(
                        _pricecontroller.text);

                    if (_price != null) {
                      await _product.add({"name": _name, "price": _price});
                    }

                    _namecontroller.text = "";
                    _pricecontroller.text = "";
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 30,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        "CREATE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )


              ],
            ),
          )
      );
    });
  }


  final CollectionReference _product = FirebaseFirestore.instance.collection(
      'products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Database App"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),

      body: StreamBuilder(

          stream: _product.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentsnapshot = snapshot.data!
                        .docs[index];
                    final String Name = documentsnapshot['name'];
                    final String Price = documentsnapshot['price'].toString();

                    return StyleCard(Name: Name,
                      Price: Price,
                      documentSnapshot: documentsnapshot,);
                  }
              );
            }
            else {
              return Container(
                  child: Center(child: CircularProgressIndicator()));
            }
          }
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _create,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),

      ),
    );
  }
}
