const { query } = require("express");
const pool = require("../models/db");

const creatNewOrder = (req, res) => {
  const { service_id, provider_id,schedule_id,adress } = req.body;
const user_id = req.token.userId
  const query = `INSERT INTO orders  (service_id, provider_id,user_id,schedule_id,adress) VALUES ($1,$2,$3,$4,$5) RETURNING *`;
  const value = [service_id, provider_id, user_id,schedule_id,adress];

  pool
    .query(query, value)
    .then((result) => {
      res.status(200).json({
        success: true,
        message: "order created successfully",
        result: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "server error",
        error: err.message,
      });
    });
};

const getAllOrders = (req, res) => {
  const id = req.token.userId
  const query = `SELECT * FROM orders  INNER JOIN users
  ON orders.user_id = users.user_id WHERE orders.user_id=${id}`;

  pool
    .query(query)
    .then((result) => {
      res.status(201).json({
        success: true,
        message: `all order for user_id=${id}`,
        result: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "server error",
        error: err.message,
      });
    });
};

const getOrderById = (req, res) => {
  const id = req.params.id;
  const query = `SELECT * FROM orders INNER JOIN users
  ON orders.user_id = users.user_id INNER JOIN services ON orders.service_id= services.service_id WHERE orders.order_id=${id}`;
  pool
    .query(query)
    .then((result) => {
      res.status(201).json({
        success: true,
        message: `order_id = ${id} `,
        result: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "server error",
        error: err.message,
      });
    });
};

const getOrderByUserId = (req, res) => {
  const id =req.params.id
  const user_id = req.token.userId;
  const query = `SELECT * FROM orders INNER JOIN users
  ON orders.user_id = users.user_id INNER JOIN providers ON orders.provider_id = providers.provider_id WHERE orders.user_id=${user_id} AND orders.order_id=${id}`;
  pool
    .query(query)
    .then((result) => {
      res.status(201).json({
        success: true,
        message: `user_id = ${user_id} `,
        result: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "server error",
        error: err.message,
      });
    });
};
// `SELECT * FROM orders INNER JOIN users
//   ON orders.user_id = users.user_id WHERE provider_id=${id} and orders.status='Done'`;

const getOrderByProviderId = (req, res) => {
  const id = req.params.id;
  const {skip} = req.query
  const query = `SELECT *
  FROM ORDERS
  INNER JOIN SCHEDULES ON SCHEDULEs.PROVIDER_ID = ORDERS.PROVIDER_ID
  INNER JOIN users ON orders.user_id =users.user_id
  INNER JOIN services ON orders.service_id =services.service_id
  WHERE orders.PROVIDER_ID = ${id}
    AND ORDERS.STATUS = 'Done' order by orders.created_at DESC
    limit 3 Offset ${skip}`
  pool
    .query(query)
    .then((result) => {
      res.status(201).json({
        success: true,
        message: `provider_id = ${id} `,
        result: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "server error",
        error: err.message,
      });
    });
};

const getAllOrderDone= (req, res) => {
const id =req.token.userId
const {pageNumber} = req.query
const limit=5
const OFFSET=(pageNumber-1)*limit
const value = [OFFSET,limit]
  const query = `SELECT users.firstname , users.lastname , users.city,users.email
  ,providers.fname ,providers.lname , providers.phonenumber , services.service , schedules.time_from ,schedules.time_to , services.price_per_hour ,schedules.date , orders.adress,orders.order_id  FROM orders INNER JOIN users ON orders.user_id = users.user_id  INNER JOIN providers ON orders.provider_id= providers.provider_id INNER JOIN services ON orders.service_id= services.service_id INNER JOIN schedules ON orders.schedule_id =schedules.schedule_id  WHERE orders.status='Done' AND  users.user_id=${id} ORDER BY orders.order_id ASC LIMIT $2 OFFSET $1 `;
  pool
    .query(query,value)
    .then((result) => {
      res.status(201).json({
        success: true,
        message: `All Previus Orders  `,
        result: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "server error",
        error: err.message,
      });
    });
};

const getAllOrderPending= (req, res) => {
const id = req.token.userId
  const query = `SELECT users.firstname , users.lastname , users.city,users.email
  ,providers.fname ,providers.lname , providers.phonenumber , services.service , schedules.time_from ,schedules.time_to , services.price_per_hour ,schedules.date , orders.adress,orders.order_id  FROM orders INNER JOIN users ON orders.user_id = users.user_id  INNER JOIN providers ON orders.provider_id= providers.provider_id INNER JOIN services ON orders.service_id= services.service_id INNER JOIN schedules ON orders.schedule_id =schedules.schedule_id  WHERE orders.status ='pending' AND  users.user_id=${id}`;
  pool
    .query(query)
    .then((result) => {
      res.status(201).json({
        success: true,
        message: `All Orders `,
        result: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "server error",
        error: err.message,
      });
    });
};





const updateOrederById = (req, res) => {
  const order_id = req.params.orderId;
  const query = `UPDATE orders
    SET status = 'Done'
    WHERE order_id=${order_id} RETURNING *;`;

  pool
    .query(query)
    .then((result) => {
      res.status(201).json({
        success: true,
        message: `order was updated `,
        result: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "server error",
        error: err.message,
      });
    });
};

const deleteOrederById = (req, res) => {
  const id = req.params.id;
  const query = `UPDATE orders
    SET is_deleted = 1
    WHERE order_id=${id} RETURNING *;`;

  pool
    .query(query)
    .then((result) => {
      res.status(201).json({
        success: true,
        message: `order was deleted `,
        result: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "server error",
        error: err.message,
      });
    });
};

const countAllOrdersForProvider=(req,res)=>{
  const id = req.params.id;
  const query = `SELECT COUNT(order_id) 
  FROM orders WHERE provider_id=$1 AND status = 'Done'`;
const value=[id]

  pool
    .query(query,value)
    .then((result) => {
      res.status(201).json({
        success: true,
        message: `Count All Order For Provider = ${id}`,
        result: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "server error",
        error: err.message,
      });
    });
}

module.exports = {
  creatNewOrder,
  getAllOrders,
  getOrderById,
  getOrderByUserId,
  getOrderByProviderId,
  deleteOrederById,
  updateOrederById,
  getAllOrderDone,
  getAllOrderPending,
  countAllOrdersForProvider
};
