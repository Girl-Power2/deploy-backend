const express = require("express");

//controllers
const {
  createNewRole ,
getAllRoles}=require("../controllers/roles");


  const rolesRouter = express.Router();

rolesRouter.post("/", createNewRole);
rolesRouter.get("/",getAllRoles)

module.exports = rolesRouter