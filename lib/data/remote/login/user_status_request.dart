class UserStatusRequest {
  String? name;
  String? deviceType;
  String? deviceID;

  UserStatusRequest({
    this.name,
    this.deviceType,
    this.deviceID,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'device_id': deviceID,
      'device_type': deviceType,
    };
  }
}
