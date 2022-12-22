module.exports = function(RED) {
    
    function textLCD_Node(config) {
        RED.nodes.createNode(this,config);
        var node = this;

        node.on('input', function(msg) {

            
        });
    }
    RED.nodes.registerType("textLCD",textLCD_Node);
}