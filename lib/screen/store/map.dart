import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/store/popup_view.dart';
import 'package:pophub/utils/api/store_api.dart';
import 'package:pophub/utils/log.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late KakaoMapController mapController;
  List<Map<String, String>> locationList = [];
  Map<String, Set<Marker>> markersMap = {};
  Set<Marker> markers = {};

  bool draggable = true;
  bool zoomable = true;

  Clusterer? clusterer;
  List<PopupModel>? popupList;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        getAllPopupList();
      },
    );
  }

  Future<void> getAllPopupList() async {
    try {
      final markerMap = await StoreApi.getAllPopupListForMap();

      if (markerMap.isNotEmpty) {
        setState(() {
          markersMap = markerMap;
          markers = markerMap.values.expand((set) => set).toSet();
          isLoading = false;
        });
      }
    } catch (error) {
      Logger.debug('Error fetching popup data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTitleBar(
        titleName: ('titleName_22').tr(),
        useBack: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : KakaoMap(
              center: LatLng(37.27943075229118, 127.01763998406159),
              onMapCreated: (controller) {
                mapController = controller;

                clusterer = Clusterer(
                  markers: markers.toList(),
                  minLevel: 10,
                  averageCenter: true,
                );

                setState(() {});
              },
              currentLevel: 14,
              clusterer: clusterer,
              onMarkerClustererTap: (latLng, zoomLevel) async {
                int level = await mapController.getLevel() - 1;

                await mapController.setLevel(
                  level,
                  options: LevelOptions(
                    animate: Animate(duration: 500),
                    anchor: latLng,
                  ),
                );
              },
              onMarkerTap: ((markerId, latLng, zoomLevel) async {
                String storeId = markersMap.keys.firstWhere(
                  (name) => markersMap[name]!
                      .any((marker) => marker.markerId == markerId),
                  orElse: () => 'Unknown',
                );

                PopupModel? data = await StoreApi.getPopup(storeId, false, "");
                Logger.debug(data.toString());

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        width: 300, // 원하는 너비로 설정
                        height: 500, // 원하는 너비로 설정

                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 제목
                              Text(
                                data.name.toString(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // 이미지
                              Image.network(
                                data.image != null
                                    ? data.image![0].toString()
                                    : 'assets/images/logo.png', // 원하는 이미지 URL 또는 Asset 이미지
                                width: 150,
                                height: 150,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Text(
                                    (data.start != null &&
                                            data.start!.isNotEmpty)
                                        ? DateFormat("yyyy.MM.dd")
                                            .format(DateTime.parse(data.start!))
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Text(
                                    ' ~ ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    (data.end != null && data.end!.isNotEmpty)
                                        ? DateFormat("yyyy.MM.dd")
                                            .format(DateTime.parse(data.end!))
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // 내용
                              Text(
                                data.description.toString(),
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),

                              // 버튼: 닫기와 상세보기
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 50,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                              color: Colors.grey),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                        ),
                                        child: Text(('close').tr(),
                                            style: const TextStyle(
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          16), // Add spacing between the buttons
                                  Expanded(
                                    child: SizedBox(
                                      height: 50,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PopupDetail(
                                                storeId: storeId,
                                              ),
                                            ),
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor:
                                              Constants.DEFAULT_COLOR,
                                          side: const BorderSide(
                                              color: Colors.grey),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                        ),
                                        child: Text(('show_detail').tr(),
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );

                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return AlertDialog(
                //       title: Text(data.name.toString()), // Title of the modal

                //       content:
                //           Text('Store ID: $storeId'), // Content of the modal
                //       actions: <Widget>[
                //         TextButton(
                //           child: Text(data.description.toString()),
                //           onPressed: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (context) => PopupDetail(
                //                   storeId: storeId,
                //                 ),
                //               ),
                //             );
                //           },
                //         ),
                //         TextButton(
                //           child: Text(data.description.toString()),
                //           onPressed: () {
                //             Navigator.of(context).pop();
                //           },
                //         ),
                //       ],
                //     );
                //   },
                // );

                // ScaffoldMessenger.of(context)
                //     .showSnackBar(SnackBar(content: Text('팝업스토어 이름 $storeId')));
              }),
            ),
    );
  }
}
