module.exports = function(RED) {
	var node;
	function ButtonNode(config) {
		RED.nodes.createNode(this,config);
		node = this;

	}
	RED.nodes.registerType("Button",ButtonNode);
}
