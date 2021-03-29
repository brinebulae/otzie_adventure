import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:math' as math;
import 'game_logic.dart';
import 'constants.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';

void main() => runApp(Adventure());

class Adventure extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: StoryPage(),
    );
  }
}

class StoryPage extends StatefulWidget {
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  GameLogic gameLogic = GameLogic();
  // use this to keep focus in textField, i.e. blinking cursor without
  // having to click there repeatedly
  FocusNode myFocusNode;

  final textInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // clean up the focus node when the Form is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textInputController.text = '';

    int commandReturnCode = kSuccessCode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('images/' + gameLogic.getBackgroundImage() + '.png'),
            // image: AssetImage('images/water-drops.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                // score & moves
                flex: 1,
                child: Center(
                  child: Text(
                    gameLogic.getScoreAndMoves(),
                    style: TextStyle(
                      backgroundColor: Colors.black38,
                      fontSize: 25.0,
                      color: Colors.lightGreen,
                    ),
                  ),
                ),
              ),
              Expanded(
                // short description
                flex: 1,
                child: Center(
                  child: Text(
                    gameLogic.getShortDescription(),
                    style: TextStyle(
                        backgroundColor: Colors.black38,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                // long description & objects
                flex: 10,
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: gameLogic.getLongDescription(),
                    style: TextStyle(
                      backgroundColor: Colors.black38,
                      fontSize: 15.0,
                    ),
                    children: [
                      TextSpan(
                        text: gameLogic.describeLocalObjects(),
                        style: TextStyle(
                            backgroundColor: Colors.black38,
                            fontSize: 15.0,
                            color: Colors.yellow),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                // status & errors
                flex: 4,
                child: Center(
                  child: AutoSizeText(
                    gameLogic.getStatus(),
                    style: TextStyle(
                      backgroundColor: Colors.black38,
                      fontSize: 35.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    minFontSize: 10,
                    maxLines: 10,
                  ),
                ),
              ),
              Expanded(
                // top row of arrows
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Spacer(flex: 7),
                    buildIconButton(Feather.arrow_up_left, 'Go Northwest',
                        directionChoice: Directions.northwest),
                    Spacer(flex: 2),
                    buildIconButton(Feather.arrow_up, 'Go North',
                        directionChoice: Directions.north),
                    Spacer(flex: 2),
                    buildIconButton(Feather.arrow_up_right, 'Go Northeast',
                        directionChoice: Directions.northeast),
                    Spacer(flex: 7),
                  ],
                ),
              ),
              Expanded(
                // middle row of arrows
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Spacer(flex: 3),
                    buildIconButton(Feather.arrow_left, 'Go West',
                        directionChoice: Directions.west),
                    Spacer(flex: 1),
                    buildIconButton(MaterialCommunityIcons.stairs, 'Go Up',
                        directionChoice: Directions.up),
                    Spacer(flex: 1),
                    Transform.rotate(
                      angle: 90 * math.pi / 180,
                      child: buildIconButton(
                          MaterialCommunityIcons.stairs, 'Go Down',
                          directionChoice: Directions.down),
                    ),
                    Spacer(flex: 1),
                    buildIconButton(Feather.arrow_right, 'Go East',
                        directionChoice: Directions.east),
                    Spacer(flex: 3),
                  ],
                ),
              ),
              Expanded(
                // bottom row of arrows
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Spacer(flex: 7),
                    buildIconButton(Feather.arrow_down_left, 'Go Southwest',
                        directionChoice: Directions.southwest),
                    Spacer(flex: 2),
                    buildIconButton(Feather.arrow_down, 'Go South',
                        directionChoice: Directions.south),
                    Spacer(flex: 2),
                    buildIconButton(Feather.arrow_down_right, 'Go Southeast',
                        directionChoice: Directions.southeast),
                    Spacer(flex: 7),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                // row of misc commands
                flex: 2,
                child: Row(
                  children: [
                    Spacer(flex: 1),
                    buildIconButton(Entypo.suitcase, 'Inventory',
                        command: kInventoryCommand),
                    Spacer(flex: 1),
                    buildIconButton(FontAwesome.save, 'Save',
                        command: kSaveCommand),
                    Spacer(flex: 1),
                    buildIconButton(FontAwesome.refresh, 'Restart',
                        command: kRestartCommand),
                    Spacer(flex: 1),
                    buildIconButton(FontAwesome.hand_grab_o, 'Get All',
                        command: kTakeAllCommand),
                    Spacer(flex: 1),
                    buildIconButton(FontAwesome.hand_stop_o, 'Drop All',
                        command: kDropAllCommand),
                    Spacer(flex: 1),
                  ],
                ),
              ),
              Expanded(
                // input command box
                child: TextField(
                  enabled: !gameLogic.userQuit,
                  autofocus: true,
                  focusNode: myFocusNode,
                  controller: textInputController,
                  maxLines: 1,
                  autocorrect: false,
                  cursorHeight: 15,
                  cursorColor: Colors.black,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: '',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide.none),
                  ),
                  onSubmitted: (userCommand) {
                    setState(() {
                      textInputController.text = userCommand;
                      commandReturnCode = gameLogic.executeText(userCommand);
                      // there are three cases where gameLogic returns control to main in order to
                      // pop up scrollable windows: INVENTORY, INFO,  and HELP
                      if (commandReturnCode == kSuccessCode ||
                          commandReturnCode == kHelpCommand ||
                          commandReturnCode == kInventoryCommand ||
                          commandReturnCode == kInfoCommand) {
                        gameLogic.gameState.moves++;
                      }
                      if (commandReturnCode == kInventoryCommand) {
                        _presentAlertDialog(gameLogic.checkEmptyHanded(),
                            gameLogic.describeInventory());
                      } else if (commandReturnCode == kInfoCommand) {
                        _presentAlertDialog('Welcome to ZORK!', kInfoText);
                      } else if (commandReturnCode == kHelpCommand) {
                        _presentAlertDialog('Help', kHelpText);
                      }
                      myFocusNode.requestFocus();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildIconButton(IconData commandIcon, String toolTipText,
      {Directions directionChoice, int command}) {
    Color iconColor = Colors.black12;

    if ((!gameLogic.isDirectionBlocked(directionChoice) &&
            gameLogic.userQuit == false) ||
        command == kRestartCommand) {
      iconColor = Colors.green;
    }

    return Container(
      color: Colors.white,
      child: IconButton(
          icon: Icon(commandIcon),
          iconSize: 30,
          tooltip: toolTipText,
          color: iconColor,
          // highlightColor: Colors.orange, // TODO: this doesn't seem to work
          // hoverColor: Colors.green, // NOTE: mobile apps don't support this!
          // focusColor: Colors.yellow, // TODO: this doesn't seem to work
          // splashColor: Colors.red, // TODO: this doesn't seem to work
          // splashRadius: 30, // TODO: this doesn't seem to work
          onPressed: () {
            setState(() {
              if (command == kInventoryCommand) {
                _presentAlertDialog(gameLogic.checkEmptyHanded(),
                    gameLogic.describeInventory());
                gameLogic.gameState.moves++;
                gameLogic.autoSaveGame();
              } else {
                gameLogic.executeButton(directionChoice, command);
              }
              myFocusNode.requestFocus();
            });
          }),
    );
  }

  Future<void> _presentAlertDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(children: [
              Text(message),
            ]),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
