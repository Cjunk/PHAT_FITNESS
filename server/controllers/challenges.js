/* SERVER 
    FILE: CHALLENGES API handeler 
    AUTHOR: Jericho Sharman   
    DATE: 05/2022   
    DESCRIPTION:*/

// ********************************************************************************************************************
// SET UP THE INCLUDES
require("dotenv").config();
const express = require("express");
const router = express.Router();
const db = require("../db/db");
// ********************************************************************************************************************

router.get("/", (req, res) => {
  //  Called on ever page refresh to check if the user is already logged in.
  // console.log(req.session) //TODO: delete console.log
  res.json({
    name: req.session.name,
    email: req.session.email,
    spook:"sppok"
  });
});
// ********************************************************************************************************************
// INTERNAL FUNCTIONS
function dbSelectQuery(theQuery, res) {
    //  Function to execute SQL code in the database
    return db
      .query(theQuery)
      .then((dbResults) => {
        res.json(dbResults.rows);
      })
      .catch((reason) => {
        console.log("INTERNAL DATABASE ERROR", reason);
        res.status(500).json({ message: "Cannot find data" });
      });
  }
module.exports = router;