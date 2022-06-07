/* SERVER 
    FILE: USERS API handeler 
    AUTHOR: Jericho Sharman   
    DATE: 05/2022   
    DESCRIPTION:*/
// ********************************************************************************************************************
// SET UP THE INCLUDES
const express = require("express");
const bcrypt = require("bcrypt");
const db = require("../db/db");
const router = express.Router();

// ********************************************************************************************************************
// CREATE THE ROUTER
router.post(`/createNewUser`, (req, res) => {
  req.body.memberShipStartDate = new Date().toISOString().slice(0, 19).replace('T', ' ');
  req.body.dateJoined = new Date().toISOString().slice(0, 19).replace('T', ' ');
  const {
    userType,
    profileType,
    memberShipType,
    memberShipStartDate,
    title,
    firstName,
    email,
    dateJoined,
    photo,
    password,
    confirmPassword,
  } = req.body;
  if (password != confirmPassword) {
    res.status(400).json({ status: "false", message: "Password do not match" });
    return;
  }
  if (!firstName || !email || !password) {
    res.status(400).json({ status: "false", message: "Missing information" });
    return;
  }
  delete req.body.password;
  delete req.body.confirmPassword;
  const hash = createHash(password,email, 5);
  req.body.hashed_password = hash;
  if (
    // Validating the Info
    firstName.length > 20 ||
    firstName.length < 1 ||
    email.length > 200 ||
    password.length > 20 ||
    password.length < 10
  ) {
    res.status(400).json({ status: "false", message: "Incorrect length" });
    return;
  }
  db.query(
    "INSERT INTO users (userType,profileType,memberShipType,memberShipStartDate,title,firstName,email,dateJoined,photo,hashed_password) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10);",
    [
      userType,
      profileType,
      memberShipType,
      memberShipStartDate,
      title,
      firstName,
      email,
      dateJoined,
      photo,
      hash,
    ]
  )
    .then((dbres) => {
      res.json({ status: "ok", message: "New user added" });
    })
    .catch((reason) => {
      console.log("ERROR ---> ", reason.message);
      res.status(400).json({ message: reason.detail });
    });
});

router.get(`/getUsers`, (req, res) => {
  result = dbSelectQuery("SELECT * FROM users", res);
  // res.send('hello world')

});

// ********************************************************************************************************************
// INTERNAL FUNCTIONS
function createHash(password,email) {
  return bcrypt.hashSync(password + email.toUpperCase(), 5, null);
}
function dbSelectQuery(theQuery, res) {
  //  Function to execute SQL code in the database
  result = db
    .query(theQuery)
    .then((dbResults) => {
      if (dbResults.rowCount > 0) {
        res.json(dbResults.rows);
      } else {
        console.log("no users in the database");
        res.status(500).send("No users in database");
      }
    })
    .catch((reason) => {
      console.log("INTERNAL DATABASE ERROR", reason);
      res.status(500).json({ message: "Cannot find data" });
    });
  return result;
}

module.exports = router;
