const express = require('express');
const app = express();

app.get('/',  (req, res) => res.send('Running!'));

app.listen(3000);
