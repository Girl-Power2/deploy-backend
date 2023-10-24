const { query } = require("express");
const pool = require("../models/db");

const addNewReviews = (req, res) => {
  const { provider_id, review } = req.body;
  const user_id = req.token.userId;
  const query = `INSERT INTO reviews (review,provider_id,user_id)
VALUES ($1,$2,$3) RETURNING *;`;
  const value = [review, provider_id, user_id];
  pool
    .query(query, value)
    .then((result) => {
      res.status(201).json({
        success: true,
        message: "Reviews Created Successfully",
        result: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "Server Error",
        error: err.message,
      });
    });
};

const getAllReview = (req, res) => {
  const query = `SELECT * FROM  reviews`;

  pool
    .query(query)
    .then((result) => {
      res.status(200).json({
        success: true,
        message: "All Reviews",
        result: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "Server Error",
        error: err.message,
      });
    });
};

const getReviewByProviderId = (req, res) => {
  const id = req.params.id;
  const query = `SELECT *
    FROM reviews
    INNER JOIN providers
    ON reviews.provider_id = providers.provider_id 
    INNER JOIN users
    ON reviews.user_id = users.user_id WHERE reviews.provider_id=${id} AND reviews.is_deleted=0 ;`;

  pool
    .query(query)
    .then((result) => {
      res.status(200).json({
        success: true,
        message: `All Reviews For Provider=${id}`,
        result: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "Server Error",
        error: err.message,
      });
    });
};

const updateReviewByUserId = (req, res) => {
  const id = req.params.id;
  const user_id = req.token.userId;
  const { review } = req.body;
  const query = `UPDATE reviews
    SET review=COALESCE($1,review)
    WHERE review_id=${id} AND user_id=${user_id} RETURNING *;`;
  const value = [review || null];

  pool
    .query(query, value)
    .then((result) => {
      res.status(201).json({
        success: true,
        message: `Reviews Updated Successfully`,
        result: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "Server Error",
        error: err.message,
      });
    });
};

const deleteReviewById = (req, res) => {
  const id = req.params.id;
  const user_id = req.token.userId;
  const query = `UPDATE reviews
    SET is_deleted = 1
    WHERE review_id=${id} AND user_id=${user_id}  RETURNING *;`;

  pool
    .query(query)
    .then((result) => {
      res.status(200).json({
        success: true,
        message: `Reviews deleted Successfully`,
        result: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "Server Error",
        error: err.message,
      });
    });
};
module.exports = {
  addNewReviews,
  getAllReview,
  getReviewByProviderId,
  updateReviewByUserId,
  deleteReviewById,
};

