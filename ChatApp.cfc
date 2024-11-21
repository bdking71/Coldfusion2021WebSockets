component {

    // WebSocket service initialization
    private variables.websocketService;

    // Constructor to initialize the WebSocket Service
    public void function init() {
        // Initialize the WebSocket service from the page context
        this.websocketService = getPageContext().getWebSocketService();
        return this;
    }

    // Function to handle incoming messages
    public void function onMessage(string channel, string message) {
        try {
            // Log the received message for debugging
            writeDump("Received message: " & message);

            // Parse the message if it's JSON formatted
            var parsedMessage = deserializeJSON(message);

            // If the message is in JSON format and contains a 'message' field
            if (structKeyExists(parsedMessage, "message") && len(trim(parsedMessage.message)) > 0) {
                // Send the parsed message to the channel
                this.sendMessage(channel, parsedMessage.message);
            } else {
                // If the message isn't structured properly, just pass it as is
                this.sendMessage(channel, message);
            }
        } catch (any e) {
            // Log error if there's an issue with processing the message
            writeDump("Error processing message: " & e.message);
        }
    }

    // Function to send messages to the WebSocket channel
    public void function sendMessage(string channel, string message) {
        try {
            // Log message before sending for debugging
            writeDump("Sending message to channel: " & channel & " Message: " & message);

            // Publish the message to the channel
            this.websocketService.publish(channel, message);
        } catch (any e) {
            // Log error if there's an issue with publishing the message
            writeDump("Error sending message: " & e.message);
        }
    }

    // Function to handle when a new user connects
    public void function onConnect(string channel, string clientID) {
        try {
            // Notify the channel that a new user has joined
            this.sendMessage(channel, "User " & clientID & " has joined.");
        } catch (any e) {
            // Log error if there's an issue when a user connects
            writeDump("Error onConnect: " & e.message);
        }
    }

    // Function to handle when a user disconnects
    public void function onDisconnect(string channel, string clientID) {
        try {
            // Notify the channel that a user has left
            this.sendMessage(channel, "User " & clientID & " has left.");
        } catch (any e) {
            // Log error if there's an issue when a user disconnects
            writeDump("Error onDisconnect: " & e.message);
        }
    }
}
