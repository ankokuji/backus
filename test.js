const parser = require("./parser");

const ast = parser.parse("const a,b, v=  c")

console.log(JSON.stringify(ast))

debugger