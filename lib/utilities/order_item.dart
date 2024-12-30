import 'package:flutter/material.dart';

import 'colours.dart';

class OrderItem {
  String restId;
  String itemId;
  String id;
  String title;
  String spcInstr;
  int quantity;
  double basePrice;
  Map<String, dynamic> addOns;

  double get totalPrice {
    double total = basePrice;
    addOns.forEach((key, value) {
      total += value;
    });
    return total * quantity;
  }

  double get subTotal {
    double total = basePrice;
    addOns.forEach((key, value) {
      total += value;
    });
    return total;
  }

  Widget buildOrderItem(StateSetter setState) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(2, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontFamily: 'ubuntu-bold', fontSize: 20),
          ),
          const SizedBox(height: 5),
          Text('Rs ${basePrice.toString()}'),
          const SizedBox(height: 5),
          const Text('Add Ons', style: TextStyle(fontFamily: 'ubuntu-bold')),
          const SizedBox(height: 5),
          ...addOns.keys.map((e) => Text('Rs ${addOns[e]}    $e')).toList(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    quantity--;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: quantity != 0 ? appGreen : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                '$quantity',
                style: const TextStyle(fontSize: 20, fontFamily: 'ubuntu-bold'),
              ),
              const SizedBox(
                width: 15,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    quantity++;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: appGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(50, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 15, fontFamily: 'ubuntu-bold'),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  OrderItem(
      {required this.itemId,
      required this.id,
      required this.title,
      required this.quantity,
      required this.basePrice,
      required this.addOns,
      required this.spcInstr,
      required this.restId});
}

class CartList {
  static List<OrderItem> list = [];
}
