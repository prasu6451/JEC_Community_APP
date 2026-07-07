const express = require('express');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT;

// Middleware to parse incoming JSON payloads
app.use(express.json());

// Base health check endpoint
app.get('/api/health', (req, res) => {
    res.status(200).json({ status: 'success', message: 'Server is running perfectly' });
});

// Activate the server listener
app.listen(PORT, () => {
    console.log(`Server dynamically running on http://localhost:${PORT}`);
});
