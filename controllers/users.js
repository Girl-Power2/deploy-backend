const client = require("../models/db");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

const register = async (req, res) => {
  const {
    firstname,
    lastname,
    birthdate,
    city,
    email,
    password,
    phonenumber,
    gender,
    role_id,
  } = req.body;
  const encryptedPassword = await bcrypt.hash(password, 10);

  const query = `INSERT INTO users  (firstname ,lastname ,birthdate ,city ,email,password ,phonenumber ,gender,role_id) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING *`;
  const value = [
    firstname,
    lastname,
    birthdate,
    city,
    email.toLowerCase(),
    encryptedPassword,
    phonenumber,
    gender,
    role_id,
  ];


  try {
    const response = await client.query(query, value);
    if (response.rowCount) {
      res.status(201).json({
        success: true,
        message: "User account created successfully",
        response:response.rows
      });
    }
  } catch (error) {
    if (error.constraint === "users_email_key") {
      res.status(409).json({
        success: false,
        message: "The email already exists",
      });
    } 
    if (error.constraint === 'chk_email') {

      res.status(409).json({
        success: false,
        message: "The email you entered is not correct",
      });
    } 
    else {
      res.status(500).json({
        message: "Server Error",
        error: error.message,
      });
    }
  }}


const login = (req, res) => {
  const {password} = req.body;
  const {email} = req.body;
  const query = `SELECT * FROM users WHERE email = $1`;
  const data = [email.toLowerCase()];
  client
    .query(query, data)
    .then((result) => {
      if (result.rows) {
        
        bcrypt.compare(password, result.rows[0].password, (err, response) => {
          if (err) res.json(err);
         
          if (response) {
            const payload = {
              userId: result.rows[0].user_id,
              city: result.rows[0].city,
              role: result.rows[0].role_id,
            };
            const options = { expiresIn: "1d" };
            const secret = process.env.SECRET;
            const token = jwt.sign(payload, secret, options);
            if (token) {
              return res.status(200).json({
                token,
                success: true,
                message: `Valid login credentials`,
                userId: result.rows[0].user_id,
              });
            } else {
              throw Error;
            }
          } else {
         
            res.status(403).json({
              success: false,
              message: `The email doesn’t exist or the password you’ve entered is incorrect`,
            });
          }
        });
      } else throw Error;
    })
    .catch((err) => {
      res.status(403).json({
        success: false,
        message:
          "The email doesn’t exist or the password you’ve entered is incorrect",
        err,
      });

    });
};

//===================get user by id ======================//
const getUserById = async (req, res) => {
  const id = req.token.userId;
  const values = [id];
  const query = `SELECT *,AGE(birthdate)as age FROM  users WHERE user_id=$1 AND is_deleted=0`;
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(200).json({
        status: true,
        data: response.rows,
      });
    } else {
      res.status(404).json({
        status: false,
        message: "User not found",
      });
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Server Error",
      error: error.message,
    });
  }
};


// provider login
const Provider_login = (req, res) => {
  const password = req.body.password;
  const email = req.body.email;
  const query = `SELECT * FROM providers WHERE email = $1`;
  const data = [email.toLowerCase()];
  client
    .query(query, data)
    .then((result) => {
      if (result.rows.length) {
        bcrypt.compare(password, result.rows[0].password, (err, response) => {
          if (err) res.json(err);
          if (response) {
            const payload = {
              providerId: result.rows[0].provider_id,
              city: result.rows[0].city,
              role: result.rows[0].role_id,
            };
            const options = { expiresIn: "1d" };
            const secret = process.env.SECRET;
            const token = jwt.sign(payload, secret, options);
            if (token) {
              return res.status(200).json({
                token,
                success: true,
                message: `Valid login credentials`,
                providerId: result.rows[0].provider_id,
                role:result.rows[0].role_id,
               
              });
            } else {
              throw Error;
            }
          } else {
         
            res.status(403).json({
              success: false,
              message: `The email doesn’t exist or the password you’ve entered is incorrect`,
            });
          }
        });
      } else throw Error;
    })
    .catch((err) => {
      res.status(403).json({
        success: false,
        message:
          "The email doesn’t exist or the password you’ve entered is incorrect",
        err,
      });

    });
};

const countUser =(req,res)=>{
  const query =`SELECT COUNT(user_id) 
  FROM users ;`
  client.query(query).then((result)=>{
    res.status(201).json({
        success: true,
        message: "Count of users",
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
  register,
  login,
  Provider_login ,
  getUserById,
  countUser
};

