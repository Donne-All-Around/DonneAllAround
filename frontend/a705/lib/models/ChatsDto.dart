import 'package:intl/intl.dart';

class ChatsDto {
  final int id;
  final int chatRoomId;
  final int sendBy;
  final String message;
  final int isRead;
  final String imgUrl;
  final String time;
  final String ts;

  ChatsDto({
  required this.id,
  required  this.chatRoomId,
  required  this.sendBy,
  required  this.message,
  required  this.isRead,
  required  this.imgUrl,
  required  this.time,
  required  this.ts,
});

  // factory ChatsDto.fromJson(Map<String, dynamic> json) {
  //   List<ChatsDto> chats
  //
  //
  //   return ChatsDto(
  //     id: json['id'],
  //     chatRoomId: json['chatRoomId'],
  //
  //   )
  // }



}