class SyncList {
  int? id;
  String? deviceName;
  String? process;
  String? created;

  SyncList({
    this.id,
    this.deviceName,
    this.process,
    this.created,
  });

  SyncList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceName = json['device_name'];
    process = json['process'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['device_name'] = deviceName;
    data['process'] = process;
    data['created'] = created;
    return data;
  }
}
