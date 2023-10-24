const express = require("express");

const historyRouter = express.Router();
const authentication = require("../middlewares/authentication");
const authorization = require("../middlewares/authorization");
const {
  addHistory,
  getHistoryByUserId,
  getHistoryById,
  updateHistoryById,
  deleteHistoryById,
} = require("../controllers/history");

historyRouter.post(
  "/",
  authentication,
  authorization("ADD_HISTORY"),
  addHistory
);
historyRouter.get("/users", authentication,authorization("ADD_HISTORY"), getHistoryByUserId);
historyRouter.get(
  "/:id",
  authentication,
  authorization("ADD_HISTORY"),
  getHistoryById
);
historyRouter.put(
  "/:id",
  authentication,
  authorization("ADD_HISTORY"),
  updateHistoryById
);
historyRouter.delete(
  "/:id",
  authentication,
  authorization("ADD_HISTORY"),
  deleteHistoryById
);
module.exports = historyRouter;
