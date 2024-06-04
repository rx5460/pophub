import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/inquiry_detail_model.dart';
import 'package:pophub/model/inquiry_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/setting/inquiry_write_page.dart';
import 'package:pophub/utils/api.dart';
import 'package:pophub/utils/log.dart';

class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  _InquiryPageState createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  @override
  void initState() {
    getInquiryData();
    super.initState();
  }

  List<InquiryModel> inquiryList = [];
  Future<void> getInquiryData() async {
    try {
      final data = await Api.getInquiryList(User().userName);

      setState(() {
        inquiryList = data;
      });
    } catch (error) {
      // 오류 처리
      Logger.debug('Error fetching inquiry data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: const CustomTitleBar(titleName: "문의 내역"),
      body: Padding(
        padding: const EdgeInsets.only(bottom: Constants.DEFAULT_PADDING),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: inquiryList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InquiryTile(inquiry: inquiryList[index]);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenHeight * 0.02, right: screenHeight * 0.02),
              child: OutlinedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InquiryWritePage(),
                    ),
                  ),
                },
                child: const Text("문의 하기"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InquiryTile extends StatefulWidget {
  final InquiryModel inquiry;

  const InquiryTile({super.key, required this.inquiry});

  @override
  _InquiryTileState createState() => _InquiryTileState();
}

class _InquiryTileState extends State<InquiryTile> {
  bool _isExpanded = false;
  bool _isLoading = false;
  InquiryDetailModel? _content;

  Future<void> _fetchContent() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final content = await Api.getInquiry(widget.inquiry.inquiryId);
      setState(() {
        _content = content;
        _isLoading = false;
      });
    } catch (error) {
      Logger.debug('Error fetching inquiry content: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Constants.LIGHT_GREY,
          width: 0.5,
        ),
        borderRadius: const BorderRadius.all(Radius.zero),
      ),
      child: ExpansionTile(
        title: Text(widget.inquiry.title),
        subtitle: Text(widget.inquiry.category),
        onExpansionChanged: (expanded) {
          if (expanded && !_isExpanded) {
            _fetchContent();
          }
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: [
          if (_isLoading)
            Container(
              width: screenWidth,
              color: Constants.LIGHT_GREY,
              padding: const EdgeInsets.all(16.0),
              child: const CircularProgressIndicator(),
            )
          else if (_content != null)
            Container(
              width: screenWidth,
              color: Constants.LIGHT_GREY,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_content!.content.toString()),
                  Visibility(
                    visible: _content!.image != "",
                    child: SizedBox(
                      height: screenHeight * 0.01,
                    ),
                  ),
                  _content!.image != ""
                      ? Image.network(
                          _content!.image.toString(),
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                        )
                      : Container(),
                ],
              ),
            )
          else
            Container(
              width: screenWidth,
              color: Constants.LIGHT_GREY,
              padding: const EdgeInsets.all(16.0),
              child: const Text('내용을 불러오는 중 오류가 발생했습니다.'),
            ),
        ],
      ),
    );
  }
}
