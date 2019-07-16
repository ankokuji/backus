const parser = require("./parser");

const ast = parser.parse(" 5 * function a() {} ")

console.log(JSON.stringify(ast))

debugger