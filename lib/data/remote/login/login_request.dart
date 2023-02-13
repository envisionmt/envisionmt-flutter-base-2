class LoginRequest {
  String? name;
  String? deviceType;
  String? deviceToken;
  String? deviceID;
  String? timezone;

  LoginRequest({this.name, this.deviceType, this.deviceToken, this.deviceID, this.timezone});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'device_type': deviceType,
      'device_id': deviceID,
      'device_token': deviceToken,
      'timezone': timezone,
    };
  }
}