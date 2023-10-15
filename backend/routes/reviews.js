const express = require("express");
const {
  addNewReviews,
  getAllReview,
  getReviewByProviderId,
  updateReviewByUserId,
  deleteReviewById,
} = require("../controllers/reviews");

const reviewsRouter = express.Router();
const authentication = require("../middlewares/authentication");
const authorization = require("../middlewares/authorization");

reviewsRouter.post(
  "/",
  authentication,
  authorization("ADD_HISTORY"),
  addNewReviews
);
reviewsRouter.get("/", authentication, getAllReview);
reviewsRouter.get("/provider/:id", authentication, getReviewByProviderId);
reviewsRouter.put(
  "/user/:id",
  authentication,
  authorization("ADD_HISTORY"),
  updateReviewByUserId
);
reviewsRouter.delete(
  "/:id",
  authentication,
  authorization("ADD_HISTORY"),
  deleteReviewById
);

module.exports = reviewsRouter;
