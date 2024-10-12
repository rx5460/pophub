import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/answer_model.dart';
import 'package:pophub/model/inquiry_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/setting/inquiry_answer.dart';
import 'package:pophub/screen/setting/inquiry_write.dart';
import 'package:pophub/utils/api/inquiryl_api.dart';
import 'package:pophub/utils/log.dart';

class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  InquiryPageState createState() => InquiryPageState();
}

class InquiryPageState extends State<InquiryPage> {
  List<InquiryModel> inquiryList = [];

  @override
  void initState() {
    getInquiryData();
    super.initState();
  }

  Future<void> getInquiryData() async {
    Logger.debug("### ${User().role}");
    final data = User().role == "Manager"
        ? await InquiryApi.getAllInquiryList()
        : await InquiryApi.getInquiryList(User().userName);

    if (data.toString().contains("fail")) {
      // Handle error
    } else {
      setState(() {
        inquiryList = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: CustomTitleBar(titleName: ('titleName_14').tr()),
      body: Padding(
        padding: const EdgeInsets.only(bottom: Constants.DEFAULT_PADDING),
        child: Column(
          children: [
            Expanded(
              child: inquiryList.isNotEmpty
                  ? ListView.builder(
                      itemCount: inquiryList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InquiryTile(inquiry: inquiryList[index]);
                      },
                    )
                  : Center(
                      child: Text(('there_are_no_inquiries').tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ))),
            ),
            Visibility(
              visible: User().role != "Manager",
              child: Padding(
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
                  child: Text(
                    ('titleName_12').tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
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
  InquiryTileState createState() => InquiryTileState();
}

class InquiryTileState extends State<InquiryTile> {
  bool _isExpanded = false;
  bool _isLoading = false;
  InquiryModel? inquiryDetail;
  AnswerModel? answerDetail;

  Future<void> _fetchContent() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final content = await InquiryApi.getInquiry(widget.inquiry.inquiryId);

      if (widget.inquiry.status == "complete" ||
          widget.inquiry.answerStatus == "complete") {
        final answer = await InquiryApi.getAnswer(widget.inquiry.inquiryId);
        setState(() {
          answerDetail = answer;
        });
      }
      setState(() {
        inquiryDetail = content;
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
        subtitle: Row(
          children: [
            Text(DateFormat("yyyy.MM.dd")
                .format(DateTime.parse(widget.inquiry.writeDate))),
            SizedBox(
              width: screenWidth * 0.02,
            ),
            SizedBox(
                width: screenWidth * 0.2,
                height: screenHeight * 0.04,
                child: ((widget.inquiry.status == "pending" ||
                            widget.inquiry.answerStatus == "pending") &&
                        User().role == "Manager")
                    ? OutlinedButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InquiryAnswerPage(
                                inquiryId: widget.inquiry.inquiryId,
                              ),
                            ),
                          ),
                        },
                        child: Text(('reply').tr()),
                      )
                    : widget.inquiry.status == "complete" ||
                            widget.inquiry.answerStatus == "complete"
                        ? OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            onPressed: () => {},
                            child: Text(
                              ('complete').tr(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          )
                        : OutlinedButton(
                            style: OutlinedButton.styleFrom(),
                            onPressed: () => {},
                            child: Text(
                              ('receipt').tr(),
                            ),
                          )),
          ],
        ),
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
              padding: const EdgeInsets.all(16.0),
              child: const CircularProgressIndicator(),
            )
          else if (inquiryDetail != null)
            Container(
              width: screenWidth,
              color: Constants.LIGHT_GREY,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(inquiryDetail!.content.toString()),
                  Visibility(
                    visible: inquiryDetail!.image != null,
                    child: SizedBox(
                      height: screenHeight * 0.01,
                    ),
                  ),
                  inquiryDetail!.image != null
                      ? Image.network(
                          inquiryDetail!.image.toString(),
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                        )
                      : Container(),
                  Visibility(
                    visible: inquiryDetail!.answerStatus == "complete",
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Text(
                            ('we_will_respond_to_your_inquiries').tr(),
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(DateFormat("yyyy.MM.dd").format(
                              DateTime.parse(widget.inquiry.writeDate))),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          SizedBox(
                            width: screenWidth * 0.02,
                          ),
                          answerDetail != null
                              ? Text(answerDetail!.content.toString())
                              : Container()
                        ]),
                  )
                ],
              ),
            )
          else
            Container(
              width: screenWidth,
              color: Constants.LIGHT_GREY,
              padding: const EdgeInsets.all(16.0),
              child: Text(('an_error_occurred_while_loading_content').tr()),
            ),
        ],
      ),
    );
  }
}
