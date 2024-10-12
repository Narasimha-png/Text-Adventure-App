class GameLogic {
  String currentRoom = "living_room";
  List<String> inventory = [];

  // Define rooms with items and exits
  Map<String, dynamic> rooms = {
    "living_room": {
      "description": "You are in a cozy living room.",
      "items": ["key", "book"],
      "exits": {"north": "kitchen"}
    },
    "kitchen": {
      "description": "You are in the kitchen. It smells like freshly baked bread.",
      "items": ["knife"],
      "exits": {"south": "living_room"}
    }
  };

  // Process user commands
  String processCommand(String command) {
    List<String> words = command.split(" ");

    if (words.contains("look")) {
      return describeRoom();
    } else if (words.contains("go")) {
      var direction = words[words.indexOf("go") + 1];
      return move(direction);
    } else if (words.contains("take")) {
      var item = words[words.indexOf("take") + 1];
      return takeItem(item);
    } else {
      return "I don't understand that command.";
    }
  }

  // Describe the current room
  String describeRoom() {
    if (rooms[currentRoom] == null) {
      return "There's nothing to see here.";
    }

    String description = rooms[currentRoom]["description"];

    if (rooms[currentRoom]["items"] != null &&
        rooms[currentRoom]["items"].isNotEmpty) {
      description += "\nYou see: ${rooms[currentRoom]["items"].join(", ")}";
    }

    description += "\nExits: ${rooms[currentRoom]["exits"].keys.join(", ")}";
    return description;
  }

  // Move between rooms
  String move(String direction) {
    if (rooms[currentRoom]["exits"] != null &&
        rooms[currentRoom]["exits"].containsKey(direction)) {
      currentRoom = rooms[currentRoom]["exits"][direction];
      return describeRoom();
    } else {
      return "You can't go that way.";
    }
  }

  // Take an item from the room
  String takeItem(String item) {
    if (rooms[currentRoom] != null &&
        rooms[currentRoom]["items"] != null &&
        rooms[currentRoom]["items"].contains(item)) {
      inventory.add(item);
      rooms[currentRoom]["items"].remove(item);
      return "You take the $item.";
    } else {
      return "That item is not here.";
    }
  }
}
