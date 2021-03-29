class Room {
  int roomNumber;
  String roomName;
  String shortDescription;
  String longDescription;
  String longDescription1;
  String longDescription2;
  String background; // will indicate corresponding background image to use
  int visitBonus;
  bool hasBeenVisited = false;
  bool dark = false;

  // array of 10 adjacent rooms in this order: NW, N, NE, W, E, SW, S, SE, UP, DOWN
  List<int> adjacentRooms;

  Room({
    this.background = 'background',
    this.roomNumber,
    this.roomName,
    this.shortDescription,
    this.longDescription,
    this.longDescription1 = '',
    this.longDescription2 = '',
    this.adjacentRooms,
    this.hasBeenVisited = false,
    this.dark = false,
    this.visitBonus = 0,
  });

  Room copy() {
    Room copiedRoom = Room();
    copiedRoom.background = background;
    copiedRoom.roomNumber = roomNumber;
    copiedRoom.roomName = roomName;
    copiedRoom.shortDescription = shortDescription;
    copiedRoom.longDescription = longDescription;
    copiedRoom.longDescription1 = longDescription2;
    copiedRoom.longDescription2 = longDescription2;
    copiedRoom.adjacentRooms = adjacentRooms;
    copiedRoom.hasBeenVisited = hasBeenVisited;
    copiedRoom.dark = dark;
    copiedRoom.visitBonus = visitBonus;

    return copiedRoom;
  }

  void setLongDescription(String newLongDescription) {
    longDescription = newLongDescription;
  }

  int getVisitBonus() {
    // mark room as visited and return bonus points for first visiting
    if (hasBeenVisited == true) {
      return 0;
    } else {
      // hasBeenVisited = true;
      return visitBonus;
    }
  }

  void printRoom() {
    print('Background: $background');
    print('Room Number: $roomNumber');
    print('Room Name: $roomNumber');
    print('Short: $shortDescription');
    print('Long: $longDescription');
    print('Adjacent: $adjacentRooms');
  }
}
