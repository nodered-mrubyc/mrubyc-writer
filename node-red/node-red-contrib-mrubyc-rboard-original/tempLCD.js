module.exports = function(RED) {
    
    function tempLCD_Node(config) {
        RED.nodes.createNode(this,config);
        var node = this;

        node.on('input', function(msg) {

            
        });
    }
    RED.nodes.registerType("tempLCD",tempLCD_Node);
}