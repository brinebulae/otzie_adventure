import 'item_data.dart';
import 'constants.dart';

class Dictionary {
  Map<String, int> wordMap = {
    'northwest': Directions.northwest.index,
    'nw': Directions.northwest.index,
    'north': Directions.north.index,
    'n': Directions.north.index,
    'northeast': Directions.northeast.index,
    'ne': Directions.northeast.index,
    'west': Directions.west.index,
    'w': Directions.west.index,
    'east': Directions.east.index,
    'e': Directions.east.index,
    'southwest': Directions.southwest.index,
    'sw': Directions.southwest.index,
    'south': Directions.south.index,
    's': Directions.south.index,
    'southeast': Directions.southeast.index,
    'se': Directions.southeast.index,
    'down': Directions.down.index,
    'd': Directions.down.index,
    'up': Directions.up.index,
    'u': Directions.up.index,
    /////////////////
    'get': kTakeCommand,
    'take': kTakeCommand,
    'pick up': kTakeCommand,
    'get all': kTakeAllCommand,
    'take all': kTakeAllCommand,
    'pick up all': kTakeAllCommand,
    'drop': kDropCommand,
    'put down': kDropCommand,
    'drop all': kDropAllCommand,
    'put down all': kDropAllCommand,
    'insert all': kInsertAllCommand,
    'put all': kInsertAllCommand,
    'inventory': kInventoryCommand,
    'inven': kInventoryCommand,
    'inv': kInventoryCommand,
    'i': kInventoryCommand,
    'quit': kQuitCommand,
    'q': kQuitCommand,
    'goodbye': kQuitCommand,
    'save': kSaveCommand,
    'restore': kRestoreCommand,
    'undo': kUndoCommand,
    'wait': kWaitCommand,
    'z': kWaitCommand,
    'look': kLookCommand,
    'l': kLookCommand,
    'look at': kExamineCommand,
    'examine': kExamineCommand,
    'x': kExamineCommand,
    'eat': kEatCommand,
    'drink': kDrinkCommand,
    'bite': kBiteCommand,
    'go': kDirectionCommand,
    'walk': kDirectionCommand,
    'verbose': kVerboseCommand,
    'brief': kBriefCommand,
    'superbrief': kSuperbriefCommand,
    'restart': kRestartCommand,
    'help': kHelpCommand,
    'yes': kYesCommand,
    'y': kYesCommand,
    'no': kNoCommand,
    'oops': kOopsCommand,
    'o': kOopsCommand,
    'read': kReadCommand,
    'move': kMoveCommand,
    'score': kScoreCommand,
    'info': kInfoCommand,
    'damn': kCussCommand,
    'fuck': kCussCommand,
    'shit': kCussCommand,
    'again': kAgainCommand,
    'g': kAgainCommand,
    'time': kTimeCommand,
    'diagnose': kDiagnoseCommand,
    'open': kOpenCommand,
    'close': kCloseCommand,
    'hello': kHelloCommand,
    'hi': kHelloCommand,
    'jump': kJumpCommand,
    'shout': kShoutCommand,
    'yell': kShoutCommand,
    'pray': kPrayCommand,
    'turn on': kTurnOnCommand,
    'light': kTurnOnCommand,
    'turn off': kTurnOffCommand,
    'extinguish': kTurnOffCommand,
    'geronimo': kGeronimoCommand,
    'ulysses': kUlyssesCommand,
    'odysseus': kUlyssesCommand,
    'hello sailor': kHelloSailorCommand,
    'hello aviator': kHelloAviatorCommand,
    'xyzzy': kXyzzyCommand,
    'knock at': kKnockCommand,
    'knock on': kKnockCommand,
    'knock': kKnockCommand,
    'lock': kLockCommand,
    'unlock': kUnlockCommand,
    'climb': kClimbUpCommand,
    'climb up': kClimbUpCommand,
    'climb down': kClimbDownCommand,
    'pour': kPourCommand,
    'bogus': kBogusCommand,
    'insert': kInsertCommand,
    'put': kInsertCommand,
    ////////////////
    'at': kAtObject,
    'all': kAllObject,
    'in': kInObject,
    'from': kFromObject,
  };

  Dictionary() {
    ItemData itemData = ItemData();
    // add all manipulable game objects to our dictionary
    wordMap.addAll(itemData.getItemWords());
    // print('wordMap: $wordMap');
  }
}
