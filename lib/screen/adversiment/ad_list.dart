import 'package:flutter/material.dart';

class AdList extends StatefulWidget {
  const AdList({Key? key}) : super(key: key);

  @override
  AdListState createState() => AdListState();
}

class AdListState extends State<AdList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color pinkColor = const Color(0xFFE6A3B3);
  final Color lightPinkColor = const Color(0xFFF0B7C3);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '광고',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: pinkColor,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: '광고 요청'),
            Tab(text: '광고 리스트'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAdRequestTab(),
          _buildAdListTab(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: pinkColor,
              minimumSize: const Size(double.infinity, 50),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: const Text(
              '광고 등록 하기',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 광고 요청 static 구현
  Widget _buildAdRequestTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildAdRequestItem(
          title: '광고 문의 드려요.',
          name: '연정흠',
          date: '2024.09.06',
          status: '답변하기',
          isCompleted: false,
          content: '광고에 대해 문의 드립니다. 더 많은 정보를 알고 싶습니다.',
          answer: '',
          answerDate: '',
        ),
        const SizedBox(height: 16.0),
        _buildAdRequestItem(
          title: '광고는 어떻게 하나요?',
          name: '황지민',
          date: '2024.09.07',
          status: '완료',
          isCompleted: true,
          content: '광고 등록 절차를 알고 싶습니다.',
          answer: '광고 등록 절차는 간단합니다. 먼저 양식을 작성해 주시면 됩니다.',
          answerDate: '2024.09.08',
        ),
      ],
    );
  }

  Widget _buildAdListTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ListTile(
          title: const Text(
            '나의 히어로 아카데미아',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            '2024.09.06',
            style: TextStyle(color: Colors.grey),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // 삭제 로직
            },
          ),
          onTap: () {
            // 광고 상세 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdItemDetail(
                  title: '나의 히어로 아카데미아',
                  date: '2024.09.06',
                  content: '나의 히어로 아카데미아는 개꿀잼입니다!',
                ),
              ),
            );
          },
        ),
        ListTile(
          title: const Text(
            '원피스',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            '2024.09.07',
            style: TextStyle(color: Colors.grey),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // 삭제 로직
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdItemDetail(
                  title: '원피스',
                  date: '2024.09.07',
                  content: '원피스도 개꿀잼이에요!',
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAdRequestItem({
    required String title,
    required String name,
    required String date,
    required String status,
    required bool isCompleted,
    required String content,
    required String answer,
    required String answerDate,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdRequestDetail(
              title: title,
              name: name,
              date: date,
              status: status,
              isCompleted: isCompleted,
              content: content,
              answer: answer,
              answerDate: answerDate,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '$name | $date',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.transparent : pinkColor,
                borderRadius: BorderRadius.circular(12.0),
                border: isCompleted ? Border.all(color: lightPinkColor) : null,
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? lightPinkColor : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdItemDetail extends StatelessWidget {
  final String title;
  final String date;
  final String content;

  const AdItemDetail({
    Key? key,
    required this.title,
    required this.date,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '광고 상세 정보',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              date,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              content,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

class AdRequestDetail extends StatelessWidget {
  final String title;
  final String name;
  final String date;
  final String status;
  final bool isCompleted;
  final String content;
  final String answer;
  final String answerDate;

  const AdRequestDetail({
    Key? key,
    required this.title,
    required this.name,
    required this.date,
    required this.status,
    required this.isCompleted,
    required this.content,
    required this.answer,
    required this.answerDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color pinkColor = Color(0xFFE6A3B3);
    const Color lightPinkColor = Color(0xFFF0B7C3);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '광고 요청 상세 정보',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$name | $date',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.transparent : pinkColor,
                    borderRadius: BorderRadius.circular(12.0),
                    border:
                        isCompleted ? Border.all(color: lightPinkColor) : null,
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? lightPinkColor : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              content,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 24.0),
            if (isCompleted)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '광고 문의 답변드립니다.',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '답변 날짜: $answerDate',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    answer,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
