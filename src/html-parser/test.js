const path = require("path");
const fs = require("fs");

const parser = require("./parser");

const html = fs.readFileSync(path.join(__dirname, "./template.html")).toString()

const ast = parser.parse(html)

console.log(JSON.stringify(ast))

debugger