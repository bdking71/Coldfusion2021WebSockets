// Establish WebSocket connection
const ws = new WebSocket("ws://<SERVER ADDRESS>:<PORT NBR>/ChatDemo/chatChannel");

ws.onopen = function(event) {
    console.log("WebSocket connection established.");
};

// Handle incoming messages
ws.onmessage = function(event) {
    console.log("Message from server: ", event.data);

    // Display the message in the chatBox div
    const chatBox = document.getElementById("chatBox");
    const newMessage = document.createElement("p");
    newMessage.textContent = event.data;  // Add received message
    chatBox.appendChild(newMessage);

    // Auto-scroll the chat box to the latest message
    chatBox.scrollTop = chatBox.scrollHeight;
};

// Handle any errors
ws.onerror = function(error) {
    console.log("WebSocket error: ", error);
};

// Handle WebSocket closure
ws.onclose = function(event) {
    console.log("WebSocket connection closed.");
};

// Send message when the user clicks the send button
document.getElementById("sendButton").addEventListener("click", function() {
    const messageInput = document.getElementById("messageInput");
    const message = messageInput.value.trim();

    if (message) {
        // Send the message to the WebSocket server
        ws.send(message);

        // Clear the input field after sending the message
        messageInput.value = '';

        // Display the sent message in the chatBox (optional)
        const chatBox = document.getElementById("chatBox");
        const newMessage = document.createElement("p");
        newMessage.textContent = "You: " + message;
        chatBox.appendChild(newMessage);

        // Auto-scroll the chat box to the latest message
        chatBox.scrollTop = chatBox.scrollHeight;
    }
});

// Send message when user presses "Enter" key
document.getElementById("messageInput").addEventListener("keydown", function(event) {
    if (event.key === "Enter") {
        document.getElementById("sendButton").click();
    }
});
