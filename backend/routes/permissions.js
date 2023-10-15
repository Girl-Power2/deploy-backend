const express = require("express");

//controllers
const {

  createNewPermission, getAllPermissions,
  
} = require("../controllers/permissions");

const permissionsRouter = express.Router();


permissionsRouter.post("/", createNewPermission);
permissionsRouter.get("/" ,getAllPermissions)
module.exports = permissionsRouter;