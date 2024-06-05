import 'package:flutter/material.dart';
import 'package:pophub/model/inquiry_model.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/setting/inquiry_page.dart';
import 'package:pophub/utils/api.dart';
import 'package:pophub/utils/utils.dart';

class InquiryAnswerPage extends StatefulWidget {
  final int inquiryId;
  const InquiryAnswerPage({super.key, required this.inquiryId});

  @override
  _InquiryAnswerPageState createState() => _InquiryAnswerPageState();
}

class _InquiryAnswerPageState extends State<InquiryAnswerPage> {
  final _answerContentController = TextEditingController();
  InquiryModel? inquiry;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getInquiryData();
  }

  Future<void> _submitInquiry() async {
    String content = _answerContentController.text;

    Map<String, dynamic> data =
        await Api.inquiryAnswer(widget.inquiryId, content);

    if (!data.toString().contains("fail")) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const InquiryPage(),
          ),
        );
      }
    } else {
      if (mounted) {
        showAlert(context, "경고", "문의 추가에 실패했습니다.", () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  Future<void> getInquiryData() async {
    final content = await Api.getInquiry(widget.inquiryId);
    setState(() {
      inquiry = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: const CustomTitleBar(titleName: "문의 답변 하기"),
      body: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          top: screenHeight * 0.05,
          bottom: screenHeight * 0.05,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('문의 제목',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  width: screenWidth,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    inquiry != null ? inquiry!.title.toString() : "",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('문의 내용',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                    width: screenWidth,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inquiry != null ? inquiry!.content.toString() : "",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        inquiry != null
                            ? inquiry!.image != null
                                ? Image.network(
                                    inquiry!.image.toString(),
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fill,
                                  )
                                : Container()
                            : Container(),
                      ],
                    )),
              ),
              const SizedBox(height: 16),
              const Text('답변 내용',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: _answerContentController,
                decoration: const InputDecoration(hintText: '답변 내용을 입력하세요'),
                maxLines: 6,
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _submitInquiry,
                child: const Text('완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
