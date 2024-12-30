import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatopia/services/auth_services.dart';
import 'package:eatopia/utilities/custom_shimmer.dart';
import 'package:eatopia/utilities/order_item.dart';
import 'package:flutter/material.dart';

class RestOrders extends StatefulWidget {
  const RestOrders({super.key});

  @override
  State<RestOrders> createState() => _RestOrdersState();
}

class _RestOrdersState extends State<RestOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Current Orders',
                  style: TextStyle(fontFamily: 'ubuntu-bold', fontSize: 20),
                ),
                SizedBox(height: 10),
                CurrentOrder(),
                SizedBox(height: 20),
                Text(
                  'Past Orders',
                  style: TextStyle(fontFamily: 'ubuntu-bold', fontSize: 20),
                ),
                SizedBox(height: 10),
                PastOrder(),
              ]),
        ),
      ),
    );
  }
}

class CurrentOrder extends StatefulWidget {
  const CurrentOrder({super.key});

  @override
  State<CurrentOrder> createState() => _CurrentOrderState();
}

class _CurrentOrderState extends State<CurrentOrder> {
  bool isLoading = true;
  List<DocumentSnapshot> orders = [];

  void getOrders() async {
    final String uid = AuthServices().auth.currentUser!.uid;
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(uid)
        .collection('Orders')
        .where('status', whereIn: ['pending', 'preparing', 'on the way']).get();
    orders = querySnapshot.docs;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CustomShimmer(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          )
        : ListView.builder(
            itemCount: orders.isEmpty ? 1 : orders.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (orders.isEmpty) {
                Container(
                    height: 50,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset:
                              const Offset(2, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: const Center(
                        child: Text(
                      'No Past Orders!',
                      style: TextStyle(fontSize: 20),
                    )));
              }
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
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(fontFamily: 'ubuntu-bold', fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orders[index]['orderItems'].length,
                      itemBuilder: (context, index2) {
                        OrderItem orderItem = OrderItem(
                          restId: orders[index]['orderItems'][index2]['restId'],
                          itemId: orders[index]['orderItems'][index2]['itemId'],
                          id: '',
                          title: orders[index]['orderItems'][index2]['title'],
                          spcInstr: orders[index]['orderItems'][index2]
                              ['spcInstr'],
                          quantity: orders[index]['orderItems'][index2]
                              ['quantity'],
                          basePrice: orders[index]['orderItems'][index2]
                              ['basePrice'],
                          addOns: orders[index]['orderItems'][index2]['addOns'],
                        );
                        return ListTile(
                          title: Text(
                            orderItem.title,
                            style: const TextStyle(
                                fontFamily: 'ubuntu', fontSize: 15),
                          ),
                          subtitle: Text(
                            'Rs. ${orderItem.totalPrice}',
                            style: const TextStyle(
                                fontFamily: 'ubuntu', fontSize: 15),
                          ),
                          trailing: Text(
                            'x${orderItem.quantity}',
                            style: const TextStyle(
                                fontFamily: 'ubuntu', fontSize: 15),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                              fontFamily: 'ubuntu-bold', fontSize: 20),
                        ),
                        const Spacer(),
                        Text(
                          'Rs. ${orders[index]['orderItems'].fold(0.0, (p, c) {
                            OrderItem orderItem = OrderItem(
                              restId: c['restId'],
                              itemId: c['itemId'],
                              id: '',
                              title: c['title'],
                              spcInstr: c['spcInstr'],
                              quantity: c['quantity'],
                              basePrice: c['basePrice'],
                              addOns: c['addOns'],
                            );
                            return p + orderItem.totalPrice;
                          })}',
                          style: const TextStyle(
                              fontFamily: 'ubuntu-bold', fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Row(
                      children: [
                        const Text(
                          'Status:',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'ubuntu-bold',
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          orders[index]['status'],
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
  }
}

class PastOrder extends StatefulWidget {
  const PastOrder({super.key});

  @override
  State<PastOrder> createState() => _PastOrderState();
}

class _PastOrderState extends State<PastOrder> {
  bool isLoading = true;
  List<DocumentSnapshot> orders = [];

  void getOrders() async {
    final String uid = AuthServices().auth.currentUser!.uid;
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Customers')
        .doc(uid)
        .collection('Orders')
        .where('status', whereIn: ['delivered', 'cancelled']).get();
    orders = querySnapshot.docs;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CustomShimmer(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          )
        : ListView.builder(
            itemCount: orders.isEmpty ? 1 : orders.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (orders.isEmpty) {
                return Container(
                    height: 50,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset:
                              const Offset(2, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: const Center(
                        child: Text(
                      'No Past Orders!',
                      style: TextStyle(fontSize: 20),
                    )));
              }
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
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(fontFamily: 'ubuntu-bold', fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orders[index]['orderItems'].length,
                      itemBuilder: (context, index2) {
                        OrderItem orderItem = OrderItem(
                          restId: orders[index]['orderItems'][index2]['restId'],
                          itemId: orders[index]['orderItems'][index2]['itemId'],
                          id: '',
                          title: orders[index]['orderItems'][index2]['title'],
                          spcInstr: orders[index]['orderItems'][index2]
                              ['spcInstr'],
                          quantity: orders[index]['orderItems'][index2]
                              ['quantity'],
                          basePrice: orders[index]['orderItems'][index2]
                              ['basePrice'],
                          addOns: orders[index]['orderItems'][index2]['addOns'],
                        );
                        return ListTile(
                          title: Text(
                            orderItem.title,
                            style: const TextStyle(
                                fontFamily: 'ubuntu', fontSize: 15),
                          ),
                          subtitle: Text(
                            'Rs. ${orderItem.totalPrice}',
                            style: const TextStyle(
                                fontFamily: 'ubuntu', fontSize: 15),
                          ),
                          trailing: Text(
                            'x${orderItem.quantity}',
                            style: const TextStyle(
                                fontFamily: 'ubuntu', fontSize: 15),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                              fontFamily: 'ubuntu-bold', fontSize: 20),
                        ),
                        const Spacer(),
                        Text(
                          'Rs. ${orders[index]['orderItems'].fold(0.0, (p, c) {
                            OrderItem orderItem = OrderItem(
                              restId: c['restId'],
                              itemId: c['itemId'],
                              id: '',
                              title: c['title'],
                              spcInstr: c['spcInstr'],
                              quantity: c['quantity'],
                              basePrice: c['basePrice'],
                              addOns: c['addOns'],
                            );
                            return p + orderItem.totalPrice;
                          })}',
                          style: const TextStyle(
                              fontFamily: 'ubuntu-bold', fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Row(
                      children: [
                        const Text(
                          'Status:',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'ubuntu-bold',
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          orders[index]['status'],
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
  }
}
