import 'items.dart';

//  this class is used to store the search result for a Customers query
class SearchResult {
  final Map<String, dynamic> restDoc;
  List<Item> items;

  SearchResult({required this.restDoc, required this.items});

  //Equality operator
  @override
  bool operator ==(other) {
    return (other is SearchResult) &&
        other.restDoc['restaurant'] == restDoc['restaurant'];
  }

  @override
  int get hashCode => restDoc['restaurant'].toString().hashCode;
}
