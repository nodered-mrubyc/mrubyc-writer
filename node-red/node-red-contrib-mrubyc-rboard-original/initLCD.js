module.exports = function(RED) {
    
    function initLCD_Node(config) {
        RED.nodes.createNode(this,config);
        var node = this;

        node.on('input', function(msg) {

            
        });
    }
    RED.nodes.registerType("initLCD",initLCD_Node);
}