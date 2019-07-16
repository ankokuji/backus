var fs = require("fs");
var jison = require("jison");
var { createNode } = require("./utils");

var bnf = fs.readFileSync("grammar.jison", "utf8");
var parser = new jison.Parser(bnf);
parser.yy = { createNode };

module.exports = parser;
