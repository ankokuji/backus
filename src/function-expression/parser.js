var fs = require("fs");
var jison = require("jison");
var path = require("path")
var { createNode } = require("./utils");

var bnf = fs.readFileSync(path.join(__dirname,"grammar.jison"), "utf8");
var parser = new jison.Parser(bnf);
parser.yy = { createNode };

module.exports = parser;
