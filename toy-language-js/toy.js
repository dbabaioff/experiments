var parser = require("./parser").parser;

var Toy = {};

// Parser
Toy.Parser = {
    parse: function(code) {
        return parser.parse(code);
    },

    show: function(ast) {
        console.log(JSON.stringify(ast, null, 4))
    }
};

// OpCodes
var OpCode = function(name, arg) {
    this.name = name;
    this.arg = arg || null;
};

Toy.Compiler = {
    compile: function(tree) {
        var intructions = [];
        
        for (var i = 0, l = tree.length; i < l; i++) {
            switch (tree[i].type) {
                case 'VAR_STMT':
                    var expr = this.compile([tree[i].expr]);  // TODO REMOVE ARRAY

                    intructions.push(expr);
                    intructions.push(new OpCode('OP_PUSHLOCAL', tree[i].id.name));
                    break;

                case 'INTEGER':
                    return new OpCode('OP_PUSHCONST', tree[i].value);
                    break;

                case 'IDENTIFIER':
                    return new OpCode('OP_PUSHVALUE', tree[i].name);
                    break;
            }
        }
        
        return intructions;
    },

    show: function(opCodes) {
        for (var i = 0, l = opCodes.length; i < l; i++) {
            console.log('[' + i + '] ' + opCodes[i].name + ' ' + opCodes[i].arg);
        }
    }
};

// VM
var StackFrame = function(pc) {
    this.pc = pc;
    this.symbolTable = {};
};

Toy.VM = function() {
    // The bytecode
    this.instructions = [];
    
    // Stack 
    this.stack = [];

    // Callstack
    this.callStack = [];

    // Program counter
    this.pc = 0
};
Toy.VM.prototype = {
    reset: function() {
        this.pc    = 0;
        this.stack = [];
    },
    
    run: function(instructions) {
        this.reset();

        this.instructions = instructions;
        this.callStack.push(new StackFrame(this.instructions.length));
        
        while (this.pc < this.instructions.length) {
            var instruction = this.instructions[this.pc++];

            switch (instruction.name) {
                case 'OP_PUSHLOCAL':

                    break;
                
                case 'OP_PUSHCONST':
                    this.stack.push(instruction.arg);
                    break;
                
                case 'OP_PUSHVALUE':

                    break;
            }
        }
    },

    printStack: function() {

    }
};

var ast = Toy.Parser.parse('local x = 10 local y = x');
Toy.Parser.show(ast);

var opCodes = Toy.Compiler.compile(ast);
Toy.Compiler.show(opCodes);

var vm = new Toy.VM();
vm.run(opCodes);