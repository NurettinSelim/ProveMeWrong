import 'package:hive/hive.dart';
part 'message_adapter.g.dart';

@HiveType(typeId: 0)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String roomId;

  @HiveField(2)
  final String senderId;

  @HiveField(3)
  final String message;

  @HiveField(4)
  final int timestamp;

  ChatMessage({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.message,
    required this.timestamp,
  });
}

@HiveType(typeId: 1)
class RoomMetadata extends HiveObject {
  @HiveField(0)
  final String roomId;

  @HiveField(1)
  int lastSyncTimeStamp;

  @HiveField(2)
  int messageCount;

  RoomMetadata({
    required this.roomId,
    required this.lastSyncTimeStamp,
    this.messageCount = 0,
  });
}
