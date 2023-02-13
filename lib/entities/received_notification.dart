class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    this.title,
    this.body,
    this.payload,
  });

  int id;
  String? title;
  String? body;
  String? payload;
}