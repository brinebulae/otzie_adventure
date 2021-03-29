import 'constants.dart';

import 'room.dart';

class RoomData {
  int startingRoom = kRoomOffset;
  // adjacentRooms are given in this order: [NW, N, NE, W, E, SW, S, SE, D, U]

  List<Room> roomList = [
    Room(
        roomNumber: krWestOfHouse,
        background: 'house',
        shortDescription: 'West of House',
        longDescription:
            'This is an open field west of a white house, with a boarded front door.',
        adjacentRooms: [
          krX,
          krNorthOfHouse,
          krX,
          krForest1,
          -krLivingRoom,
          krX,
          krSouthOfHouse,
          krX,
          krX,
          krX
        ]),
    Room(
        roomNumber: krNorthOfHouse,
        background: 'house',
        shortDescription: 'North of House',
        longDescription:
            'You are facing the north side of a white house. There is no door here, and all the windows are barred.',
        adjacentRooms: [
          krX,
          krForest4,
          krX,
          krWestOfHouse,
          krBehindHouse,
          krX,
          krWindow,
          krX,
          krX,
          krX
        ]),
    Room(
        roomNumber: krBehindHouse,
        background: 'house',
        shortDescription: 'Behind House',
        longDescription:
            'You are behind the white house. In one corner of the house there is a small window which is slightly ajar.',
        longDescription1:
            'You are behind the white house. In one corner of the house there is a small window which is slightly ajar.',
        longDescription2:
            'You are behind the white house. In one corner of the house there is a small window which is open.',
        adjacentRooms: [
          krX,
          krNorthOfHouse,
          krX,
          -krKitchen,
          krClearing,
          krX,
          krSouthOfHouse,
          krX,
          krX,
          krX
        ]),
    Room(
        roomNumber: krSouthOfHouse,
        background: 'house',
        shortDescription: 'South of House',
        longDescription:
            'You are facing the south side of a white house. There is no door here, and all the windows are barred.',
        adjacentRooms: [
          krX,
          krWindow,
          krX,
          krWestOfHouse,
          krBehindHouse,
          krX,
          krForest3,
          krX,
          krX,
          krX
        ]),
    Room(
        roomNumber: krUpATree,
        background: 'forest',
        shortDescription: 'Up a Tree',
        longDescription:
            'You are about 10 feet above the ground nestled among some large branches. The nearest branch above you is above your reach.',
        adjacentRooms: [
          krX,
          krX,
          krX,
          krX,
          krX,
          krX,
          krX,
          krX,
          krForest4,
          krX
        ]),
    Room(
        roomNumber: krClearing,
        background: 'forest',
        shortDescription: 'Clearing',
        longDescription:
            'You are in a clearing, with a forest surrounding you on the west and south.',
        adjacentRooms: [
          krX,
          krClearing,
          krX,
          krForest4,
          krClearing,
          krBehindHouse,
          krForest3,
          krForest2,
          krX,
          krX
        ]),
    Room(
        roomNumber: krCanyonView,
        background: 'canyon',
        shortDescription: 'Canyon View',
        longDescription:
            'You are at the top of the Great Canyon on its south wall. '
            'From here there is a marvelous view of the Canyon and parts of the Frigid River '
            'upstream. Across the canyon, the walls of the White Cliffs still appear to loom '
            'far above. Following the Canyon upstream (north and northwest), Aragain Falls may be '
            'seen, complete with rainbow. Fortunately, my vision is better than average '
            'and I can discern the top of the Flood Control Dam #3 far to the distant north. '
            'To the west and south can be seen an immense forest, stretching for miles '
            'around. It is possible to climb down into the canyon from here.',
        adjacentRooms: [
          krX,
          krX,
          krX,
          krForest2,
          krX,
          krX,
          krForest5,
          krX,
          krRockyLedge,
          krX
        ]),
    Room(
        roomNumber: krForest1,
        background: 'forest',
        shortDescription: 'Forest #1',
        longDescription:
            'This is a forest, with trees in all directions around you.',
        adjacentRooms: [
          krX,
          krForest1,
          krX,
          krForest1,
          krForest4,
          krX,
          krForest3,
          krX,
          krX,
          krX
        ]),
    Room(
        roomNumber: krForest2,
        background: 'forest',
        shortDescription: 'Forest #2',
        longDescription:
            'This is a forest, with trees in all directions around you.',
        adjacentRooms: [
          krX,
          krForest2,
          krX,
          krForest3,
          krX,
          krX,
          krForest5,
          krCanyonView,
          krX,
          krX
        ]),
    Room(
        roomNumber: krForest3,
        background: 'forest',
        shortDescription: 'Forest #3',
        longDescription:
            'This is a dimly lit forest, with large trees all around. To the east, there appears to be sunlight.',
        adjacentRooms: [
          krX,
          krSouthOfHouse,
          krX,
          krForest1,
          krClearing,
          krX,
          krForest5,
          krX,
          krX,
          krX
        ]),
    Room(
        roomNumber: krForest4,
        background: 'forest',
        shortDescription: 'Forest #4',
        longDescription:
            'This is a dimly lit forest, with large trees all around. One particularly large tree with some low branches stands here.',
        adjacentRooms: [
          krX,
          krForest3,
          krX,
          krNorthOfHouse,
          krClearing,
          krX,
          krClearing,
          krX,
          krX,
          krUpATree
        ]),
    Room(
        roomNumber: krForest5,
        background: 'forest',
        shortDescription: 'Forest #5',
        longDescription:
            'This is a large forest, with trees obstructing all views except to the east, where a small clearing may be seen through the trees.',
        adjacentRooms: [
          krX,
          krForest2,
          krX,
          krForest3,
          krCanyonView,
          krX,
          krForest5,
          krX,
          krX,
          krX
        ]),
    Room(
        roomNumber: krRockyLedge,
        background: 'canyon',
        shortDescription: 'Rocky Ledge',
        longDescription:
            'You are on a ledge about halfway up the wall of the river canyon. '
            'You can see from here that the main flow from Aragain Falls '
            'twists along a passage which it is impossible to enter.  '
            'Below you is the canyon bottom.  Above you is more cliff, '
            'which still appears climbable.',
        adjacentRooms: [
          krX,
          krX,
          krX,
          krX,
          krX,
          krX,
          krX,
          krX,
          krCanyonBottom,
          krCanyonView
        ]),
    Room(
        roomNumber: krCanyonBottom,
        background: 'canyon',
        shortDescription: 'Canyon Bottom',
        longDescription:
            'You are beneath the walls of the river canyon which may be climbable here.  '
            'There is a small stream here, which is the lesser part of the runoff '
            'of Aragain Falls. To the north is a narrow path.',
        adjacentRooms: [
          krX,
          krEndOfRainbow,
          krX,
          krX,
          krX,
          krX,
          krX,
          krX,
          krX,
          krRockyLedge
        ]),
    Room(
        roomNumber: krEndOfRainbow,
        background: 'background',
        shortDescription: 'End of Rainbow',
        longDescription:
            'You are on a small, rocky beach on the continuation of the Frigid '
            'River past the Falls.  The beach is narrow due to the presence '
            'of the White Cliffs.  The river canyon opens here and sunlight '
            'shines in from above. A rainbow crosses over the falls to the '
            'west and a narrow path continues to the southeast.',
        adjacentRooms: [
          krX,
          krX,
          krX,
          krX,
          krX,
          krX,
          krX,
          krCanyonBottom,
          krX,
          krX
        ]),
    Room(
        roomNumber: krLivingRoom,
        background: 'house',
        shortDescription: 'Living Room',
        longDescription: 'You are in the living room.  There is a door to the '
            'east, a wooden door with strange gothic lettering to the west, '
            'which appears to be nailed shut, and a large oriental rug '
            'in the center of the room.',
        longDescription1:
            'You are in the living room.  There is a door to the east, '
            'a wooden door with strange gothic lettering to the west, '
            'which appears to be nailed shut, '
            'and a closed trap-door at your feet.',
        longDescription2:
            'You are in the living room.  There is a door to the east, '
            'a wooden door with strange gothic lettering to the west, '
            'which appears to be nailed shut, '
            'and a rug lying beside an open trap-door.',
        adjacentRooms: [
          krWall,
          krWall,
          krWall,
          -krWestOfHouse,
          krKitchen,
          krWall,
          krWall,
          krWall,
          -krCellar,
          krCeiling
        ]),
    Room(
        roomNumber: krKitchen,
        background: 'house',
        shortDescription: 'Kitchen',
        longDescription: 'You are in the kitchen of the white house.  '
            'A table seems to have been used recently for the preparation '
            'of food.  A passage leads to the west and a dark staircase '
            'can be seen leading upward.  To the east is a small window '
            'which is slightly ajar.',
        longDescription1: 'You are in the kitchen of the white house.  '
            'A table seems to have been used recently for the preparation '
            'of food.  A passage leads to the west and a dark staircase '
            'can be seen leading upward.  To the east is a small window '
            'which is slightly ajar.',
        longDescription2: 'You are in the kitchen of the white house.  '
            'A table seems to have been used recently for the preparation '
            'of food.  A passage leads to the west and a dark staircase '
            'can be seen leading upward.  To the east is a small window '
            'which is open.',
        visitBonus: 10,
        adjacentRooms: [
          krWall,
          krWall,
          krWall,
          krLivingRoom,
          -krBehindHouse,
          krWall,
          krWall,
          krWall,
          krX,
          krAttic
        ]),
    Room(
        roomNumber: krAttic,
        background: 'house',
        shortDescription: 'Attic',
        longDescription:
            'This is the attic. The only exit is stairs that lead down.',
        dark: true,
        adjacentRooms: [
          krWall,
          krWall,
          krWall,
          krWall,
          krWall,
          krWall,
          krWall,
          krWall,
          krKitchen,
          krCeiling
        ]),
    Room(
        roomNumber: krCellar,
        background: 'house',
        shortDescription: 'Cellar',
        longDescription:
            'You are in a dark and damp cellar with a narrow passageway leading east, and a crawlway to the south.  On the west is the bottom of a steep metal ramp which is unclimbable.',
        visitBonus: 25,
        dark: true,
        adjacentRooms: [
          krWall,
          krWall,
          krWall,
          krRamp,
          krWall,
          krWall,
          krWall,
          krWall,
          krX,
          -krLivingRoom,
        ]),
  ];

  void printRoomData() {
    for (Room r in roomList) {
      r.printRoom();
    }
  }

  Room getRoomFromNumber(int theRoomNumber) {
    for (Room r in roomList) {
      if (r.roomNumber == theRoomNumber) {
        return r;
      }
    }
    return null;
  }

  void toggleHiddenExit(int theRoomNumber, Directions roomDirection) {
    Room r = getRoomFromNumber(theRoomNumber);
    assert(r != null, 'Cannot toggle hidden exit in NULL room!');
    r.adjacentRooms[roomDirection.index] *= -1;
    // toggle between longDescription1 and longDescription2, if they exist
    if (r.longDescription == r.longDescription1 && r.longDescription2 != '') {
      r.longDescription = r.longDescription2;
    } else if (r.longDescription1 != '') {
      r.longDescription = r.longDescription1;
    }
  }

  RoomData copy() {
    RoomData copiedRoomData = RoomData();
    copiedRoomData.startingRoom = startingRoom;
    copiedRoomData.roomList = [];
    for (Room r in roomList) {
      copiedRoomData.roomList.add(r.copy());
    }
    return copiedRoomData;
  }
}
