const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('VCS Lab - Hello World');
});

app.get('/login', (req, res) => {
  res.send('Login page (placeholder)');
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));