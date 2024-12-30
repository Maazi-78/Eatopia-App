import 'package:eatopia/pages/Customer/user_home.dart';
import 'package:eatopia/services/auth_services.dart';
import 'package:eatopia/services/db.dart';
import 'package:eatopia/services/maps.dart';
import 'package:eatopia/utilities/colours.dart';
import 'package:eatopia/utilities/order.dart';
import 'package:eatopia/utilities/order_item.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({super.key, required this.userData});
  Map<String, dynamic> userData;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              //Information SHowing
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Review Your Information',
                      style: TextStyle(fontFamily: 'ubuntu-bold', fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.location_on),
                        const SizedBox(width: 10),
                        const Text(
                          'Address',
                          style: TextStyle(
                              fontFamily: 'ubuntu-bold', fontSize: 20),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () async {
                              String? add = await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const MapScreen();
                              }));
                              if (add != null) {
                                setState(() {
                                  widget.userData['stAddress'] = add;
                                });
                              }
                            },
                            icon: const Icon(Icons.edit)),
                      ],
                    ),
                    Text(
                      widget.userData['stAddress'],
                      style: const TextStyle(
                        fontFamily: 'ubuntu',
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 20),
                    //Phone NUmber Display
                    Row(
                      children: const [
                        Icon(Icons.phone),
                        SizedBox(width: 10),
                        Text(
                          'Phone Number',
                          style: TextStyle(
                              fontFamily: 'ubuntu-bold', fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.userData['phone'] ?? 'Not Provided',
                      style: const TextStyle(
                        fontFamily: 'ubuntu',
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              //Displaying Cart Items or Order Summary
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3)),
                  ],
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
                      itemCount: CartList.list.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            CartList.list[index].title,
                            style: const TextStyle(
                                fontFamily: 'ubuntu', fontSize: 15),
                          ),
                          subtitle: Text(
                            'Rs. ${CartList.list[index].totalPrice}',
                            style: const TextStyle(
                                fontFamily: 'ubuntu', fontSize: 15),
                          ),
                          trailing: Text(
                            'x${CartList.list[index].quantity}',
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
                          'Rs. ${CartList.list.fold(0.0, (p, c) => p + c.totalPrice)}',
                          style: const TextStyle(
                              fontFamily: 'ubuntu-bold', fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //Box To Provide Radio List of Payment Methods
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Method',
                      style: TextStyle(fontFamily: 'ubuntu-bold', fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    RadioListTile(
                      selected: true,
                      value: 'COD',
                      title: const Text(
                        'Cash On Delivery',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'ubuntu-bold',
                            fontSize: 20),
                      ),
                      groupValue: 'COD',
                      onChanged: (value) {
                        setState(() {
                          widget.userData['paymentMethod'] = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //Button To Place Order
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.8, 50),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'ubuntu-bold',
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    Order order = Order(
                      userAddress: widget.userData['stAddress'],
                      payMentMethod: 'COD',
                      phone: widget.userData['phone'],
                      custId: AuthServices().auth.currentUser!.uid,
                      restId: CartList.list[0].restId,
                      status: 'pending',
                    );
                    order.addAllOrderItems(CartList.list);
                    await Db().addOrder(order);
                    setState(() {
                      isLoading = false;
                    });
                    //Show SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: appGreen,
                        content: const Text('Order Placed Successfully'),
                      ),
                    );
                    //Clear Cart
                    CartList.list.clear();
                    //Clear from database
                    await Db().clearCart(AuthServices().auth.currentUser!.uid);
                    //Redirect To Home Screen
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserHomePage(),
                        ),
                        (route) => false);
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1.2,
                        )
                      : const Text(
                          'Place Order',
                        )),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
