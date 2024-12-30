import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatopia/services/auth_services.dart';
import 'package:eatopia/services/db.dart';
import 'package:eatopia/utilities/colours.dart';
import 'package:eatopia/utilities/custom_shimmer.dart';
import 'package:eatopia/utilities/order_item.dart';
import 'package:flutter/material.dart';

class ResOrders extends StatefulWidget {
  const ResOrders({super.key});

  @override
  State<ResOrders> createState() => _ResOrdersState();
}

class _ResOrdersState extends State<ResOrders> {
  bool isChanged = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            'Current Orders',
            style: TextStyle(fontFamily: 'ubuntu-bold', fontSize: 20),
          ),
          const SizedBox(height: 10),
          CurrentOrder(onTap: () {
            setState(() {
              isChanged = !isChanged;
            });
          }),
          const SizedBox(height: 20),
          const Text(
            'Past Orders',
            style: TextStyle(fontFamily: 'ubuntu-bold', fontSize: 20),
          ),
          const SizedBox(height: 10),
          const PastOrder(),
        ]),
      ),
    );
  }
}

class CurrentOrder extends StatefulWidget {
  const CurrentOrder({super.key, required this.onTap});
  final Function() onTap;

  @override
  State<CurrentOrder> createState() => _CurrentOrderState();
}

class _CurrentOrderState extends State<CurrentOrder> {
  bool isLoading = true;
  List<DocumentSnapshot> orders = [];
  List<String> userNames = [];
  final dropDownKey = GlobalKey<FormFieldState>();

  void getOrders() async {
    final String uid = AuthServices().auth.currentUser!.uid;
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(uid)
        .collection('Orders')
        .where('status', whereIn: ['pending', 'preparing', 'on the way']).get();
    orders = querySnapshot.docs;
    for (var order in orders) {
      final userDoc =
          await Db().db.collection('Customers').doc(order['custId']).get();
      userNames.add(userDoc['name']);
    }
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
              String selectedStatus = orders.isEmpty
                  ? 'pending'
                  : orders[index]['status'] as String;
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
                      'No Current Orders!',
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
                      'Customer Details',
                      style: TextStyle(fontFamily: 'ubuntu-bold', fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Name: ${userNames[index]}',
                      style:
                          const TextStyle(fontFamily: 'ubuntu', fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Address: ${orders[index]['userAddress'] ?? 'Not Provided'}',
                      style:
                          const TextStyle(fontFamily: 'ubuntu', fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Phone: ${orders[index]['phone'] ?? 'Not Provided'}',
                      style:
                          const TextStyle(fontFamily: 'ubuntu', fontSize: 15),
                    ),
                    const SizedBox(height: 10),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonFormField(
                        key: dropDownKey,
                        onChanged: (value) async {
                          //Show a Dialog Box to Confirm
                          bool? result = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Are you sure you want to change the status?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: const Text('No')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: const Text('Yes')),
                                  ],
                                );
                              });
                          if (result == null || !result) {
                            dropDownKey.currentState!.reset();
                            return;
                          } else {
                            await Db().updateOrderStatus(
                              value.toString(),
                              orders[index]['restId'],
                              orders[index]['custId'],
                              orders[index].id,
                            );
                            setState(() {});
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        value: selectedStatus,
                        items: [
                          'pending',
                          'preparing',
                          'on the way',
                          'delivered'
                        ].map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () async {
                          //Show a Dialog Box to Confirm
                          bool? result = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Confirm'),
                                content: const Text(
                                    'Are you sure you want to cancel the order?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: const Text('No')),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text('Yes')),
                                ],
                              );
                            },
                          );

                          if (result == null || !result) {
                            return;
                          } else {
                            await Db().updateOrderStatus(
                              'cancelled',
                              orders[index]['restId'],
                              orders[index]['custId'],
                              orders[index].id,
                            );
                            widget.onTap();
                          }
                        },
                        child: const Text('Cancel')),
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
  List<String> userNames = [];

  void getOrders() async {
    final String uid = AuthServices().auth.currentUser!.uid;
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(uid)
        .collection('Orders')
        .where('status', whereIn: ['delivered', 'cancelled']).get();
    orders = querySnapshot.docs;
    for (var order in orders) {
      final userDoc =
          await Db().db.collection('Customers').doc(order['custId']).get();
      userNames.add(userDoc['name']);
    }
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
                      'Customer Details',
                      style: TextStyle(fontFamily: 'ubuntu-bold', fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Name: ${userNames[index]}',
                      style:
                          const TextStyle(fontFamily: 'ubuntu', fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Address: ${orders[index]['userAddress'] ?? 'Not Provided'}',
                      style:
                          const TextStyle(fontFamily: 'ubuntu', fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Phone: ${orders[index]['phone'] ?? 'Not Provided'}',
                      style:
                          const TextStyle(fontFamily: 'ubuntu', fontSize: 15),
                    ),
                    const SizedBox(height: 10),
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
