import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/category_model.dart';
import 'package:pophub/model/kopo_model.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/model/schedule_model.dart';
import 'package:pophub/notifier/StoreNotifier.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/nav/bottom_navigation.dart';
import 'package:pophub/screen/store/store_operate_hour.dart';
import 'package:pophub/utils/api/category_api.dart';
import 'package:pophub/utils/api/store_api.dart';
import 'package:pophub/utils/remedi_kopo.dart';
import 'package:pophub/utils/utils.dart';
import 'package:provider/provider.dart';

class StoreCreatePage extends StatefulWidget {
  final String mode;
  final PopupModel? popup;

  const StoreCreatePage({super.key, this.mode = "add", this.popup});

  @override
  _StoreCreatePageState createState() => _StoreCreatePageState();
}

class _StoreCreatePageState extends State<StoreCreatePage> {
  List<CategoryModel> category = [];
  @override
  void initState() {
    super.initState();
    _initializeFields();
    getCategory();
  }

  void _initializeFields() {
    if (widget.popup != null) {
      _nameController.text = widget.popup?.name ?? '';
      _descriptionController.text = widget.popup?.description ?? '';

      String locationPart = "";
      if (widget.popup?.location != null &&
          widget.popup!.location!.isNotEmpty) {
        List<String> parts = widget.popup!.location!.split("/");
        if (parts.length > 1) {
          locationPart = parts[1];
        }
      }

      _locationController.text = locationPart;
      _contactController.text = widget.popup?.contact ?? '';
      _maxCapacityController.text = widget.popup?.view?.toString() ?? '';

      Provider.of<StoreModel>(context, listen: false).name =
          widget.popup?.name ?? '';
      Provider.of<StoreModel>(context, listen: false).description =
          widget.popup?.description ?? '';
      Provider.of<StoreModel>(context, listen: false).location =
          widget.popup?.location ?? '';
      Provider.of<StoreModel>(context, listen: false).contact =
          widget.popup?.contact ?? '';
      Provider.of<StoreModel>(context, listen: false).maxCapacity =
          widget.popup?.view ?? 0;

      Provider.of<StoreModel>(context, listen: false).startDate =
          DateTime.parse(widget.popup?.start ?? DateTime.now().toString());
      Provider.of<StoreModel>(context, listen: false).endDate =
          DateTime.parse(widget.popup?.end ?? DateTime.now().toString());

      Provider.of<StoreModel>(context, listen: false).schedule =
          widget.popup!.schedule;

      Provider.of<StoreModel>(context, listen: false).id = widget.popup!.id!;

      Provider.of<StoreModel>(context, listen: false).category =
          widget.popup?.category?.toString() ?? '';
      Provider.of<StoreModel>(context, listen: false).images = widget
              .popup?.image
              ?.map((imageUrl) => {'type': 'url', 'data': imageUrl})
              .toList() ??
          [];
    }
  }

  Future<void> getCategory() async {
    final data = await CategoryApi.getCategoryList();
    setState(() {
      category = data.where((item) => item.categoryId >= 10).toList();
      if (widget.popup != null) {
        selectedCategory = category.firstWhere(
          (item) =>
              item.categoryId.toString() == widget.popup?.category.toString(),
        );
      }
    });
    print("Data $data");
  }

  final ImagePicker _picker = ImagePicker();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();
  final _maxCapacityController = TextEditingController();
  CategoryModel? selectedCategory;

  Future<void> _pickImage() async {
    try {
      if (Provider.of<StoreModel>(context, listen: false).images.length < 5) {
        final XFile? pickedImage =
            await _picker.pickImage(source: ImageSource.gallery);

        if (pickedImage != null && mounted) {
          Provider.of<StoreModel>(context, listen: false)
              .addImage({'type': 'file', 'data': File(pickedImage.path)});
        }
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(('warning').tr()),
                content: Text(('up_to_5_photos_can_be_registered').tr()),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(('check').tr()),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? Provider.of<StoreModel>(context, listen: false).startDate
          : Provider.of<StoreModel>(context, listen: false).endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && mounted) {
      if (isStartDate) {
        Provider.of<StoreModel>(context, listen: false).updateStartDate(picked);
      } else {
        DateTime startDate =
            Provider.of<StoreModel>(context, listen: false).startDate;
        if (picked.isBefore(startDate)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  ('the_operation_end_date_cannot_be_set_before_the_operation_start_date')
                      .tr()),
            ),
          );
        } else {
          Provider.of<StoreModel>(context, listen: false).updateEndDate(picked);
        }
      }
    }
  }

  bool _validateInputs(StoreModel store) {
    if (_nameController.text.isEmpty) {
      _showValidationDialog(('please_enter_the_store_name').tr());
      return false;
    }
    if (_descriptionController.text.isEmpty) {
      _showValidationDialog(('please_enter_a_store_description').tr());
      return false;
    }
    if (store.location.isEmpty) {
      _showValidationDialog(('please_select_a_store_location').tr());
      return false;
    }
    if (_contactController.text.isEmpty) {
      _showValidationDialog(('please_enter_your_contact_information').tr());
      return false;
    }
    if (widget.mode == "add" && _maxCapacityController.text.isEmpty) {
      _showValidationDialog(
          ('please_enter_the_maximum_number_of_people_per_hour').tr());
      return false;
    }
    if (store.schedule!.isEmpty) {
      _showValidationDialog(('please_set_operating_hours').tr());
      return false;
    }
    if (selectedCategory == null) {
      _showValidationDialog(('please_select_a_category').tr());
      return false;
    }
    return true;
  }

  void _showValidationDialog(String message) {
    showAlert(context, ('failure').tr(), message, () {
      Navigator.of(context).pop();
    });
  }

  Future<void> _pickLocation() async {
    if (!mounted) return;

    KopoModel? model = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );

    if (model != null && model.address != null) {
      if (mounted) {
        Provider.of<StoreModel>(context, listen: false)
            .updateLocation(model.address!);
      }
    }
  }

  Future<void> storeAdd(StoreModel store) async {
    final data = await StoreApi.postStoreAdd(store);

    if (!data.toString().contains("fail") && mounted) {
      showAlert(context, ('success').tr(),
          ('the_popup_store_application_has_been_completed').tr(), () {
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

  Future<void> storeModify(StoreModel store) async {
    final data = await StoreApi.putStoreModify(store);

    if (!data.toString().contains("fail") && mounted) {
      showAlert(
          context, ('success').tr(), ('the_popup_store_has_been_modified').tr(),
          () {
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

  void _showOperatingHoursModal(BuildContext context, StoreModel storeModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StoreOperatingHoursModal(storeModel: storeModel);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: CustomTitleBar(
          titleName: widget.mode == "modify"
              ? ('edit_store').tr()
              : ('add_store').tr()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<StoreModel>(
          builder: (context, store, child) {
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
                      ...store.images
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
                                      onTap: () => store.removeImage(image),
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
                Text(
                  ('store_name').tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: ('labelText_10').tr()),
                  onChanged: (value) => store.name = value,
                ),
                const SizedBox(height: 20),
                Text(
                  ('store_description').tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      labelText: ('labelText_11').tr(),
                      alignLabelWithHint: true),
                  maxLines: 4,
                  onChanged: (value) => store.description = value,
                ),
                const SizedBox(height: 20),
                Text(
                  ('store_location').tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Constants.BUTTON_GREY),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      ('store_location').tr(),
                    ),
                    subtitle: store.location.isNotEmpty
                        ? Text(store.location.split("/").first)
                        : null,
                    trailing: const Icon(
                      Icons.location_on,
                      color: Colors.grey,
                    ),
                    onTap: () => _pickLocation(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: ('labelText_7').tr()),
                  onChanged: (value) => store.locationDetail = value,
                ),
                const SizedBox(height: 20),
                Text(
                  ('operating_hours').tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Constants.BUTTON_GREY),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      ('set_operating_hours').tr(),
                    ),
                    trailing: const Icon(Icons.access_time,
                        color: Constants.DARK_GREY),
                    onTap: () {
                      _showOperatingHoursModal(context, store);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: store.schedule!.isNotEmpty,
                  child: SizedBox(
                    width: screenWidth * 0.5,
                    height:
                        screenHeight * (store.schedule!.length * 0.2) * 0.22,
                    child: Consumer<StoreModel>(
                      builder: (context, store, child) {
                        return store.schedule != null
                            ? ListView.builder(
                                itemCount: store.schedule!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  Schedule schedule = store.schedule![index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 16.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(getDayOfWeekAbbreviation(
                                                schedule.dayOfWeek, "ko")),
                                            const SizedBox(width: 8),
                                            Text(
                                                '${formatTime(schedule.openTime)} ~ ${formatTime(schedule.closeTime)}'),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            store.removeScheduleAt(index);
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Icon(
                                              Icons.close,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Container();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  ('operating_period').tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Constants.BUTTON_GREY),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            ('operation_start_date').tr(),
                          ),
                          subtitle: Text(
                            _dateFormat.format(store.startDate),
                          ),
                          trailing: const Icon(
                            Icons.calendar_today,
                            color: Constants.DARK_GREY,
                          ),
                          onTap: () => _selectDate(true),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Constants.BUTTON_GREY),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            ('operation_end_date').tr(),
                          ),
                          subtitle: Text(
                            _dateFormat.format(store.endDate),
                          ),
                          trailing: const Icon(
                            Icons.calendar_today,
                            color: Constants.DARK_GREY,
                          ),
                          onTap: () => _selectDate(false),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  ('labelText_12').tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _contactController,
                  decoration: InputDecoration(labelText: ('labelText_12').tr()),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  onChanged: (value) => store.contact = value,
                ),
                const SizedBox(height: 20),
                Visibility(
                    visible: widget.mode == "add",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ('labelText_13').tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                            controller: _maxCapacityController,
                            decoration: InputDecoration(
                                labelText: ('labelText_13').tr()),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1000),
                            ],
                            onChanged: (value) => {
                                  if (value != '')
                                    {store.maxCapacity = int.parse(value)},
                                }),
                        const SizedBox(height: 20),
                      ],
                    )),
                Text(
                  ('labelText_8').tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<CategoryModel>(
                  decoration: InputDecoration(labelText: ('labelText_8').tr()),
                  value: selectedCategory,
                  items: category.map((categoryModel) {
                    return DropdownMenuItem<CategoryModel>(
                      value: categoryModel,
                      child: Text(categoryModel.categoryName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value;
                        store.category = value.categoryId.toString();
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: OutlinedButton(
                    onPressed: () {
                      if (_validateInputs(store)) {
                        if (widget.mode == "modify") {
                          storeModify(store);
                        } else if (widget.mode == "add") {
                          storeAdd(store);
                        }
                      }
                    },
                    child: Text(('complete').tr()),
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
