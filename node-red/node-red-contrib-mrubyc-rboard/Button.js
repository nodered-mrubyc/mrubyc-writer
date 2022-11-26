module.exports = function(RED) {
	"use strict"
	
	function ButtonNode(config) {
		RED.nodes.createNode(this,config);
		var node = this;
		var msg = {};

		this.targetPort = config.targetPort;
		this.onBoardButton = config.onBoardButton;


		this.on('input', function (msg) {
			if (node.targetPort <= 0 || node.targetPort != isNaN) {
				node.warn("Pin番号が正しくありません。正しいPin番号を入力してください。");
				node.send(msg);
			}

		});

		return;

	}
	RED.nodes.registerType("Button",ButtonNode);
}
