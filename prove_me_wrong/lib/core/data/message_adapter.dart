import 'package:hive/hive.dart';
part 'message_adapter.g.dart';

@HiveType(typeId: 1)
class Message {
  @HiveField(0)
  final String senderId;

  @HiveField(1)
  final DateTime timeStamp;

  @HiveField(2)
  final String message;

  Message({
    required this.senderId,
    required this.message,
    required this.timeStamp,
  });
}
