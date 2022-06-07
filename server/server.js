/* SERVER  
    APPLICATION TITLE: SCAVENGER _HUNT
    AUTHOR: Jericho Sharman   
    DATE: 05/2022   
    DESCRIPTION:*/
// ********************************************************************************************************************
// SET UP THE INCLUDES
require("dotenv").config();
const { exit } = require("process");
const express = require("express");
const expressSession = require("express-session");
const pgSession = require("connect-pg-simple")(expressSession);
const db = require("./db/db");
// ********************************************************************************************************************
// CONSTANTS
const appSecretKey = process.env.EXPRESS_SESSION_SECRET_KEY;
const PORT = process.env.PORT;
const app = express(); // Initialise the app
// ********************************************************************************************************************
// SET UP THE APP
app.use("/", (req, res, next) => {
  // 3 paramaters = middlewear
  console.log("*************************************************************");
  console.log(`SERVER COMMUNICATION ${new Date()} ${req.method}`);
  console.log(`METHOD = ${req.method}`);
  console.log(`PATH = ${req.path}`);
  console.log(`PARAMETERS = `);
  console.log(req.body);
  console.log(req.session);
  console.log("*************************************************************");
  next();
});
app.use((err, req, res, next) => {
  // 4 parameters = error handeler
  console.log(`I am ERROR middlewear ${new Date()} ${req.method} ${req.path}`);
  console.log(err);
  res.status(500).json({ message: "Unknown SERVER/INSERT error occurred" });
  next();
});
app.use(express.urlencoded({ extended: false }));
app.use(express.static("client")); // to use the 'client' folder to serve the home html
app.use(express.json());
app.use(
  expressSession({
    secret: appSecretKey,
    cookie: { maxAge: 2000000 },
    resave: false,
    saveUninitialized: true,
    store: new pgSession({
      pool: db,
      createTableIfMissing: true,
    }),
  })
);
const challengesController = require("./controllers/challenges");
const usersController = require("./controllers/users");
const sessionController = require("./controllers/sessions");
app.use("/api/challenges", challengesController);
app.use("/api/users", usersController);
app.use("/api/session", sessionController);
// ********************************************************************************************************************
// DEVELOPER comms
if (process.env.DATABASE) {
  app.listen(PORT, () => {
    console.log(`Listening on http://localhost:${PORT}`);
  });
  console.log(`DATABSE ONLINE: ${process.env.DATABASE}`);
} else {
  console.log(
    "No Database has been setup. Go to the .env file and place the database name"
  );
}
