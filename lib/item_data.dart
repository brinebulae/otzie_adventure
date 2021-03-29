import 'item.dart';
import 'constants.dart';

class ItemData {
  List<Item> itemList = [
    Item(
      number: kiSack,
      listName: 'sack',
      shortName: 'brown sack',
      longName:
          'On the table is an elongated brown sack, smelling of hot peppers.',
      longName2: 'A brown sack is here.',
      location: krKitchen,
      openable: true,
      container: true,
      acceptingSize: 1,
    ),
    Item(
      number: kiBottle,
      listName: 'bottle',
      shortName: 'glass bottle',
      longName: 'A bottle is sitting on the table.',
      longName2: 'A clear glass bottle is here.',
      location: krKitchen,
      openable: true,
      container: true,
      transparent: true,
      acceptingSize: 1,
    ),
    Item(
      number: kiMailbox,
      listName: 'mailbox',
      listName2: 'box',
      shortName: 'mailbox',
      longName: 'There is a small mailbox here.',
      location: krWestOfHouse,
      openable: true,
      takeable: false,
      container: true,
      acceptingSize: 1,
    ),
    Item(
      number: kiMat,
      listName: 'mat',
      shortName: 'welcome mat',
      longName: 'A rubber mat saying \'Welcome to Zork!\' lies by the door.',
      longName2: 'There is a welcome mat here.',
      location: krWestOfHouse,
      examineName: 'Welcome to Zork!',
      readable: true,
    ),
    Item(
      number: kiLeaves,
      listName: 'leaves',
      shortName: 'pile of leaves',
      longName: 'There is a pile of leaves on the ground.',
      edible: true,
      moveable: true,
      location: krClearing,
    ),
    Item(
      number: kiNest,
      listName: 'nest',
      shortName: 'birds nest',
      longName: 'On the branch is a small birds nest.',
      longName2: 'There is a small birds nest here.',
      container: true,
      specialText:
          'In the bird\'s nest is a large egg encrusted with precious jewels, '
          'apparently scavenged somewhere by a childless songbird.  '
          'The egg is covered with fine gold inlay, and ornamented in '
          'lapis lazuli and mother-of-pearl.  Unlike most eggs, this '
          'one is hinged and has a delicate looking clasp holding it '
          'closed.  The egg appears extremely fragile.',
      location: krUpATree,
      size: 1,
      acceptingSize: 1,
    ),
    Item(
      number: kiEgg,
      listName: 'egg',
      shortName: 'jewel-encrusted egg',
      longName: 'There is a jewel-encrusted egg here.',
      location: krUpATree,
      openable: true,
      opened: false,
      size: 1,
    ),
    Item(
      number: kiWater,
      listName: 'water',
      shortName: 'quantity of water',
      longName: '[should never appear].',
      location: kiBottle,
      examineName: 'I see nothing special about the water.',
      drinkable: true,
    ),
    Item(
      number: kiGarlic,
      listName: 'garlic',
      shortName: 'clove of garlic',
      longName: 'There is a clove of garlic here.',
      location: kiSack,
      edible: true,
      size: 1,
    ),
    Item(
      number: kiLunch,
      listName: 'lunch',
      shortName: 'lunch',
      longName: 'A hot pepper sandwich is here.',
      location: kiSack,
      edible: true,
      size: 1,
    ),
    Item(
      number: kiLamp,
      listName: 'lamp',
      shortName: 'lamp',
      lightable: true,
      longName: 'A battery-powered brass lantern is on the trophy case.',
      longName2: 'There is a brass lantern (battery-powered) here.',
      location: krLivingRoom,
      size: 5,
    ),
    Item(
      number: kiSword,
      listName: 'sword',
      shortName: 'sword',
      longName:
          'On hooks above the mantelpiece hangs an elvish sword of great antiquity.',
      longName2: 'There is an elvish sword here.',
      location: krLivingRoom,
      weapon: true,
      size: 5,
    ),
    Item(
      number: kiCarpet,
      listName: 'carpet',
      listName2: 'rug',
      shortName: 'carpet',
      longName: '',
      location: krLivingRoom,
      takeable: false,
      moveable: true,
      takeFailMessage: 'The rug is extremely heavy and cannot be carried.',
    ),
    Item(
      number: kiNewspaper,
      listName: 'newspaper',
      listName2: 'paper',
      shortName: 'newspaper',
      longName:
          'There is an issue of US NEWS & DUNGEON REPORT dated 08/26/04 here.',
      examineName: '               US NEWS & DUNGEON REPORT\n'
          '08/26/04                                        Late Dungeon Edition\n\n'
          'This version of ZORK has been ported to Inform from the original MDL sources created at MIT, dated 22-Jul-1981.  Within the limitations of the Inform libraries, it is fully congruent with the original version from the ARPAnet.\n\n'
          'Please direct all bug reports to Ethan Dicks (erd@infinet.com).  For game-play assistance, consult rec.games.int-fiction.  To learn more about Inform, visit http://inform-fiction.org/\n\n'
          'Thanks to John Francis, Marc Sira, Ivan Drucker, Dave Cornelson, and others for beta-testing.',
      readable: true,
      location: krLivingRoom,
      size: 1,
    ),
    Item(
      number: kiTrophyCase,
      listName: 'case',
      shortName: 'trophy case',
      longName: 'There is a trophy case here.',
      location: krLivingRoom,
      takeable: false,
      container: true,
      acceptingSize: 1000,
      transparent: true,
      openable: true,
      opened: false,
      takeFailMessage:
          'The trophy case is securely fastened to the wall (perhaps to foil any attempt by robbers to remove it).',
    ),
    Item(
      number: kiGrate,
      listName: 'grate',
      listName2: 'grating',
      shortName: 'grating',
      longName: 'There is a grating securely fastened into the ground.',
      location: krClearing,
      takeable: false,
      openable: true,
      lockable: true,
      locked: true,
      hidden: true,
    ),
    Item(
      number: kiLeaflet,
      listName: 'leaflet',
      shortName: 'small leaflet',
      longName: 'There is a small leaflet here.',
      examineName: '                          WELCOME TO ZORK\n'
          ' ZORK is a game of adventure, danger, and low cunning.  In it you will explore some of the most amazing territory ever seen by mortal man.  Hardened adventurers have run screaming from the terrors contained within!\n\n'
          ' In ZORK the intrepid explorer delves into the forgotten secrets of a lost labyrinth deep in the bowels of the earth, searching for vast treasures long hidden from prying eyes, treasures guarded by fearsome monsters and diabolical traps!\n\n'
          ' No PDP-10 should be without one!\n\n'
          ' ZORK was created at the MIT Laboratory for Computer Science, by Tim Anderson, Marc Blank, Bruce Daniels, and Dave Lebling.  It was inspired by the ADVENTURE game of Crowther and Woods, and the long tradition of fantasy and science fiction adventure.  ZORK was originally written in MDL (alias MUDDLE).  The current version was translated from MDL into Inform by Ethan Dicks <erd@infinet.com>.\n\n'
          ' On-line information may be available using the HELP and INFO commands (most systems).\n'
          ' Direct inquiries, comments, etc. by Net mail to erd@infinet.com.\n\n'
          ' (c) Copyright 1978,1979 Massachusetts Institute of Technology\n'
          '           All rights reserved.',
      readable: true,
      location: kiMailbox,
      size: 1,
    ),
    Item(
      number: kiTrapDoor,
      listName: 'trap-door',
      listName2: 'trap',
      listName3: 'trapdoor',
      shortName: 'trap-door',
      location: krLivingRoom,
      takeable: false,
      openable: true,
      hidden: true,
    ),
    Item(
      number: kiHouseDoor,
      listName: 'door',
      shortName: 'door',
      knockable: true,
      location: krWestOfHouse,
      takeable: false,
    ),
    Item(
      number: kiLivingRoomDoor,
      listName: 'wooddoor',
      listName2: 'door',
      shortName: 'wooden door',
      knockable: true,
      location: krLivingRoom,
      readable: true,
      examineName:
          'The engravings translate to \'This space intentionally left blank\'',
      takeable: false,
    ),
    Item(
      number: kiTree,
      listName: 'tree',
      shortName: 'large tree',
      location: krForest4,
      location2: krUpATree,
      takeable: false,
    ),
    Item(
      number: kiWindow,
      listName: 'window',
      shortName: 'window',
      location: krBehindHouse,
      location2: krKitchen,
      takeable: false,
      openable: true,
    ),
    Item(
      number: kiHouse,
      listName: 'house',
      shortName: 'white house',
      examineName:
          'The house is a beautiful colonial house which is painted white.  It is clear that the owners must have been extremely wealthy.',
      location: krWestOfHouse,
      location2: krNorthOfHouse,
      location3: krBehindHouse,
      location4: krSouthOfHouse,
      takeable: false,
      available: false,
    ),
    Item(
      number: kiBrick,
      listName: 'brick',
      listName2: 'clay',
      shortName: 'brick',
      longName: 'There is a square brick here which feels like clay.',
      location: krAttic,
    ),
    Item(
      number: kiKnife,
      listName: 'knife',
      shortName: 'knife',
      longName: 'On a table is a nasty-looking knife.',
      longName2: 'There is a nasty-looking knife lying here.',
      location: krAttic,
      size: 1,
    ),
    Item(
      number: kiRope,
      listName: 'rope',
      shortName: 'rope',
      longName: 'A large coil of rope is lying in the corner.',
      longName2: 'There is a large coil of rope here.',
      location: krAttic,
      size: 1,
    ),
  ];
// end of item list

  // class methods
  Map<String, int> getItemWords() {
    // returns a Map of all acceptable words for objects in the game
    Map<String, int> map1 = Map.fromIterable(itemList,
        key: (k) => k.listName, value: (v) => v.number);
    Map<String, int> map2 = Map.fromIterable(itemList,
        key: (k) => k.listName2, value: (v) => v.number);
    Map<String, int> map3 = Map.fromIterable(itemList,
        key: (k) => k.listName3, value: (v) => v.number);
    return {}..addAll(map1)..addAll(map2)..addAll(map3);
  }

  Item getItemFromNumber(int itemNumber) {
    for (Item i in itemList) {
      if (i.number == itemNumber) {
        return i;
      }
    }
    // no item matching parsedItemNumber was found!
    return null;
  }

  Item getContainingItem(Item theItem) {
    return (getItemFromNumber(theItem.location));
  }

  int getTopmostLocationOfItem(Item theItem) {
    print('in getTopmost');
    int topmostLocation = theItem.location;
    while (topmostLocation > kObjectOffset) {
      Item i = getContainingItem(theItem);
      if (i.container == false || i.opened == true) {
        topmostLocation = i.location;
      }
    }
    print('The ${theItem.shortName} is in location $topmostLocation');
    return (topmostLocation);
  }

  ItemData copy() {
    ItemData copiedItemData = ItemData();
    copiedItemData.itemList = [];
    for (Item i in itemList) {
      copiedItemData.itemList.add(i.copy());
    }
    return copiedItemData;
  }

  void printItemData() {
    for (Item i in itemList) {
      i.printItem();
    }
  }
}
