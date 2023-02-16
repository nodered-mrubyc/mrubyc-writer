module.exports = function(RED) {
    "use strict"

    function simpleLED_Node(config) {
        RED.nodes.createNode(this, config);
        var node = this;
        
        this.targetPort = config.targetPort;
        this.onBoardLED = config.onBoardLED;

        node.on('input', function () {

            if (node.targetPort < 0 || isNaN(node.targetPort)) {
                throw new Error("Pin番号が正しくありません。正しいPin番号を入力して下さい。");

            } else if (node.targetPort == "") {
                throw new Error("Pin番号が設定されていません。Pin番号を設定して下さい。");

            }               
         });

    }
    RED.nodes.registerType("simpleLED",simpleLED_Node);
}

