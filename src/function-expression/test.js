const parser = require("./parser");

const ast = parser.parse("function a ")

console.log(JSON.stringify(ast))

debugger