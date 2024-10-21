import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/model/tracking_model.dart';
import 'package:pophub/utils/api/delivery_api.dart';
import 'package:pophub/utils/log.dart';

class TrackingListPage extends StatefulWidget {
  final String courier;
  final String trackingNum;
  const TrackingListPage(
      {Key? key, required this.courier, required this.trackingNum})
      : super(key: key);

  @override
  State<TrackingListPage> createState() => _TrackingListState();
}

class _TrackingListState extends State<TrackingListPage> {
  List<DeliveryTrackingModel> deliveryList = [];
  Map<int, bool> expandedItems = {};
  bool isLoading = true;

  Future<void> fetchDeliveryData() async {
    try {
      List<DeliveryTrackingModel> dataList = await DeliveryApi.gettracking(
          widget.courier, int.parse(widget.trackingNum));
      setState(() {
        deliveryList = dataList;
        expandedItems = {
          for (var item in List.generate(dataList.length, (index) => index))
            item: false
        };
        isLoading = false;
      });
    } catch (error) {
      Logger.debug('Error fetching delivery data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDeliveryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          ('delivery_list').tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : deliveryList.isEmpty
              ? const Center(child: Text('등록된 배송정보가 없습니다.'))
              : ListView.builder(
                  itemCount: deliveryList.length,
                  itemBuilder: (context, index) {
                    DeliveryTrackingModel delivery = deliveryList[index];
                    bool isExpanded = expandedItems[index] ?? false;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: isExpanded,
                        onExpansionChanged: (expanded) {
                          setState(() {
                            expandedItems[index] = expanded;
                          });
                        },
                        title: Text(
                          delivery.carrier.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              delivery.state.text,
                              style: TextStyle(
                                color: _getStatusColor(delivery.state.id),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              DateFormat("yyyy.MM.dd")
                                  .format(delivery.from.time),
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow('Sender', delivery.from.name),
                                _buildInfoRow('Receiver', delivery.to.name),
                                _buildInfoRow(
                                    'Carrier Tel', delivery.carrier.tel),
                                const SizedBox(height: 16),
                                const Text('Delivery Progress:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                ...delivery.progresses.map((progress) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            DateFormat("yyyy.MM.dd\nHH:mm")
                                                .format(progress.time),
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(progress.status.text,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(progress.location.name,
                                                  style: TextStyle(
                                                      color: Colors.grey[600])),
                                              Text(progress.description,
                                                  style: const TextStyle(
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Color _getStatusColor(String statusId) {
    switch (statusId) {
      case 'delivered':
        return Colors.green;
      case 'in_transit':
        return Colors.blue;
      case 'out_for_delivery':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
