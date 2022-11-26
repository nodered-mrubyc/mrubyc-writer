module.exports = function (RED) {

    function PWM_Node(config) {
        RED.nodes.createNode(this, config);
        var node = this;

        this.Pin_num = config.Pin_num;
        

        this.on('input', function (msg) {
            if (node.Pin_num <= 0 || node.Pin_num != isNaN) {
                node.warn("Pin番号が正しくありません。正しいPin番号を入力して下さい。");
                node.send(msg);
            }
        });
    }
    RED.nodes.registerType("PWM", PWM_Node);
}