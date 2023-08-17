class AboutModel {
  final String aboutText;
  dynamic amount;
  AboutModel({required this.aboutText});
  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(aboutText: json['about']);
  }
}

class NotifModel {
  final String notifText;
  NotifModel({required this.notifText});
  factory NotifModel.fromJson(Map<String, dynamic> json) {
    return NotifModel(notifText: json['not']);
  }
}
