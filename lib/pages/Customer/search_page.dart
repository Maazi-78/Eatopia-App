import 'package:flutter/material.dart';

import 'results_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();
  List<String> recentSearches = [];
  int selectedIndex = 0;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
          ),
          leadingWidth: 40,
          backgroundColor: Colors.white,
          elevation: 5,
          toolbarHeight: 80,
          title: TextField(
            textInputAction: TextInputAction.search,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
            },
            onSubmitted: (value) {
              if (searchController.text.isNotEmpty) {
                setState(() {
                  selectedIndex = 1;
                  if (!recentSearches.contains(searchController.text)) {
                    if (recentSearches.length > 5) {
                      recentSearches.removeAt(0);
                    }
                    recentSearches.add(searchController.text);
                  }
                });
              }
            },
            cursorColor: Colors.black,
            controller: searchController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              prefixIconColor: Colors.black,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          ),
        ),
        body: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                    Text(
                      'Recent Searches',
                      style: TextStyle(fontSize: 20, fontFamily: 'ubuntu-bold'),
                    ),
                  ] +
                  recentSearches
                      .map((e) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              searchController.text = e;
                              selectedIndex = 1;
                            });
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.history,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                e,
                                style: const TextStyle(
                                    fontSize: 16, fontFamily: 'ubuntu'),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    recentSearches.remove(e);
                                  });
                                },
                                icon: const Icon(Icons.close),
                              )
                            ],
                          ),
                        );
                      })
                      .toList()
                      .reversed
                      .toList(),
            ),
          ),
          SearchResultsPage(
            query: searchController.text,
          ),
        ][selectedIndex]);
  }
}
