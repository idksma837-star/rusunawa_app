class Room {
  final int id, floor, price;
  final String roomNumber, status;
  final String? buildingName;
  Room({required this.id, required this.floor, required this.price,
      required this.roomNumber, required this.status, this.buildingName});

  factory Room.fromJson(Map<String, dynamic> j) => Room(
        id: j['id'],
        floor: j['floor'],
        price: j['price'],
        roomNumber: j['room_number'],
        status: j['status'],
        buildingName: j['building']?['name'],
      );
}