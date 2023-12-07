require('dotenv').config();

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const routes = require('./routes/routes');
const routesPost = require('./routes/routesPost');
const routesChat = require('./routes/routesChat');
const mongoString = process.env.DATABASE_URL
mongoose.connect(mongoString);
const database = mongoose.connection

const app = express();

app.use(cors());
app.use(express.json());
app.listen(5000, () => {
    console.log(`Server Started at ${5000}`)
  })
app.use('/personalInfo',routes)
app.use('/postInfo',routesPost)
app.use('/chatInfo',routesChat)


//Here, database.on means it will connect to the database, 
//and throws any error if the connection fails. And database.once means 
//it will run only one time. If it is successful, it will show a message that says Database Connected.
database.on('error', (error) => {
  console.log(error)
})

database.once('connected', () => {
  console.log('Database Connected');
})