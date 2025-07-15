class NotificationModel {
  int id;
  String title;
  String description;
  String tergat;
  String type;
  String readAt;
  int status;
  int userId;
  String createdAt;
  String updatedAt;
  int zoneId;

  NotificationModel(
      {this.id,
        this.title,
        this.description,
        this.tergat,
        this.type,
        this.readAt,
        this.status,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.zoneId});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    tergat = json['tergat'];
    type = json['type'];
    readAt = json['read_at'];
    status = json['status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    zoneId = json['zone_id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['tergat'] = tergat;
    data['type'] = type;
    data['read_at'] = readAt;
    data['status'] = status;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['zone_id'] = zoneId;
    return data;
  }
}