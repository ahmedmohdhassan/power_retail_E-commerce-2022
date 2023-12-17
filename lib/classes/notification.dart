class NotificationModel {
  NotificationModel({
    this.title,
    this.message,
  });

  String? title;
  String? message;

  static NotificationModel fromJson(Map<String, String> json) =>
      NotificationModel(
        title: json['title'],
        message: json['message'],
      );

  Map<String, String> toJson() => {
        'title': title!,
        'message': message!,
      };
}
