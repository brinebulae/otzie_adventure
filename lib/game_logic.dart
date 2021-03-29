import 'package:flutter/foundation.dart';

import 'game_state.dart';
import 'room.dart';
import 'item.dart';
import 'constants.dart';
import 'parser.dart';
import 'dart:math';

// a comment
class GameLogic {
  GameState gameState;
  GameState gameStateSaved;
  GameState gameStateAutoSavedOdd;
  GameState gameStateAutoSavedEven;

  int timesAutoSaved = 0;

  Item lastObjectFound;

  String lastObjectlessCommand = '';

  Parser parser = Parser();
  List<int> tokens = kEmptyInput;

  String statusMessage = '';
  bool userQuit = false;
  bool lookCommandGiven = false;
  bool restartConfirmationNeeded = false;
  bool quitConfirmationNeeded = false;
  bool objectNeeded = false;
  bool processingAgainCommand = false;
  bool gameHasBeenPreviouslySaved = false;
  bool lastCommandWasUndo = false;

  int verbToken, objectToken, directObjectToken, wordFourToken;
  String verbString = '',
      objectString = '',
      directObjectString = '',
      wordFourString = '';
  String preStatus = '';

  GameLogic() {
    restart();
  }

  void restart() {
    print('restarting...');

    gameState = GameState();

    gameState.currentRoomNumber = gameState.roomData.startingRoom;
    gameState.currentRoom =
        gameState.roomData.roomList[gameState.currentRoomNumber - kRoomOffset];

    lookCommandGiven = false;
    userQuit = false;
    objectNeeded = false;
    processingAgainCommand = false;

    preStatus = '';
    setStatus('Welcome to ZORK.\n$releaseInfo');

    // add up weight of all items you are initially carrying
    for (Item i in gameState.itemData.itemList) {
      if (i.carrying == true) {
        gameState.carryWeight += i.weight;
      }
    }
    timesAutoSaved = 0;
    autoSaveGame();
  }

  // Getters used by UI
  String getBackgroundImage() {
    return gameState.currentRoom.background;
  }

  String getScoreAndMoves() {
    return 'Score: ${gameState.score}    Moves: ${gameState.moves}';
  }

  String getShortDescription() {
    if (roomIsLit()) {
      return gameState.currentRoom.shortDescription + '\n';
    } else {
      return 'Darkness';
    }
  }

  String getLongDescription() {
    // check which mode we're in to see if a long description is applicable
    if (roomIsLit()) {
      if (lookCommandGiven == true ||
          (gameState.descriptionMode == DescriptionMode.verbose) ||
          (gameState.currentRoom.hasBeenVisited == false &&
              gameState.descriptionMode == DescriptionMode.brief)) {
        gameState.currentRoom.hasBeenVisited = true;
        return (gameState.getLongDescription());
      }
      return '';
    } else {
      return ('It is pitch black. You are likely to be eaten by a grue.');
    }
  }

  String checkEmptyHanded() {
    for (Item i in gameState.itemData.itemList) {
      if (i.carrying == true) {
        return 'You are carrying:';
      }
    }
    return 'You are empty handed.';
  }

  String describeInventory() {
    String inv = '';
    bool emptyHanded = true;

    for (Item i in gameState.itemData.itemList) {
      if (i.carrying == true) {
        emptyHanded = false;
        inv += '\nA ${i.shortName}';

        String itemsContainedInside = '';
        bool additionalItemSeen = false;
        for (Item j in getItemsInsideAnother(i)) {
          if (additionalItemSeen == false) {
            itemsContainedInside += ' a ${j.shortName}';
            additionalItemSeen = true;
          } else {
            itemsContainedInside += ', and a ${j.shortName}';
          }
        }

        if (itemsContainedInside != '') {
          inv += ' with' + itemsContainedInside;
        }
      }
    }
    if (emptyHanded) {
      return '';
    }

    return inv;
  }

  String getStatus() {
    return statusMessage;
  }

  String getRandomResponse(List<String> responses) {
    Random random = new Random();
    int r = random.nextInt(responses.length);
    setStatus(responses[r]);
    return (responses[r]);
  }

  // Setters
  void setStatus(String newStatus) {
    statusMessage = preStatus + newStatus;
    preStatus = '';
  }

  void setRandomStatus(List<String> newStatus) {
    statusMessage = getRandomResponse(newStatus);
  }

  // Primary User Input Interpreters
  void executeButton(Directions directionChoice, int buttonCommand) {
    // if we are waiting for a y/n confirmation of a previous command but a button is pressed,
    // then toss away previous command and accept button command

    // reset pending follow-up commands
    restartConfirmationNeeded = false;
    quitConfirmationNeeded = false;
    objectNeeded = false;
    lastCommandWasUndo = false;

    // if user has quit, only allow the Restart button
    if (userQuit == true) {
      if (buttonCommand != kRestartCommand) {
        return;
      }
    }

    if (directionChoice != null) {
      if (!isDirectionBlocked(directionChoice)) {
        goToRoom(direction: directionChoice);
        gameState.moves++;
        gameState.lastParsedCommand = describeEnum(directionChoice);
        autoSaveGame();
      }
    } else if (buttonCommand == kSaveCommand) {
      if (processSave() == kSuccessCode) {
        setStatus('Ok. [tbd]');
        gameState.lastParsedCommand = 'save';
      }
    } else if (buttonCommand == kRestartCommand) {
      if (userQuit == true) {
        // don't require confirmation if already in the Quit state
        restart();
      } else {
        restartConfirmationNeeded = true;
        setStatus('Are you sure you want to restart?');
      }
    } else if (buttonCommand == kTakeAllCommand) {
      processTakeAll();
      gameState.moves++;
      gameState.lastParsedCommand = 'take all';
      autoSaveGame();
    } else if (buttonCommand == kDropAllCommand) {
      processDropAll();
      gameState.moves++;
      gameState.lastParsedCommand = 'drop all';
      autoSaveGame();
    }
  }

  List<int> parseText(String userText) {
    List<int> tokens = parser.parseInput(userText);
    print('tokens: $tokens');
    verbToken = tokens[0];
    verbString = parser.userWords[0];
    objectToken = tokens[1];
    if (objectToken != kEmptyWord) {
      objectString = parser.userWords[1];
    }
    directObjectToken = tokens[2];
    if (directObjectToken != kEmptyWord) {
      directObjectString = parser.userWords[2];
    }
    wordFourToken = tokens[3];
    if (wordFourToken != kEmptyWord) {
      wordFourString = parser.userWords[3];
    }

    // SPECIAL CASES GO HERE: e.g. if multiple items have same name and need
    // disambiguation
    // 1. "door" could be in krWestOfHouse or krLivingRoom. Make sure they aren't mixed up
    if (objectToken == kiLivingRoomDoor &&
        gameState.currentRoomNumber == krWestOfHouse) {
      objectToken = kiHouseDoor;
    } else if (objectToken == kiHouseDoor &&
        gameState.currentRoomNumber == krLivingRoom) {
      objectToken = kiLivingRoomDoor;
    }

    return tokens;
  }

  int executeText(String userText) {
    setStatus('');

    // if user typed a verb but not a required object (e.g. 'EAT' instead of 'EAT PIE')
    // then objectNeeded == true. If so, we prompt the user to type just the object in
    // their next command. We prepend the verb to user's next typed input and parse
    // the combined text

    List<int> tokens = parseText(userText);

    // First, try to interpret the entire user command just given
    int theReturnCode = processCommand(userText, tokens);

    // If the command was not recognized, then maybe this is a continuation of
    // the previous command where a verb, but no an object was given.
    // If so, try again to interpret the two combined commands
    if (theReturnCode == kUnrecognizedCommand) {
      //  check if previous command had a missing object in case user
      // has supply just the object, i.e. not given a new complete command
      if (objectNeeded == true) {
        objectNeeded = false;
        userText = lastObjectlessCommand + ' ' + userText;
        print('user text: $userText');
        List<int> tokens = parseText(userText);
        theReturnCode = processCommand(userText, tokens);
      }
    }

    // We've now tried once, maybe twice, to interpret the command(s)
    if (theReturnCode == kUnrecognizedCommand) {
      setStatus('That\'s not a verb I recognise.');
      gameState.lastParsedCommand = userText;
      theReturnCode = kNotAMoveCode;
    }

    // command was successful, set gameState.lastParsedCommand
    if (theReturnCode == kSuccessCode || theReturnCode == kNotAMoveCode) {
      lastObjectlessCommand = '';

      if (userText != 'g' && userText != 'again' && userText != 'undo') {
        gameState.lastParsedCommand = userText;
        lastCommandWasUndo = false;

        if (theReturnCode == kSuccessCode) {
          autoSaveGame();
        }
        // print('setting lpc2 = $gameState.lastParsedCommand');
      }

      processingAgainCommand = false;
    }
    return theReturnCode;
  }

  int processCommand(String userText, List<int> tokens) {
    if (restartConfirmationNeeded) {
      verifyRestart();
      return (kNotAMoveCode);
    }
    if (quitConfirmationNeeded) {
      verifyQuit();
      return (kNotAMoveCode);
    }

    if (tokens == kEmptyInput) {
      setStatus('I beg your pardon?');
      if (objectNeeded == true) {
        return kErrorCode;
      }
      return (kErrorCode);
    }
    if (tokens == null || tokens == kEmptyInput || tokens == kUnknownVerb) {
      setStatus('That\'s not a verb I recognise.');
      return (kNotAMoveCode);
    }

    // To go to a new room, user can type 1 of 10 directions
    // (Northwest, North, Northeast, West, East, SouthWest, South, Southeast, Down, Up)
    // or they can use the verb "GO" or "WALK" and then give a direction
    if (verbToken >= Directions.northwest.index &&
        verbToken <= Directions.up.index) {
      goToRoom(direction: Directions.values[verbToken]);
      return (kSuccessCode);
    }

    //// First handle simple one-word commands that don't require an object:
    // They should all have a k-value < kSimpleCommandMax
    if (verbToken > 0 && verbToken < kSimpleCommandMax) {
      // TAKEALL and DROPALL don't need to check for spurious object
      if (verbToken == kTakeAllCommand) {
        return processTakeAll();
      } else if (verbToken == kDropAllCommand) {
        return processDropAll();
      } else if (verbToken == kInsertAllCommand) {
        return processInsertAllCommand();
      }

      // all other simple commands need to check for spurious object
      if (checkForSpuriousObject() != kSuccessCode) {
        return (kNotAMoveCode);
      }

      if (verbToken == kVerboseCommand) {
        gameState.descriptionMode = DescriptionMode.verbose;
        setStatus(
            'ZORK is now in its \"verbose\" mode, which always gives long '
            'descriptions of locations (even if you\'ve been there before).');
        return kNotAMoveCode;
      } else if (verbToken == kBriefCommand) {
        gameState.descriptionMode = DescriptionMode.brief;
        setStatus(
            'ZORK is now in its normal \"brief\" printing mode, which gives long '
            'descriptions of places never before visited and short descriptions otherwise.');
        return kNotAMoveCode;
      } else if (verbToken == kSuperbriefCommand) {
        gameState.descriptionMode = DescriptionMode.superbrief;
        setStatus(
            'ZORK is now in its \"superbrief\" mode, which always gives short '
            'descriptions of locations (even if you haven\'t been there before).');
        return kNotAMoveCode;
      } else if (verbToken == kOopsCommand) {
        setStatus('Sorry, that can\'t be corrected.');
        return kNotAMoveCode;
      } else if (verbToken == kWaitCommand) {
        setStatus('Time passes.');
      } else if (verbToken == kTimeCommand) {
        setStatus('You have been playing ZORK for longer than you think.');
        return kNotAMoveCode;
      } else if (verbToken == kDiagnoseCommand) {
        return processDiagnose();
      } else if (verbToken == kCussCommand) {
        setRandomStatus([
          'You ought to be ashamed of yourself.',
          'Such language in a high-class establishment like this.',
          'Oh, dear. Such language from a supposed winning adventurer!',
          'Tough shit, asshole',
          'It\'s not so bad. You could have been killed already.'
        ]);
      } else if (verbToken == kHelloSailorCommand) {
        setStatus('Nothing happens here.');
      } else if (verbToken == kHelloAviatorCommand) {
        setStatus('Here, nothing happens.');
      } else if (verbToken == kHelloCommand) {
        setRandomStatus([
          'Goodbye.',
          'Nice weather we\'ve been having lately.',
          'Good day.',
          'Hello.'
        ]);
      } else if (verbToken == kJumpCommand) {
        setRandomStatus([
          'Have you tried hopping around the dungeon, too?',
          'Do you expect me to applaud?',
          'Are you enjoying yourself?',
          'Wheeeeeeeeee!!!!!',
          'Very good.  Now you can go to the second grade.'
        ]);
      } else if (verbToken == kShoutCommand) {
        setStatus('Aaaarrrrrrrrgggggggggggggghhhhhhhhhhhhhh!');
      } else if (verbToken == kPrayCommand) {
        setStatus('If you pray enough, your prayers may be answered.');
      } else if (verbToken == kGeronimoCommand) {
        setStatus('Wasn\'t he an Indian?');
      } else if (verbToken == kUlyssesCommand) {
        setStatus('Wasn\'t he a sailor?');
      } else if (verbToken == kXyzzyCommand) {
        setStatus('A hollow voice says \'Cretin\'');
      } else if (verbToken == kScoreCommand) {
        setStatus(
            'Your score would be ${gameState.score} [total of $kTotalPossibleScore points], in ${gameState.moves} moves.'
            '\nThis score gives you a rank of ${getRank()}.');
      } else if (verbToken == kSaveCommand) {
        return processSave();
      } else if (verbToken == kRestoreCommand) {
        return processRestore();
      } else if (verbToken == kLookCommand) {
        lookCommandGiven = true;
        return kNotAMoveCode;
      } else if (verbToken == kAgainCommand) {
        return processAgain();
      } else if (verbToken == kQuitCommand) {
        return processQuit();
      } else if (verbToken == kRestartCommand) {
        return processRestart();
      } else if (verbToken == kHelpCommand) {
        return kHelpCommand;
      } else if (verbToken == kInventoryCommand) {
        return kInventoryCommand;
      } else if (verbToken == kInfoCommand) {
        return kInfoCommand;
      } else if (verbToken == kUndoCommand) {
        return processUndo();
      }
      // if we haven't already returned a different code then return SUCCESS
      return kSuccessCode;

      //// Next, two-word commands that do require an object
    } else if (verbToken > 0 && verbToken < kComplexCommandMax) {
      int checkObjectReturnCode = checkObject();
      if (checkObjectReturnCode != kSuccessCode) {
        return checkObjectReturnCode;
      }
      if (verbToken > kTakeFirstCommandMin) {
        if (takeFirst() != kSuccessCode) {
          setStatus('');
          return kErrorCode;
        }
      }

      if (verbToken == kDirectionCommand) {
        return processDirection(tokens);
      } else if (verbToken == kExamineCommand) {
        return processExamine();
      } else if (verbToken == kReadCommand) {
        return processRead();
      } else if (verbToken == kTakeCommand) {
        return processTake();
      } else if (verbToken == kDropCommand) {
        return processDrop();
      } else if (verbToken == kOpenCommand) {
        return processOpen();
      } else if (verbToken == kCloseCommand) {
        return processClose();
      } else if (verbToken == kTurnOnCommand) {
        return processTurnOn();
      } else if (verbToken == kTurnOffCommand) {
        return processTurnOff();
      } else if (verbToken == kKnockCommand) {
        return processKnock();
      } else if (verbToken == kLockCommand) {
        return processLock();
      } else if (verbToken == kUnlockCommand) {
        return processUnlock();
      } else if (verbToken == kClimbUpCommand) {
        return processClimbUp();
      } else if (verbToken == kClimbDownCommand) {
        return processClimbDown();
      } else if (verbToken == kMoveCommand) {
        return processMove();
      } else if (verbToken == kEatCommand) {
        return processEat();
      } else if (verbToken == kDrinkCommand) {
        return processDrink();
      } else if (verbToken == kPourCommand) {
        return processPour();
      } else if (verbToken == kInsertCommand) {
        return processInsert();
      }
    }

    // should not fall through - it means verb was recognized but no code for it!
    print('[error - unprocessed valid command!]');
    return (kUnrecognizedCommand);
  }

  // Game Configuration Commands
  int processAgain() {
    // do not apply AGAIN if last command was missing an object
    if (objectNeeded) {
      setStatus('You can\'t see any such thing.');
      objectNeeded = false;
      return (kSuccessCode);
    }

    processingAgainCommand = true;
    // TODO: match how ZORK handles AGAIN command after various bad commands at start of game
    if (gameState.lastParsedCommand == '' && gameState.moves <= 1) {
      setStatus('You can hardly repeat that.');
      return (kNotAMoveCode);
    }

    int againReturnCode = executeText(gameState.lastParsedCommand);
    return (againReturnCode);
  }

  int processDiagnose() {
    // TODO: use actual ZORK health code
    if (gameState.playerHealth == kMaxHealth) {
      setStatus(
          'You are in perfect health.\nYou can be killed by a serious wound.');
    }
    if (gameState.playerHealth < kMaxHealth * .5) {
      setStatus('You are in decent health.\nYou can be killed by a bad wound.');
    } else if (gameState.playerHealth < kMaxHealth * .25) {
      setStatus('You are in poor health.\nYou can be killed by a minor wound.');
    } else if (gameState.playerHealth < kMaxHealth * .10) {
      setStatus(
          'You are teetering close to death.\nYou can be killed by any minor wound.');
    }
    return (kSuccessCode);
  }

  int processSave() {
    gameStateSaved = gameState.copy();
    gameHasBeenPreviouslySaved = true;
    setStatus('Ok.');
    return (kNotAMoveCode);
  }

  void autoSaveGame() {
    if (timesAutoSaved++ % 2 == 0) {
      gameStateAutoSavedEven = gameState.copy();
      //gameStateAutoSavedEven.printGameState();
    } else {
      gameStateAutoSavedOdd = gameState.copy();
    }
  }

  int processRestore() {
    if (!gameHasBeenPreviouslySaved) {
      // make sure user has saved game at least once so far
      setStatus('Restore failed.');
      return (kNotAMoveCode);
    }
    gameState = gameStateSaved.copy();
    // autoSave an extra time here so user can UNDO the restore (!)
    autoSaveGame();
    setStatus('Ok.');
    return (kNotAMoveCode);
  }

  int processUndo() {
    // make sure we have autosaved game at least once so far
    if (timesAutoSaved <= 1) {
      setStatus('[You can\'t "undo" what hasn\'t been done!].');
      return (kNotAMoveCode);
    }

    if (lastCommandWasUndo == true) {
      setStatus('[Can\'t "undo" twice in succession. Sorry!].');
      return (kNotAMoveCode);
    }
    if (timesAutoSaved % 2 == 0) {
      gameState = gameStateAutoSavedEven.copy();
    } else {
      gameState = gameStateAutoSavedOdd.copy();
    }
    setStatus('[Previous turn undone.]');
    //TODO: is it necessary to autoSaveGame() twice here?
    autoSaveGame();
    autoSaveGame();
    lastCommandWasUndo = true;

    return (kNotAMoveCode);
  }

  int processRestart() {
    restartConfirmationNeeded = true;
    setStatus('Are you sure you want to restart?');
    return (kNotAMoveCode);
  }

  int processQuit() {
    quitConfirmationNeeded = true;
    setStatus('Are you sure you want to quit?');
    return (kNotAMoveCode);
  }

  // Interpreter Helper Methods
  int processDirection(List<int> tokens) {
    if (objectToken == kEmptyWord) {
      setStatus('You\'ll have to say which compass direction to go in.');
      return (kSuccessCode);
    }
    if (objectToken > Directions.up.index) {
      setStatus('That\'s not something you can enter.');
      return (kSuccessCode);
    }
    goToRoom(direction: Directions.values[objectToken]);
    return (kSuccessCode);
  }

  void confirmationNotGiven() {
    if (verbToken != kNoCommand && verbToken != Directions.north.index) {
      setStatus('Please answer yes or no.');
    } else {
      restartConfirmationNeeded = false;
      quitConfirmationNeeded = false;
    }
  }

  void verifyRestart() {
    assert(restartConfirmationNeeded);
    if (verbToken == kYesCommand) {
      restartConfirmationNeeded = false;
      gameState.lastParsedCommand = 'restart';
      restart();
      return;
    }
    confirmationNotGiven();
  }

  void verifyQuit() {
    assert(quitConfirmationNeeded);
    if (verbToken == kYesCommand) {
      quitConfirmationNeeded = false;
      gameState.lastParsedCommand = '';
      setStatus(
          'Your final score is ${gameState.score} in ${gameState.moves} moves.');
      userQuit = true; // this will disable text box and buttons
      return;
    }
    confirmationNotGiven();
  }

  bool roomIsLit() {
    if (gameState.currentRoom.dark == false) {
      return true;
    }
    // room is dark: check if there is a lit item in the room or your inventory
    for (Item i in gameState.itemData.itemList) {
      if ((i.carrying == true || i.location == gameState.currentRoomNumber) &&
          i.lit) {
        return true;
      }
    }
    return false;
  }

  int checkForSpuriousObject() {
    if (objectToken != kEmptyWord) {
      setStatus('I only understood you as far as wanting to $verbString.');
      return (kNotAMoveCode);
    }
    return (kSuccessCode);
  }

  // Complex (Two-Word) Commands
  int processClose() {
    // SOLUTION: BehindHouse/Kitchen: opening window for access!!
    if (lastObjectFound.openable == true && lastObjectFound.opened == false) {
      if (lastObjectFound.number == kiWindow) {
        getRandomResponse([
          'Look around.',
          'I think you\'ve already done that.',
          'You think it isn\'t?'
        ]);
      } else {
        setStatus('That\'s already closed.');
      }
    } else if (lastObjectFound.openable == true &&
        lastObjectFound.opened == true) {
      if (lastObjectFound.number == kiWindow &&
          (gameState.currentRoomNumber == krBehindHouse ||
              gameState.currentRoomNumber == krKitchen)) {
        setStatus('The window closes (more easily than it opened).');
        gameState.roomData.toggleHiddenExit(krBehindHouse, Directions.west);
        gameState.roomData.toggleHiddenExit(krKitchen, Directions.east);
        lookCommandGiven = true;
      } else {
        setStatus('You close the ${lastObjectFound.shortName}.');
      }
      lastObjectFound.opened = false;

      // SOLUTION: Living Room: opening trap-door reveals rickety staircase!!
      if (lastObjectFound.number == kiTrapDoor) {
        setStatus('The door swings shut and closes.');
        gameState.roomData.toggleHiddenExit(krLivingRoom, Directions.down);
        lookCommandGiven = true;
      }
    } else {
      setStatus('That\'s not something you can close.');
    }
    return (kSuccessCode);
  }

  int processOpen() {
    if (lastObjectFound.openable == true && lastObjectFound.opened == true) {
      // SOLUTION: BehindHouse/Kitchen: opening window for access!!
      if (lastObjectFound.number == kiWindow) {
        getRandomResponse([
          'Look around.',
          'I think you\'ve already done that.',
          'You think it isn\'t?'
        ]);
      } else {
        setStatus('That\'s already opened.');
      }
    } else if (lastObjectFound.openable == true &&
        lastObjectFound.locked == true) {
      setStatus('The ${lastObjectFound.shortName} is locked.');
    } else if (lastObjectFound.openable == true &&
        lastObjectFound.opened == false) {
      if (lastObjectFound.number == kiWindow) {
        setStatus(
            'With great effort, you open the window far enough to allow entry.');
        gameState.roomData.toggleHiddenExit(krBehindHouse, Directions.west);
        gameState.roomData.toggleHiddenExit(krKitchen, Directions.east);
        lookCommandGiven = true;
        lastObjectFound.opened = true;

        // SOLUTION: Living Room: opening trap-door reveals rickety staircase!!
      } else if (lastObjectFound.number == kiTrapDoor) {
        setStatus(
            'The door reluctantly opens to reveal a rickety staircase descending into darkness.');
        gameState.roomData.toggleHiddenExit(krLivingRoom, Directions.down);
        lookCommandGiven = true;
        lastObjectFound.opened = true;
      } else {
        setStatus(successfulOpen(lastObjectFound));
      }
    } else if (lastObjectFound.number == kiHouseDoor) {
      setStatus('The door cannot be opened.');
    } else {
      setStatus('That\'s not something you can open.');
    }
    return (kSuccessCode);
  }

  String successfulOpen(Item theItem) {
    String returnString = '';
    returnString += 'You open the ${theItem.shortName}';
    theItem.opened = true;

    if (theItem.container == false || theItem.transparent == true) {
      return returnString;
    }

    // get contents, if a non-transparent container
    String itemsContainedInside = '';
    bool objectAlreadyFound = false;
    for (Item j in getItemsInsideAnother(theItem)) {
      if (objectAlreadyFound == true) {
        itemsContainedInside += ',';
      }
      itemsContainedInside += ' a ${j.shortName}';
      objectAlreadyFound = true;
    }

    if (objectAlreadyFound == true) {
      returnString += ', revealing' + itemsContainedInside;
    }
    returnString = replaceLastSubstring(returnString, ', a', ' and a');
    return returnString + '.';
  }

  int takeFirst() {
    // TODO: need to handle READ specially. It doesn't try to take some things
    // first like HOUSE or DOOR
    preStatus = '';
    String takeResult;

    if (lastObjectFound.carrying == false) {
      takeResult = takeOneItem(lastObjectFound);
      preStatus = '(first taking the ${lastObjectFound.shortName})\n';
      if (takeResult != 'Taken.') {
        preStatus += '\n' + takeResult;
        return kErrorCode;
      }
    }
    return kSuccessCode;
  }

  int processEat() {
    if (lastObjectFound.edible == true) {
      setStatus('Yum yum.');
      lastObjectFound.location = -1;
    } else {
      setStatus('I don\'t think the $objectString would agree with you.');
    }
    return (kSuccessCode);
  }

  int processDrink() {
    if (lastObjectFound.carrying == false &&
        lastObjectFound.number != kiWater) {
      setStatus('I think you should get that first.');
    } else if (lastObjectFound.drinkable == true) {
      if (lastObjectFound.number == kiWater) {
        Item bottle = gameState.itemData.getItemFromNumber(kiBottle);
        if (bottle.opened == false || bottle.carrying == false) {
          setStatus('I\'d like to, but I can\'t get to it.');
        } else {
          setStatus(
              'Thank you very much.  I was rather thirsty (from all this talking, probably).');
          lastObjectFound.location = -1;
        }
      } else {
        // not kiWater
        // TODO: update this later if other things you can drink.
        setStatus('Ah, that is smooth as silk.');
        lastObjectFound.location = -1;
      }
    } else {
      // not drinkable
      setStatus('I don\'t think the $objectString would agree with you.');
    }
    return (kSuccessCode);
  }

  int processPour() {
    if (lastObjectFound.number == kiWater) {
      lastObjectFound.location = -1;
      setStatus('The water spills to the floor and evaporates immediately.');
    } else {
      // only water pourable for now
      setStatus('The $objectString is already here.');
    }
    return (kSuccessCode);
  }

  int processTurnOn() {
    if (lastObjectFound.lightable == true) {
      if (lastObjectFound.lit == false) {
        setStatus('The $objectString is now on.');
        lastObjectFound.lit = true;
      } else {
        setStatus('It is already on.');
      }
    } else {
      setStatus('You can\'t turn that on.');
    }
    return (kSuccessCode);
  }

  int processTurnOff() {
    if (lastObjectFound.lightable == true) {
      if (lastObjectFound.lit == true) {
        setStatus('The $objectString is now off.');
        lastObjectFound.lit = false;
      } else {
        setStatus('It is already off.');
      }
    } else {
      setStatus('You can\'t turn that off.');
    }
    return (kSuccessCode);
  }

  int processKnock() {
    if (lastObjectFound.knockable == true) {
      setStatus('I don\'t think anybody\'s home.');
    } else {
      setStatus('Why knock on a ${lastObjectFound.shortName}?');
    }
    return (kSuccessCode);
  }

  int processLock() {
    if (lastObjectFound.lockable == true) {
      // TODO: implement later
      setStatus(
          'What do you want to lock the ${lastObjectFound.shortName} with?');
    } else {
      setStatus(
          'What do you want to lock the ${lastObjectFound.shortName} with?');
    }
    return (kSuccessCode);
  }

  int processUnlock() {
    if (lastObjectFound.lockable == true) {
      // TODO: implement later
      setStatus(
          'What do you want to unlock the ${lastObjectFound.shortName} with?');
    } else {
      setStatus(
          'What do you want to unlock the ${lastObjectFound.shortName} with?');
    }
    return (kSuccessCode);
  }

  int processExamine() {
    // describe requested item - if it is here or in your possession
    if (lastObjectFound.examineName == '') {
      setStatus('I see nothing special about the ${lastObjectFound.shortName}');
    } else {
      setStatus('${lastObjectFound.examineName}');
    }
    return (kSuccessCode);
  }

  int processRead() {
    // describe requested item - if it is here or in your possession
    if (lastObjectFound.readable == false) {
      setStatus('How can I read a ${lastObjectFound.shortName}?');
    } else {
      setStatus('${lastObjectFound.examineName}');
    }
    return (kSuccessCode);
  }

  int processClimbUp() {
    // allow climbing up tree from krForest4 to krUpATree
    if (lastObjectFound.number == kiHouse) {
      setStatus('You can\'t go that way.');
    } else if (lastObjectFound.number != kiTree) {
      setStatus('Bizarre!');
    } else {
      if (gameState.currentRoomNumber == krUpATree) {
        setStatus('You cannot climb any higher.');
      } else {
        goToRoom(direction: Directions.up);
      }
    }
    return (kSuccessCode);
  }

  int processClimbDown() {
    // allow climbing down tree from krUpATree to krForest4
    if (lastObjectFound.number != kiTree) {
      setStatus('Bizarre!');
    } else {
      goToRoom(direction: Directions.down);
    }
    return (kSuccessCode);
  }

  int processMove() {
    // describe requested item - if it is here or in your possession
    if (lastObjectFound.takeable == false &&
        lastObjectFound.moveable == false) {
      setStatus('You can\'t move the $objectString.');
    } else if (lastObjectFound.carrying == true &&
        lastObjectFound.moveable == false) {
      setStatus('I can\'t get to that to move it.');
    } else if (lastObjectFound.moveable == false) {
      setStatus('Moving the $objectString reveals nothing.');
    } else {
      // SOLUTION: Clearing: moving leaves uncovers grate!!
      // TODO: refactor this and similar case in takeItem();
      Item grate = gameState.itemData.getItemFromNumber(kiGrate);
      if (objectToken == kiLeaves && grate.hidden == true) {
        grate.hidden = false;
        setStatus('Done.\nA grating appears on the ground.');
      } else if (objectToken == kiLeaves && grate.hidden == false) {
        setStatus('Done.');
      }
      // SOLUTION: Living Room: moving rug/carpet uncovers trap-door!!
      Item trapDoor = gameState.itemData.getItemFromNumber(kiTrapDoor);
      if (objectToken == kiCarpet && trapDoor.hidden == true) {
        trapDoor.hidden = false;
        setStatus(
            'With a great effort, the rug is moved to one side of the room.\n'
            'With the rug moved, the dusty cover of a closed trap-door appears.');
        gameState.setLongDescription(
            krLivingRoom,
            'You are in the living room.  There is a door to the east, a wooden door with strange gothic lettering to the west, '
            'which appears to be nailed shut, and a closed trap-door at your feet.');
      } else if (objectToken == kiCarpet && trapDoor.hidden == false) {
        setStatus(
            'Having moved the carpet previously, you find it impossible to move it again.');
      }
    }
    return (kSuccessCode);
  }

  int processDrop() {
    setStatus(dropOneItem(lastObjectFound));
    return (kSuccessCode);
  }

  int processTake() {
    setStatus(takeOneItem(lastObjectFound));
    return (kSuccessCode);
  }

  List<Item> getItemsInsideAnother(Item containingItem) {
    List<Item> itemsContainedInside = [];
    if (containingItem.container &&
        (containingItem.opened || containingItem.transparent)) {
      for (Item j in gameState.itemData.itemList) {
        if (j.carrying == false && j.location == containingItem.number) {
          itemsContainedInside.add(j);
        }
      }
    }
    return itemsContainedInside;
  }

  int checkObject({bool acceptsAllObject = false}) {
    // if the token does not represent a valid material object, return null,
    // else return the Item
    lastObjectFound = null;
    lastObjectlessCommand = '';
    if (objectToken == kEmptyWord) {
      // object word was not typed in, force user to type in the missing object word
      setStatus('What do you want to ${parser.userWords[0]}?');
      objectNeeded = true;
      lastObjectlessCommand = verbString;
      return kMissingObjectCode;
    }
    // user typed 'ALL' as object word, check if that is valid or not
    if (!acceptsAllObject && objectToken == kAllObject) {
      setStatus('You can\'t use multiple objects with that verb.');
      return kNotAMoveCode;
    }
    // user typed in an object word that is not in our list of valid items
    if (objectToken == kUnknownWord || objectToken < kObjectOffset) {
      setStatus('You can\'t see any such thing.');
      return kNotAMoveCode;
    }

    Item foundItem = gameState.itemData.getItemFromNumber(objectToken);

    if (foundItem == null || isItemAvailable(foundItem) == false) {
      setStatus('You can\'t see any such thing.');
      return kNotAMoveCode;
    }

    lastObjectFound = foundItem;
    return kSuccessCode;
  }

  bool isItemAvailable(Item i) {
    // an item is available if it is in the room OR in our inventory, BUT not
    // inside a container which is closed
    if (i.hidden == true) {
      return false;
    }

    if (i.carrying == false) {
      if (roomIsLit() == false) {
        return false;
      }
      // if it is not in this room AND not in a container, return false
      if (isItemLooseInRoom(i, gameState.currentRoomNumber) == false &&
          i.location < kObjectOffset) {
        return false;
      }
    }
    // if we got here, either we are carrying item OR it is in this (lit) room
    // OR it is contained within another object
    if (i.location >= kObjectOffset) {
      // is it in container?
      Item containingItem = gameState.itemData.getItemFromNumber(i.location);
      // SPECIAL CASE: code for WATER
      if (i.number == kiWater) {
        if (isItemAvailable(containingItem)) {
          return true;
        } else {
          return false;
        }
      }
      if (containingItem.container == false ||
          (containingItem.opened == false &&
              containingItem.transparent == false)) {
        return false;
      }
    }
    return true;
  }

  bool isItemLooseInRoom(Item i, int roomNumber) {
    if (i.carrying == true || i.hidden == true || roomIsLit() == false) {
      return false;
    }
    return (i.location == roomNumber ||
        i.location2 == roomNumber ||
        i.location3 == roomNumber ||
        i.location4 == roomNumber);
  }

  String describeGroundBelow() {
    // called if we are UpATree to describe items on ground below us
    String itemsAtCurrentLocation = '\nOn the ground below you can see: ';
    bool itemSeen = false;
    for (Item i in gameState.itemData.itemList) {
      if (isItemLooseInRoom(i, krForest4) && i.longName.length > 0) {
        if (itemSeen == true) {
          itemsAtCurrentLocation += ', ';
        }
        itemSeen = true;

        itemsAtCurrentLocation += 'a ${i.shortName}';
      }
    }
    if (itemSeen == true) {
      // insert the word 'and' if there are multiple items to list
      itemsAtCurrentLocation =
          replaceLastSubstring(itemsAtCurrentLocation, ',', ', and');
      return itemsAtCurrentLocation + '.';
    } else {
      return '';
    }
  }

  String replaceLastSubstring(String inString, String oldText, String newText) {
    int position = inString.lastIndexOf(oldText);
    if (position > 0) {
      inString =
          inString.replaceRange(position, position + oldText.length, newText);
    }
    return inString;
  }

  String describeLocalObjects() {
    String itemsAtCurrentLocation = '';
    // SPECIAL CASE: handle nest/egg - nothing else can be here because
    // it falls to ground if dropped
    if (gameState.currentRoomNumber == krUpATree) {
      print('handling special case for UpATree');
      Item nest = gameState.itemData.getItemFromNumber(kiNest);
      Item egg = gameState.itemData.getItemFromNumber(kiEgg);

      itemsAtCurrentLocation += describeGroundBelow();
      if (egg.previouslyTaken == false) {
        if (nest.carrying == false && nest.location == krUpATree) {
          itemsAtCurrentLocation +=
              '\n\n' + nest.longName + '\n' + nest.specialText;
          return itemsAtCurrentLocation;
        } else if (nest.carrying == true) {
          itemsAtCurrentLocation += '\n\n' + nest.specialText;
          return itemsAtCurrentLocation;
        }
      }
    }
    if (roomIsLit()) {
      for (Item i in gameState.itemData.itemList) {
        if (isItemLooseInRoom(i, gameState.currentRoomNumber) &&
            i.longName.length > 0) {
          if (i.previouslyTaken == true && i.longName2 != '') {
            itemsAtCurrentLocation += '\n\n${i.longName2}';
          } else {
            itemsAtCurrentLocation += '\n\n${i.longName}';
          }
          String itemsContainedInside = '';
          for (Item j in getItemsInsideAnother(i)) {
            itemsContainedInside += '\n A ${j.shortName} ';
          }

          if (itemsContainedInside != '') {
            if (i.number == kiTrophyCase) {
              itemsAtCurrentLocation +=
                  '\nYour collection of treasures consists of:' +
                      itemsContainedInside;
            } else {
              itemsAtCurrentLocation +=
                  '\nThe ${i.shortName} contains:' + itemsContainedInside;
            }
          }
        }
      }
    }
    return itemsAtCurrentLocation;
  }

  bool isDirectionBlocked(Directions direction) {
    if (direction == null) {
      return false;
    }

    if (gameState.currentRoom.adjacentRooms[direction.index] < 0) {
      return true;
    }
    return false;
  }

  String getNameOfRoom(int roomNumber) {
    for (Room r in gameState.roomData.roomList) {
      if (r.roomNumber == roomNumber) {
        return r.shortDescription;
      }
    }
    return 'Unknown Room';
  }

  int processDropAll() {
    String returnString;

    setStatus('');
    for (Item i in gameState.itemData.itemList) {
      // Some items should not be included in DROP ALL commands, like WATER
      if (i.number != kiWater) {
        returnString = dropOneItem(i);
        if (returnString != '') {
          setStatus(statusMessage + '\n' + i.shortName + ': ' + returnString);
        }
      }
    }
    if (statusMessage == '') {
      setStatus('What do you want to drop those things in?');
    }
    return kSuccessCode;
  }

  int processInsert() {
    String returnString;

    setStatus('');
    print('DEBUG: in processInsert');

    if (directObjectToken != kInObject) {
      setStatus('What do you want to $verbString the $objectString in?');
      return kSuccessCode;
    } else {
      if (wordFourToken == kEmptyWord) {
        setStatus('What do you want to $verbString those things in?');
        return kSuccessCode;
      }
    }

    Item object = gameState.itemData.getItemFromNumber(objectToken);
    Item receptacle = gameState.itemData.getItemFromNumber(wordFourToken);

    String returnCode = checkReceptacle(object, receptacle);
    if (returnCode != '') {
      setStatus(returnCode);
      return kSuccessCode;
    }

    returnString = insertOneItem(object, receptacle);
    if (returnString != '') {
      setStatus(returnString);
    }

    if (statusMessage == '') {
      setStatus('What do you want to ${parser.userWords[0]} those things in?');
    }
    return kSuccessCode;
  }

  int processInsertAllCommand() {
    String returnString;

    setStatus('');
    print('DEBUG: in processInsertAllCommand');

    if (objectToken != kInObject) {
      setStatus('What do you want to insert those things in?');
      return kSuccessCode;
    } else {
      if (directObjectToken == kEmptyWord) {
        setStatus(
            'What do you want to ${parser.userWords[0]} those things in?');
        return kSuccessCode;
      }
    }

    Item receptacle = gameState.itemData.getItemFromNumber(directObjectToken);
    String returnCode = checkReceptacle(null, receptacle);
    if (returnCode != '') {
      setStatus(returnCode);
      return kSuccessCode;
    }

    for (Item i in gameState.itemData.itemList) {
      // Some items should not be included in INSERT ALL commands, like WATER
      if (i.number != kiWater) {
        returnString = insertOneItem(i, receptacle);
        if (returnString != '') {
          setStatus(statusMessage + '\n' + i.shortName + ': ' + returnString);
        }
      }
    }
    if (statusMessage == '') {
      setStatus('What do you want to ${parser.userWords[0]} those things in?');
    }
    return kSuccessCode;
  }

  String checkReceptacle(Item object, Item receptacle) {
    print('DEBUG: in checkReceptacle');
    if (receptacle.carrying == false &&
        gameState.itemData.getTopmostLocationOfItem(receptacle) !=
            gameState.currentRoomNumber) {
      return ('You can\'t see any such thing.');
    }
    if (object != null && receptacle.number == object.number) {
      return ('I should recurse infinitely to teach you a lesson, but...');
    }
    if (receptacle.container == false) {
      return ('That can\'t contain things.');
    }
    if (receptacle.opened == false) {
      return ('The ${receptacle.shortName} is closed');
    }
    return '';
  }

  int processTakeAll() {
    String statusString = '';
    String returnString = '';

    for (Item i in gameState.itemData.itemList) {
      if (i.carrying == false &&
          i.available == true &&
          isItemLooseInRoom(i, gameState.currentRoomNumber) == true) {
        returnString = takeOneItem(i);
        statusString += '\n' + i.shortName + ': ' + returnString;
      }
    }

    if (statusString == '') {
      setStatus('I couldn\'t find anything.');
    } else {
      setStatus(statusString);
    }
    return kSuccessCode;
  }

  String insertOneItem(Item i, Item receptacle) {
    if (i.carrying == true) {
      if (i.size > receptacle.acceptingSize) {
        return 'It won\'t fit.';
      }
      i.carrying = false;
      gameState.carryWeight -= i.weight;
      i.location = receptacle.number;
      print(
          "Inserted ${i.shortName} (${i.weight}); gameState.carryWeight = ${gameState.carryWeight}");
      return 'Done.';
    } else {
      // SPECIAL CASE: DROP WATER acts like POUR WATER (it spills and evaporates)
      // if you are carrying bottle or even if bottle is in the room!
      if (i.number == kiWater) {
        i.location = -1;
        return 'The water leaks out of the [CONTAINER], and evaporates immediately.';
      }
    }

    return '';
  }

  String dropOneItem(Item i) {
    String resultString = '';
    if (i.carrying == true) {
      i.carrying = false;
      gameState.carryWeight -= i.weight;
      i.location = gameState.currentRoomNumber;
      print(
          "Dropped ${i.shortName} (${i.weight}); gameState.carryWeight = ${gameState.carryWeight}");
      resultString += 'Dropped.';

      // SPECIAL CASE: dropped items from UpATree land below in Forest4 (except nest)
      if (i.location == krUpATree && i.number != kiNest) {
        i.location = krForest4;
        if (i.number == kiEgg) {
          resultString +=
              '\nThe egg falls to the ground, and is seriously damaged.';
        } else {
          resultString += '\nThe ${i.shortName} falls to the ground.';
        }
      }
    } else {
      // SPECIAL CASE: DROP WATER acts like POUR WATER (it spills and evaporates)
      // if you are carrying bottle or even if bottle is in the room!
      if (i.number == kiWater) {
        i.location = -1;
        resultString =
            'The water spills to the floor and evaporates immediately.';
      }
    }

    return resultString;
  }

  String takeOneItem(Item i) {
    if (i.carrying == true) {
      return 'You already have that.';
    }
    if (roomIsLit() == false) {
      return 'You can\'t see any such thing.';
    }

    if (i.hidden) {
      print('The ${i.shortName} is still hidden!');
      return 'You can\'t see any such thing.';
    }
    if (!i.available) {
      return 'That isn\'t available.';
    }

    if (i.location > kObjectOffset) {
      Item container = gameState.itemData.getContainingItem(i);
      if (container.opened == false) {
        return 'The ${container.shortName} isn\'t open.';
      }
    }

    if (gameState.carryWeight + i.weight > kMaxCarryWeight) {
      return 'The ${i.shortName} is too heavy to pick up!';
    }

    if (!i.takeable) {
      if (i.takeFailMessage != '') {
        return i.takeFailMessage;
      }
      return (getRandomResponse([
        'Not likely.',
        'You can\'t be serious.',
        'What a concept!',
        'Not a prayer.',
        'An interesting idea...',
        'A valiant attempt.'
      ]));
    }

    // SPECIAL CASE: TAKE WATER same as TAKE BOTTLE (if bottle full)
    if (i.number == kiWater) {
      Item bottle = gameState.itemData.getItemFromNumber(kiBottle);
      if (bottle.carrying == false) {
        i = bottle; // forces BOTTLE to be TAKEN below
      } else if (bottle.opened == false) {
        return ('The bottle is closed.');
      } else {
        return ('You already have that.');
      }
    }

    // go ahead and pick up the item!
    i.carrying = true;
    i.previouslyTaken = true;
    gameState.carryWeight += i.weight;
    print(
        'Picked up: ${i.shortName} (${i.weight}); gameState.carryWeight = ${gameState.carryWeight}');

    // SOLUTION: Clearing: taking leaves uncovers grate!!
    Item grate = gameState.itemData.getItemFromNumber(kiGrate);
    if (i.number == kiLeaves && grate.hidden == true) {
      grate.hidden = false;
      return 'A grating appears on the ground.\nTaken.';
    }

    return 'Taken.';
  }

  void goToRoom({Directions direction}) {
    int nextRoom;

    lookCommandGiven =
        false; // LOOK command will turn on VERBOSE mode only until you change rooms

    nextRoom = gameState.currentRoom.adjacentRooms[direction.index];

    if (nextRoom == krX) {
      // display status message if there are no exits that direction
      setStatus('You can\'t go that way.');
    } else if (nextRoom == krWall) {
      setStatus('There is a wall there.');
    } else if (nextRoom == krCeiling) {
      setStatus('There is no way up.');
    } else if (nextRoom == krRamp) {
      setStatus(
          'You try to ascend the ramp, but it is impossible, and you slide back down.');
    } else if (nextRoom == -krLivingRoom &&
        gameState.currentRoomNumber == krWestOfHouse) {
      setStatus('The door is locked, and there is evidently no key.');
    } else if (nextRoom == -krLivingRoom || nextRoom == -krCellar) {
      setStatus('The trap door is closed.');
    } else if (nextRoom == -krKitchen) {
      setStatus('The window is closed.');
    } else if (nextRoom == krWindow) {
      setStatus('The windows are all barred.');
    } else if (nextRoom == -krWestOfHouse) {
      setStatus('The door is nailed shut.');
    } else if (nextRoom < 0) {
      setStatus('[There is a hidden exit that way!]');
    } else {
      setStatus('');
      //setStatus('[moved to room #$nextRoom]');

      // update player's location
      gameState.currentRoomNumber = nextRoom;
      gameState.currentRoom = gameState
          .roomData.roomList[gameState.currentRoomNumber - kRoomOffset];

      print('moving $direction to ${getNameOfRoom(nextRoom)} ($nextRoom) '
          '${gameState.currentRoom.adjacentRooms}');
      int visitBonus = gameState.currentRoom.getVisitBonus();
      gameState.changeScore(visitBonus);
    }
  }

  String getRank() {
    // TODO: update this with all true ranks and computations
    if (gameState.score > kTotalPossibleScore * 0.9) {
      return 'Wizard';
    } else if (gameState.score > kTotalPossibleScore * 0.5) {
      return 'Elf';
    } else {
      return 'Beginner';
    }
  }
}
