'use strict';

const express = require('express');

const app = express();
app.use(express.static('./'))

app.get('/', (req, res) => {
    res.sendfile('./index.html')
});

const PORT = 80;
const HOST = '0.0.0.0';
app.listen(PORT, HOST);

console.log(`Running on http://${HOST}:${PORT}`);
