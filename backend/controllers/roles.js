// const { response } = require("express");
const client = require("../models/db");

const createNewRole = (req, res) => {
  const { role } = req.body;

  const query = `INSERT INTO roles (role) VALUES ($1) RETURNING *`;
  const data = [role];
  client
    .query(query, data)
    .then((result) => {
      res.status(201).json({
        success: true,
        message: "Role created successfully",
        result: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: `Server error`,
        err: err,
      });
    });
};

const getAllRoles = (req,res)=>{
    const query = `SELECT * FROM roles `;
    client.query(query).then((result)=>{
        res.status(201).json({
            success: true,
            message: "All Role",
            result: result.rows,
          });
    }).catch((err)=>{
        res.status(500).json({
            success: false,
            message: `Server error`,
            err: err,
          });
    })
}

module.exports = {
    createNewRole,
    getAllRoles
}