import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pophub/model/goods_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/notifier/GoodsNotifier.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/nav/bottom_navigation_page.dart';
import 'package:pophub/utils/api.dart';
import 'package:pophub/utils/log.dart';
import 'package:pophub/utils/utils.dart';
import 'package:provider/provider.dart';

class GoodsCreatePage extends StatefulWidget {
  final String mode;
  final String storeId;
  final GoodsModel? goods;

  final String? productId;

  const GoodsCreatePage({
    super.key,
    this.mode = "add",
    this.goods,
    required this.storeId,
    this.productId,
  });

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
    if (widget.goods != null) {
      _nameController.text = widget.goods?.productName ?? '';
      _priceController.text = widget.goods?.price.toString() ?? '0';
      _quantityController.text = widget.goods?.quantity.toString() ?? '0';
      _descriptionController.text = widget.goods?.description ?? '';

      if (widget.goods != null) {
        Provider.of<GoodsNotifier>(context, listen: false).productName =
            widget.goods?.productName ?? '';
        Provider.of<GoodsNotifier>(context, listen: false).price =
            widget.goods?.price ?? 0;
        Provider.of<GoodsNotifier>(context, listen: false).quantity =
            widget.goods?.quantity ?? 0;
        Provider.of<GoodsNotifier>(context, listen: false).description =
            widget.goods?.description ?? '';

        Provider.of<GoodsNotifier>(context, listen: false).images = widget
                .goods!.image
                ?.map((imageUrl) => {'type': 'url', 'data': imageUrl})
                .toList() ??
            [];
      }
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
    goods.userName = User().userName;
    Logger.debug(goods.toString());
    final data = await Api.goodsAdd(goods, widget.storeId);

    if (!data.toString().contains("fail") && mounted) {
      showAlert(context, "성공", "굿즈가 등록되었습니다.", () {
        Navigator.of(context).pop();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MultiProvider(providers: [
                      ChangeNotifierProvider(create: (_) => UserNotifier())
                    ], child: const BottomNavigationPage())));
      });
    } else {}
  }

  Future<void> goodsModify(GoodsNotifier goods) async {
    final data = await Api.goodsModify(goods, widget.productId.toString());

    if (!data.toString().contains("fail") && mounted) {
      showAlert(context, "성공", "팝업스토어 수정이 완료되었습니다.", () {
        Navigator.of(context).pop();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MultiProvider(providers: [
                      ChangeNotifierProvider(create: (_) => UserNotifier())
                    ], child: const BottomNavigationPage())));
      });
    } else {}
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
                  onChanged: (value) => goods.price = int.parse(value),
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
                  onChanged: (value) => goods.quantity = int.parse(value),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: OutlinedButton(
                    onPressed: () {
                      if (widget.mode == "modify") {
                        goodsModify(goods);
                      } else if (widget.mode == "add") {
                        goodsAdd(goods);
                      }
                    },
                    child: const Text('완료'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
