import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/utils/api.dart';
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
  Set<Marker> markers = {};

  bool draggable = true;
  bool zoomable = true;

  Clusterer? clusterer;
  List<PopupModel>? popupList;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAllPopupList();
  }

  Future<void> getAllPopupList() async {
    try {
      final marker = await Api.getAllPopupList();

      if (marker.isNotEmpty) {
        setState(() {
          markers = marker;
          isLoading = false;
        });

        Logger.debug(locationList.toString());
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
      appBar: const CustomTitleBar(
        titleName: "지도",
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
            ),
    );
  }
}
