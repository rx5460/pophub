import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/model/review_model.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';

class MyReview extends StatefulWidget {
  const MyReview({super.key, required this.reviews, required this.popupModels});
  final List<ReviewModel> reviews;

  final List<PopupModel> popupModels;
  @override
  State<MyReview> createState() => _MyReviewState();
}

class _MyReviewState extends State<MyReview> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: CustomTitleBar(
        titleName: ('titleName_2').tr(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                ('total_visited_stores').tr(args: [
                  [widget.reviews.length].toString()
                ]),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.reviews.length,
                itemBuilder: (context, index) {
                  final review = widget.reviews[index];
                  final popupModel = widget.popupModels[index];
                  return _buildReviewItem(review, screenWidth, popupModel);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(
      ReviewModel review, double screenWidth, PopupModel popup) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: screenWidth * 0.25,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: popup.image?[0] == null
                      ? Image.asset(
                          'assets/images/goods.png',
                          // width: screenHeight * 0.07 - 5,
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          popup.image?[0],
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          fit: BoxFit.cover,
                        )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      popup.name ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (starIndex) => Icon(
                              starIndex < (review.rating ?? 0)
                                  ? Icons.star
                                  : Icons.star_border_outlined,
                              size: 20,
                              color: Constants.REVIEW_STAR_CLOLR,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            DateFormat('yyyy-MM-dd HH:mm')
                                .format(DateTime.parse(review.date.toString())),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      review.content ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
