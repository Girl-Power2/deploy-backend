const express = require("express");

const { register,login,Provider_login, getUserById, countUser } = require("../controllers/users");
const authentication=require("../middlewares/authentication")
const authorization=require("../middlewares/authorization")
const usersRouter = express.Router();

usersRouter.post("/register", register);
usersRouter.post("/login", login);
usersRouter.post("/loginProvider",Provider_login)
usersRouter.get("/",authentication,getUserById)
usersRouter.get("/conutOfUsers",authentication,countUser)
module.exports = usersRouter;