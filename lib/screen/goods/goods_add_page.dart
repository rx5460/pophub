import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pophub/model/goods_model.dart';
import 'package:pophub/notifier/GoodsNotifier.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:provider/provider.dart';

class GoodsCreatePage extends StatefulWidget {
  final String mode;
  final GoodsModel? popup;

  const GoodsCreatePage({super.key, this.mode = "add", this.popup});

  @override
  _GoodsCreatePageState createState() => _GoodsCreatePageState();
}

class _GoodsCreatePageState extends State<GoodsCreatePage> {
  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    if (widget.popup != null) {
      _nameController.text = widget.popup?.productName ?? '';
      _priceController.text = widget.popup?.price.toString() ?? '0';
      _quantityController.text = widget.popup?.quantity.toString() ?? '0';
      _descriptionController.text = widget.popup?.description ?? '';

      Provider.of<GoodsNotifier>(context, listen: false).productName =
          widget.popup?.productName ?? '';
      Provider.of<GoodsNotifier>(context, listen: false).price =
          widget.popup?.price ?? 0;
      Provider.of<GoodsNotifier>(context, listen: false).quantity =
          widget.popup?.quantity ?? 0;
      Provider.of<GoodsNotifier>(context, listen: false).description =
          widget.popup?.description ?? '';

      // Provider.of<GoodsNotifier>(context, listen: false).images = widget
      //         .popup?.image
      //         .map((imageUrl) => {'type': 'url', 'data': imageUrl})
      //         .toList() ??
      //     [];
    }
  }

  final ImagePicker _picker = ImagePicker();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null && mounted) {
        Provider.of<GoodsNotifier>(context, listen: false)
            .addImage({'type': 'file', 'data': File(pickedImage.path)});
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> goodsAdd(GoodsNotifier goods) async {
    // final data = await Api.goodsAdd(goods);

    // if (!data.toString().contains("fail") && mounted) {
    //   showAlert(context, "성공", "팝업스토어 신청이 완료되었습니다.", () {
    //     Navigator.of(context).pop();

    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => MultiProvider(providers: [
    //                   ChangeNotifierProvider(create: (_) => UserNotifier())
    //                 ], child: const BottomNavigationPage())));
    //   });
    // } else {}
  }

  Future<void> goodsModify(GoodsNotifier goods) async {
    // final data = await Api.goodsModify(goods);

    // if (!data.toString().contains("fail") && mounted) {
    //   showAlert(context, "성공", "팝업스토어 수정이 완료되었습니다.", () {
    //     Navigator.of(context).pop();

    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => MultiProvider(providers: [
    //                   ChangeNotifierProvider(create: (_) => UserNotifier())
    //                 ], child: const BottomNavigationPage())));
    //   });
    // } else {}
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: CustomTitleBar(
          titleName: widget.mode == "modify" ? "굿즈 수정" : "굿즈 추가"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<GoodsNotifier>(
          builder: (context, goods, child) {
            return ListView(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: OutlinedButton(
                          onPressed: () => _pickImage(),
                          child: const Icon(Icons.add),
                        ),
                      ),
                      ...goods.images
                          .map((image) => Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: image['type'] == 'file'
                                        ? Image.file(
                                            image['data'],
                                            width: 60,
                                            height: 60,
                                          )
                                        : Image.network(
                                            image['data'],
                                            width: 60,
                                            height: 60,
                                          ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () => goods.removeImage(image),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "굿즈 이름",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: '굿즈 이름을 작성해주세요.'),
                  onChanged: (value) => goods.productName = value,
                ),
                const SizedBox(height: 20),
                const Text(
                  "가격",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: '가격'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  onChanged: (value) => goods.description = value,
                ),
                const SizedBox(height: 20),
                const Text(
                  "수량",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: '수량'),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1000),
                    ],
                    onChanged: (value) => {}
                    //goods.quantity = value,
                    ),
                const SizedBox(height: 20),
                const Text(
                  "굿즈 설명",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      labelText: '굿즈 설명을 작성해주세요.', alignLabelWithHint: true),
                  maxLines: 4,
                  onChanged: (value) => goods.description = value,
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
