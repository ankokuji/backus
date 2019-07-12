const parser = require("./parser");

const ast = parser.parse("1+ 5*b(c, 5)")

console.log(JSON.stringify(ast))

debugger