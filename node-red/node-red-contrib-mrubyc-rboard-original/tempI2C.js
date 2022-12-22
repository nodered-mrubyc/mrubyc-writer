module.exports = function(RED) {
    
    function tempI2C_Node(config) {
        RED.nodes.createNode(this,config);
        var node = this;

        node.on('input', function(msg) {

            
        });
    }
    RED.nodes.registerType("tempI2C",tempI2C_Node);
}