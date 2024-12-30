import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatopia/pages/Customer/item_desc_page.dart';
import 'package:eatopia/pages/Customer/res_review_info.dart';
import 'package:eatopia/pages/Restaurant/items.dart';
import 'package:eatopia/services/db.dart';
import 'package:eatopia/utilities/cache_manger.dart';
import 'package:eatopia/utilities/colours.dart';
import 'package:eatopia/utilities/custom_shimmer.dart';
import 'package:flutter/material.dart';

//Class For Item

//THis is the Customer's view of the restaurant page

class UserRestauarantPage extends StatefulWidget {
  const UserRestauarantPage({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  State<UserRestauarantPage> createState() => _UserRestauarantPageState();
}

class _UserRestauarantPageState extends State<UserRestauarantPage>
    with SingleTickerProviderStateMixin {
  Map<String, List<Item>> ctgItems = {};
  final ScrollController _scrollController = ScrollController();
  TabController? _tabController;
  double titleOpacity = 0;

  bool isLoading = true;

  //This functions sets the Map with ctgs as keys and list of items as a value
  void getCtgItems() async {
    ctgItems = await Db().getCtgItems(widget.data['id']);
    setState(() {
      isLoading = false;
    });

    _tabController = TabController(length: ctgItems.length, vsync: this);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    getCtgItems();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= 250) {
      if (titleOpacity == 1) return;
      setState(() {
        {
          titleOpacity = 1;
        }
      });
    } else {
      if (titleOpacity == 0) return;
      setState(() {
        {
          titleOpacity = 0;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Opacity(
                opacity: titleOpacity,
                child: Text(
                  widget.data['restaurant'],
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'ubuntu-bold',
                      fontSize: 20),
                ),
              ),
              forceElevated: true,
              elevation: 5,
              //scrolledUnderElevation: 50,
              leading: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              backgroundColor: Colors.white,
              expandedHeight: 300.0 + widget.data['description'].length / 3,
              //floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.data['image'],
                      cacheManager: appCacheManager,
                      imageBuilder: (context, imageProvider) => Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: Text(
                              widget.data['restaurant'],
                              style: const TextStyle(
                                  fontFamily: 'ubuntu-bold', fontSize: 20),
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReviewInfoPage(
                                            resData: widget.data)));
                              },
                              child: const Text(
                                'Reviews & Info',
                              )),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.data['description'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70.0),
                child: ResTabs(
                  tabController: _tabController,
                  isLoading: isLoading,
                  tabs: ctgItems.keys.toList(),
                ),
              ),
            ),
          ];
        },
        body: isLoading
            ? const CustomShimmer()
            : TabBarView(
                controller: _tabController,
                children: ctgItems.keys
                    .toList()
                    .map((e) => ItemList(
                          itemList: ctgItems[e]!,
                          restId: widget.data['id'],
                        ))
                    .toList(),
              ),
      ),
    );
  }
}

class ResTabs extends StatefulWidget {
  const ResTabs(
      {super.key,
      required this.tabController,
      required this.tabs,
      required this.isLoading});
  final TabController? tabController;
  final List<String> tabs;
  final bool isLoading;

  @override
  State<ResTabs> createState() => _ResTabsState();
}

class _ResTabsState extends State<ResTabs> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? CustomShimmer(
            width: MediaQuery.of(context).size.width,
            height: 50,
          )
        : Container(
            color: Colors.white,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TabBar(
              isScrollable: true,
              controller: widget.tabController,
              labelColor: appGreen,
              labelStyle: const TextStyle(
                fontFamily: 'ubuntu-bold',
                fontSize: 15,
              ),
              unselectedLabelColor: Colors.grey,
              indicatorColor: appGreen,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: appGreen,
                  width: 3.0,
                ),
                insets: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              tabs: widget.tabs
                  .map(
                    (e) => Tab(
                      text: e,
                    ),
                  )
                  .toList(),
            ),
          );
  }
}

class ItemList extends StatefulWidget {
  const ItemList({super.key, required this.itemList, required this.restId});
  final List<Item> itemList;
  final String restId;

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListView.builder(
        itemCount: widget.itemList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDescPage(
                      item: widget.itemList[index],
                      restId: widget.restId,
                    ),
                  ),
                );
              },
              child: widget.itemList[index].buildItemCard());
        },
      ),
    );
  }
}
