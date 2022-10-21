import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StyleCard extends StatefulWidget {
  final DocumentSnapshot? documentSnapshot;
  final String Name;
  final String Price;

  const StyleCard(
      {Key? key,
      required this.Name,
      required this.Price,
      required this.documentSnapshot})
      : super(key: key);

  @override
  State<StyleCard> createState() => _StyleCardState();
}

class _StyleCardState extends State<StyleCard> {
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _pricecontroller = TextEditingController();

  Future<void> _update() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.grey[700]),
                      cursorColor: Colors.grey[700],
                      controller: _namecontroller,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.grey[700]),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      cursorColor: Colors.grey[700],
                      controller: _pricecontroller,
                      decoration: InputDecoration(
                        labelText: "Price",
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        final String _name = _namecontroller.text;
                        final double? _price =
                            double.tryParse(_pricecontroller.text);

                        if (_price != null) {
                          await _products
                              .doc(widget.documentSnapshot!.id)
                              .update({"name": _name, "price": _price});
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
                            "UPDATE",
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
              ));
        });
  }

  Future<void> _delete() async {
    await _products.doc(widget.documentSnapshot!.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Colors.grey[700]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Name :",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      widget.Name,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(
                  height: 13,
                ),
                Row(
                  children: [
                    Text(
                      "Price :",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      "\$ ${widget.Price}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: _update,
                    child: Icon(
                      Icons.edit,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: _delete,
                    child: Icon(
                      Icons.delete_sharp,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
