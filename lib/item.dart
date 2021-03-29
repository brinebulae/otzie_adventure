class Item {
  int number;
  String listName;
  String listName2;
  String listName3;
  String shortName;
  String longName = '';
  String longName2 = '';
  String specialText = '';
  String examineName;
  String takeFailMessage;
  int location = -1; // roomNumber(s) where item currently exists
  int location2 =
      -1; //  immovable objects can be in up to 4 places (e.g. house)
  int location3 = -1;
  int location4 = -1;
  int weight = 1; // player can only carry a maximum of kMaxCarryWeight total
  int size =
      2; // used to determine if you can fit item in a container. Smallest items have size=1
  int acceptingSize =
      2; // used for containers to determine max size of any item user may try to insert
  bool weapon = false;
  bool carrying = false;
  bool available = true;
  bool takeable = true;
  bool previouslyTaken = false;
  bool openable = false;
  bool opened = false;
  bool moveable = false;
  bool knockable = false;
  bool hidden = false;
  bool edible = false;
  bool drinkable = false;
  bool readable = false;
  bool container = false;
  bool lockable = false;
  bool locked = false;
  bool lightable = false;
  bool lit = false;
  bool transparent = false;

  int pointValue = 0;

  Item({
    this.number,
    this.listName,
    this.listName2,
    this.listName3,
    this.shortName,
    this.longName = '',
    this.longName2 = '',
    this.specialText = '',
    this.examineName = '',
    this.takeFailMessage = '',
    this.location,
    this.location2 = -1,
    this.location3 = -1,
    this.location4 = -1,
    this.weight = 1,
    this.size = 2,
    this.acceptingSize = 2,
    this.weapon = false,
    this.carrying = false,
    this.available = true,
    this.takeable = true,
    this.previouslyTaken = false,
    this.openable = false,
    this.opened = false,
    this.moveable = false,
    this.knockable = false,
    this.hidden = false,
    this.edible = false,
    this.drinkable = false,
    this.readable = false,
    this.container = false,
    this.lockable = false,
    this.locked = false,
    this.lightable = false,
    this.lit = false,
    this.transparent = false,
    this.pointValue,
  });

  Item copy() {
    Item copiedItem = Item();
    copiedItem.number = number;
    copiedItem.listName = listName;
    copiedItem.listName2 = listName2;
    copiedItem.listName3 = listName3;
    copiedItem.shortName = shortName;
    copiedItem.longName = longName;
    copiedItem.longName2 = longName2;
    copiedItem.specialText = specialText;
    copiedItem.examineName = examineName;
    copiedItem.takeFailMessage = takeFailMessage;
    copiedItem.location = location;
    copiedItem.weight = weight;
    copiedItem.size = size;
    copiedItem.acceptingSize = acceptingSize;
    copiedItem.weapon = weapon;
    copiedItem.carrying = carrying;
    copiedItem.available = available;
    copiedItem.takeable = takeable;
    copiedItem.previouslyTaken = previouslyTaken;
    copiedItem.openable = openable;
    copiedItem.opened = opened;
    copiedItem.moveable = moveable;
    copiedItem.knockable = knockable;
    copiedItem.hidden = hidden;
    copiedItem.edible = edible;
    copiedItem.drinkable = drinkable;
    copiedItem.readable = readable;
    copiedItem.container = container;
    copiedItem.lockable = lockable;
    copiedItem.locked = locked;
    copiedItem.pointValue = pointValue;
    copiedItem.lightable = lightable;
    copiedItem.lit = lit;
    copiedItem.transparent = transparent;

    return copiedItem;
  }

  void printItem() {
    if (carrying == true) {
      print('itemNumber: $number');
      print('shortName: $shortName');
      print('location: $location');
      print('carrying: $carrying');
      print('opened: $opened');
    }
  }
}
