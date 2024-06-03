import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = [];
  final List<Map<String, String>> _categories = [
    {"name": "의류", "icon": "clothing_icon"},
    {"name": "액세서리", "icon": "accessory_icon"},
    {"name": "신발", "icon": "shoes_icon"},
    {"name": "가방/지갑", "icon": "bags_wallets_icon"},
    {"name": "뷰티/화장품", "icon": "beauty_cosmetics_icon"},
    {"name": "가전제품", "icon": "electronics_icon"},
    {"name": "생활용품", "icon": "household_items_icon"},
    {"name": "푸드/음료", "icon": "food_beverages_icon"},
    {"name": "스포츠 용품", "icon": "sports_goods_icon"},
    {"name": "문구/책/잡화", "icon": "stationery_books_misc_icon"},
    {"name": "아이용품", "icon": "kids_items_icon"},
    {"name": "전자기기/액세서리", "icon": "gadgets_accessories_icon"},
    {"name": "건강/웰빙제품", "icon": "health_wellness_icon"},
    {"name": "패션/라이프스타일", "icon": "fashion_lifestyle_icon"},
    {"name": "예술/공예품", "icon": "art_crafts_icon"},
    {"name": "기타", "icon": "others_icon"},
  ];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  Future<void> _addRecentSearch(String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _recentSearches.add(search);
    await prefs.setStringList('recentSearches', _recentSearches);
    _loadRecentSearches();
  }

  void _search(String query) async {
    // if (query.isNotEmpty) {
    await _addRecentSearch(query);
    //   // Perform search with Dio
    //   try {
    //     var response = await Dio().get('https://api.example.com/search',
    //         queryParameters: {'query': query});
    //     // Handle the response as needed
    //     print(response.data);
    //   } catch (e) {
    //     print(e);
    //   }
    // }
  }

  void _searchByCategory(String category) async {
    // Perform search by category with Dio
    // try {
    //   var response = await Dio().get('https://api.example.com/search',
    //       queryParameters: {'category': category});
    //   // Handle the response as needed
    //   print(response.data);
    // } catch (e) {
    //   print(e);
    // }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'clothing_icon':
        return Icons.checkroom;
      case 'accessory_icon':
        return Icons.watch;
      case 'shoes_icon':
        return Icons.directions_walk;
      case 'bags_wallets_icon':
        return Icons.work;
      case 'beauty_cosmetics_icon':
        return Icons.palette;
      case 'electronics_icon':
        return Icons.electrical_services;
      case 'household_items_icon':
        return Icons.kitchen;
      case 'food_beverages_icon':
        return Icons.local_cafe;
      case 'sports_goods_icon':
        return Icons.sports_soccer;
      case 'stationery_books_misc_icon':
        return Icons.book;
      case 'kids_items_icon':
        return Icons.child_friendly;
      case 'gadgets_accessories_icon':
        return Icons.memory;
      case 'health_wellness_icon':
        return Icons.health_and_safety;
      case 'fashion_lifestyle_icon':
        return Icons.style;
      case 'art_crafts_icon':
        return Icons.brush;
      case 'others_icon':
        return Icons.category;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTitleBar(
        titleName: "검색",
        useBack: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '어떤 정보를 찾아볼까요?',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _search(_searchController.text);
                  },
                ),
              ),
            ),
            if (_recentSearches.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('최근 검색어',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: _recentSearches
                    .map(
                      (search) => Chip(
                        label: Text(search),
                        onDeleted: () {
                          setState(() {
                            _recentSearches.remove(search);
                          });
                        },
                        deleteIcon:
                            const Icon(Icons.clear, size: 20), // 삭제 아이콘 크기 설정
                        deleteIconColor: Colors.black, // 삭제 아이콘 색상 설정
                        labelStyle: const TextStyle(
                            color: Colors.black), // 라벨 텍스트 스타일 설정
                        backgroundColor: Colors.white, // Chip 배경색 설정
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0), // Chip 패딩 설정
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Constants.DEFAULT_COLOR),
                          borderRadius: BorderRadius.circular(20), // Chip 모양 설정
                        ),
                      ),
                    )
                    .toList(),
              )
            ],
            const SizedBox(height: 16),
            const Text('카테고리',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
                child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                // 각 아이템에 해당하는 카테고리의 이름과 아이콘 이름을 꺼냅니다.
                var categoryName = _categories[index]["name"]!;
                var iconData = _getIconData(_categories[index]
                    ["icon"]!); // 이 함수는 아이콘 이름을 IconData로 변환합니다.

                return GestureDetector(
                  onTap: () => _searchByCategory(_categories[index]["name"]!),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Constants.DEFAULT_COLOR),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          iconData,
                          size: 35,
                        ), // 실제 아이콘으로 교체
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        categoryName, // 맵에서 이름을 직접 참조
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
