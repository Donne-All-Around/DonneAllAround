import 'package:intl/intl.dart';

class ChatsDto {
  final String sendBy;
  final String message;
  final String? imgUrl;
  final String time;
  final String ts;
  final String type;

  ChatsDto({
    required this.sendBy,
    required this.message,
    required this.imgUrl,
    required this.time,
    required this.ts,
    required this.type,
  });

  factory ChatsDto.fromJson(Map<String, dynamic> json) {
    return ChatsDto(
      sendBy: json["sendBy"],
      message: json["message"],
      imgUrl: json["imgUrl"],
      time: json["time"],
      ts: json["ts"],
      type: json["type"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sendBy" : sendBy,
      "message" : message,
      "imgUrl" : imgUrl,
      "time" : time,
      "ts" : ts,
      "type" : type,
    };
  }

}