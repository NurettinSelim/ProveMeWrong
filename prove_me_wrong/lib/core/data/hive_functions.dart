import 'package:prove_me_wrong/core/data/message_adapter.dart';
import 'package:hive/hive.dart';
import 'package:firebase_database/firebase_database.dart';

//box where messages from roomId is stored
Future<Box<ChatMessage>> getRoom(String roomId) async {
  if (!Hive.isBoxOpen('room_$roomId')) {
    return await Hive.openBox<ChatMessage>('room_$roomId');
  } else {
    return Hive.box<ChatMessage>('room_$roomId');
  }
}

// the box of rooms
Future<Box<RoomMetadata>> getRoomData() async {
  if (!Hive.isBoxOpen('room_data')) {
    return await Hive.openBox<RoomMetadata>('room_data');
  } else {
    return Hive.box<RoomMetadata>('room_data');
  }
}

Future syncNewData(String roomId, int lastSync) async {
  final snapshot = await FirebaseDatabase.instance
      .ref('rooms/$roomId/messages')
      .orderByChild('timeStamp')
      .startAt(lastSync + 1)
      .get();

  if (snapshot.exists) {
    final currentRoom = await getRoom(roomId);
    final roomBox = await getRoomData();

    final roomData = roomBox.get(roomId);

    final data = snapshot.value as Map<dynamic, dynamic>;
    for (var messageId in data.entries) {
      final entry =
          messageId.value
              as Map<
                dynamic,
                dynamic
              >; // messageId'nin içindeki timestmap, senderid, messages map'lendi
      final hiveMessage = ChatMessage(
        id: messageId.key,
        roomId: roomId,
        senderId: entry['senderId'],
        message: entry['message'],
        timestamp: entry['timeStamp'],
      );

      await currentRoom.put(messageId.key, hiveMessage);
      if (hiveMessage.timestamp > lastSync) {
        lastSync = hiveMessage.timestamp;
      }
    }

    roomData!.lastSyncTimeStamp = lastSync;
    roomData.messageCount = currentRoom.length;
    await roomData.save();
  }
}

Future<void> closeRoom(String roomId) async {
  if (Hive.isBoxOpen('room_$roomId')) {
    await Hive.box<ChatMessage>('room_$roomId').close();
  }
}
