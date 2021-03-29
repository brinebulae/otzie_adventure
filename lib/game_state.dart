import 'room.dart';
import 'room_data.dart';
import 'item_data.dart';
import 'constants.dart';

class GameState {
  RoomData roomData = RoomData();
  ItemData itemData = ItemData();

  int currentRoomNumber;
  Room currentRoom;

  // TODO: change this back to brief after dev/test
  DescriptionMode descriptionMode = DescriptionMode.verbose;

  int score = 0;
  int moves = 1;
  int carryWeight = 0;
  int playerHealth = kMaxHealth;

  String lastParsedCommand = '';

  void setLongDescription(int theRoomNumber, String newText) {
    Room r = roomData.getRoomFromNumber(theRoomNumber);
    r.setLongDescription(newText);
  }

  String getLongDescription() {
    Room r = roomData.getRoomFromNumber(currentRoomNumber);
    return (r.longDescription);
  }

  void printGameState() {
    print('currentRoomNumber=$currentRoomNumber');
    print('descriptionMode=$descriptionMode');
    print('score=$score');
    print('moves=$moves');
    print('carryWeight=$carryWeight');
    print('playerHealth=$playerHealth');
    print('lastParsedCommand=$lastParsedCommand');
    print('roomData=');
    roomData.printRoomData();
    print('itemData=');
    itemData.printItemData();
  }

  GameState copy() {
    GameState newGameState = GameState();
    newGameState.roomData = roomData.copy();
    newGameState.itemData = itemData.copy();
    newGameState.currentRoomNumber = currentRoomNumber;
    newGameState.currentRoom = currentRoom;
    newGameState.descriptionMode = descriptionMode;
    newGameState.score = score;
    newGameState.moves = moves;
    newGameState.carryWeight = carryWeight;
    newGameState.playerHealth = playerHealth;
    newGameState.lastParsedCommand = lastParsedCommand;

    return newGameState;
  }

  void changeScore(int scoreChange) {
    score += scoreChange;
  }
}
