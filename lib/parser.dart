import 'constants.dart';
import 'dictionary.dart';

class Parser {
  String userString;
  List<int> commands;
  List<String> userWords;
  Dictionary vocab = Dictionary();

  Parser({
    this.userString = '',
  });

  List<int> parseInput(String typedInput) {
    userString = typedInput;
    int numberOfWords = 0;

    if (userString.isEmpty) {
      print('input was empty!');
      return kEmptyInput;
    }

    // split typedInput into separate words divided by whitespace;
    // ignore leading and trailing whitespace
    userWords = userString.toLowerCase().trim().split(new RegExp(r"( +)"));

    // handle special cases where three-word verbs are used to mean one action
    // NOTE: must handle these before two-word cases below
    convertThreeWordCommandToOneWord('pick', 'up', 'all');
    convertThreeWordCommandToOneWord('put', 'down', 'all');

    // handle special cases where two-word verbs are used to mean one action
    convertTwoWordCommandToOneWord('pick', 'up');
    convertTwoWordCommandToOneWord('look', 'at');
    convertTwoWordCommandToOneWord('put', 'down');
    convertTwoWordCommandToOneWord('turn', 'on');
    convertTwoWordCommandToOneWord('turn', 'off');
    convertTwoWordCommandToOneWord('hello', 'sailor');
    convertTwoWordCommandToOneWord('hello', 'aviator');
    convertTwoWordCommandToOneWord('knock', 'on');
    convertTwoWordCommandToOneWord('knock', 'at');
    convertTwoWordCommandToOneWord('climb', 'up');
    convertTwoWordCommandToOneWord('climb', 'down');
    convertTwoWordCommandToOneWord('take', 'all');
    convertTwoWordCommandToOneWord('get', 'all');
    convertTwoWordCommandToOneWord('drop', 'all');
    convertTwoWordCommandToOneWord('insert', 'all');
    convertTwoWordCommandToOneWord('put', 'all');

    convertOneWordCommandToTwoWords('pick', 'pick up');
    convertOneWordCommandToTwoWords('knock', 'knock at');
    convertOneWordCommandToTwoWords('climb', 'climb up');
    convertOneWordCommandToTwoWords('x', 'examine');

    swapAbbreviationForFullCommand('i', 'inventory');
    swapAbbreviationForFullCommand('l', 'look');
    swapAbbreviationForFullCommand('z', 'wait');

    numberOfWords = userWords.length;
    print('...\n$numberOfWords words: $userWords');

    commands = [];
    for (int i = 0; i < numberOfWords; i++) {
      commands.add(kEmptyWord);
    }

    if (numberOfWords == 0 || (numberOfWords == 1 && userWords[0] == '')) {
      print('no words found!');
      return kEmptyInput;
    }

    // match words against vocabulary and encode into ints
    // look for a verb in first word
    bool matchedVerb = false;
    for (String v in vocab.wordMap.keys) {
      if (userWords[0] == v) {
        commands[0] = vocab.wordMap[v];
        print('matched verb=$v; word #${commands[0]}');
        matchedVerb = true;
        break;
      }
    }
    if (matchedVerb == false) {
      print('The verb ${userWords[0]} was unmatched.');
      return kUnknownVerb;
    }

    // look for objects in remaining words
    for (int i = 1; i < numberOfWords; i++) {
      if (numberOfWords > i) {
        // look for an object in word i+1
        bool matchedObject = false;
        for (String o in vocab.wordMap.keys) {
          if (userWords[i] == o) {
            commands[i] = vocab.wordMap[o];
            print('matched object=$o; word #${commands[i]}');
            matchedObject = true;
            break;
          }
        }
        if (matchedObject == false) {
          print('unrecognized object ${userWords[i]}.');
          commands[i] = kUnknownWord;
        }
      }
    }
    while (commands.length < kMinCommands) {
      commands.add(kEmptyWord);
    }
    return commands;
  }

  void convertTwoWordCommandToOneWord(String word1, String word2) {
    if (userWords[0] == word1 &&
        userWords.length > 1 &&
        userWords[1] == word2) {
      print('...rejiggering for special case: -$word1 $word2- ');
      // rejigger so that two words get combined into one word by itself
      userWords.removeAt(1);
      userWords.removeAt(0);
      userWords.insert(0, word1 + ' ' + word2);
    }
  }

  void convertThreeWordCommandToOneWord(
      String word1, String word2, String word3) {
    if (userWords[0] == word1 &&
        userWords[1] == word2 &&
        userWords.length > 2 &&
        userWords[2] == word3) {
      print('...rejiggering for special case: -$word1 $word2 $word3- ');
      // rejigger so that two words get combined into one word by itself
      userWords.removeAt(2);
      userWords.removeAt(1);
      userWords.removeAt(0);
      userWords.insert(0, word1 + ' ' + word2 + ' ' + word3);
    }
  }

  void convertOneWordCommandToTwoWords(String word1, String word2) {
    if (userWords[0] == word1 && userWords.length == 1) {
      print('...rejiggering for special case: -$word1- -> -$word2- ');
      // rejigger so that one word gets combined into two words (or one new word)
      userWords.removeAt(0);
      userWords.insert(0, word2);
    }
  }

  void swapAbbreviationForFullCommand(String word1, String word2) {
    if (userWords[0] == word1) {
      print('...rejiggering for special case: -$word1- -> -$word2- ');
      // rejigger so that first word gets changed into second word
      userWords.removeAt(0);
      userWords.insert(0, word2);
    }
  }
}
