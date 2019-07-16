class Node {
  constructor(type) {
    this.type = type;
  }
}
function createNode(type) {
  return new Node(type);
}

exports.createNode = createNode;
