import 'package:eatopia/utilities/order_item.dart';

class Order {
  String restId;
  String custId;
  String userAddress;
  String payMentMethod;
  String status;
  String phone = '';
  List<Map<String, dynamic>> orderItems = [];

  Order({
    required this.restId,
    required this.custId,
    required this.userAddress,
    required this.payMentMethod,
    required this.status,
    required this.phone,
  });

  void addAllOrderItems(List<OrderItem> orderItems) {
    for (var element in orderItems) {
      Map<String, dynamic> oI = {
        'restId': element.restId,
        'itemId': element.itemId,
        'title': element.title,
        'spcInstr': element.spcInstr,
        'quantity': element.quantity,
        'basePrice': element.basePrice,
        'addOns': element.addOns,
      };
      this.orderItems.add(oI);
    }
  }
}
