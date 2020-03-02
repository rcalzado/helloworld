const express = require('express');
const app = express();

app.get('/',  (req, res) => res.send('R$ 750,00 na minha conta já!'));

app.listen(3000);
