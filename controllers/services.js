const client = require("../models/db");
const services = {};

// =========create new service===========
services.createNewService = async (req, res) => {
  const { service, price_per_hour } = req.body;
  const provider_id = req.token.providerId;
  const values = [service, price_per_hour, provider_id];
  const query = `INSERT INTO services (service,price_per_hour,provider_id) VALUES ($1,$2,$3) RETURNING *`;
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(201).json({
        status: true,
        message: "Service added successfully",
        data: response.rows,
      });
    }
  } catch (error) {
    res.status(500).json({
      message: "Server Error",
      error: error.message,
    });
  }
};
// =========get service by provider id===========
services.getServiceByProviderId = async (req, res) => {
  const provider_id = req.params.id;
  const values = [provider_id];
  const query = `SELECT providers.fName,providers.lName ,services.service, services.price_per_hour,services.service_id FROM services INNER JOIN providers ON services.provider_id=providers.provider_id WHERE services.provider_id=$1 AND providers.is_deleted=0  AND services.is_deleted=0 `;
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(200).json({
        status: true,
        message: `The services of the provider ${response.rows[0].fname}`,
        data: response.rows,
      });
    } else {
      res.status(404).json({
        status: false,
        message: `Provider not found`,
      });
    }
  } catch (error) {
    res.status(500).json({
      message: "Server Error",
      error: error.message,
    });
  }
};
// =========get service by price desc===========
services.getServiceByPriceDes = async (req, res) => {
  const id =req.params.provider_id
  const query = `SELECT * FROM services WHERE provider_id=${id} ORDER BY price_per_hour DESC;`;
  try {
    const response = await client.query(query);
    if (response.rowCount) {
      res.status(200).json({
        status: true,
        message: `services ordered descendingly`,
        data: response.rows,
      });
    }
  } catch (error) {
    res.status(500).json({
      message: "Server Error",
      error: error.message,
    });
  }
};
// =========get service by price asc===========
services.getServiceByPriceAsc = async (req, res) => {
  const id = req.params.providerId
  const query = `SELECT * FROM services WHERE provider_id=${id} ORDER BY price_per_hour ASC ;`;
  try {
    const response = await client.query(query);
    if (response.rowCount) {
      res.status(200).json({
        status: true,
        message: `services ordered ascendingly`,
        data: response.rows,
      });
    }
  } catch (error) {
    res.status(500).json({
      message: "Server Error",
      error: error.message,
    });
  }
};
// ===============Countprovider by id================
services.countServiceById = async (req, res) => {
  const query = `
  SELECT 
    COUNT(*) AS numberOfservices
  FROM services
  
  WHERE 
     IS_DELETED = 0`;
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
        message: "Services not found",
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
// =========get service by name===========
services.getServiceByName = async (req, res) => {
  const { name } = req.query;
  const values = ["%" + name + "%"];
  const query = `SELECT * FROM services WHERE service ILIKE $1;`;//iiner join providers with service id
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(200).json({
        status: true,
        message: `services from search`,
        data: response.rows,
      });
    } else {
      res.status(404).json({
        status: false,
        message: `Service not found`,
      });
    }
  } catch (error) {
    res.status(500).json({
      message: "Server Error",
      error: error.message,
    });
  }
};
// =========get all services===========

services.GetALLServices = (req, res) => {
  const query = `SELECT * FROM services;`;

  client
    .query(query)
    .then((result) => {
      res.status(201).json({
        success: true,
        message: ` ALL services `,
        data: result.rows,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: `Server error`,
        err: err.message,
      });
    });
};
//
services.UpdateService = async (req, res) => {
  const provider_id = req.token.providerId;
  const { service, price_per_hour } = req.body;
  const id = req.params.id;
  const values = [service || null, price_per_hour || null, provider_id, id];
  const query = `UPDATE services SET service=COALESCE($1,service) ,price_per_hour=COALESCE($2,price_per_hour) WHERE service_id=$4 AND provider_id=$3 RETURNING *;`;
  try {
    const result = await client.query(query, values);
    if (result.rowCount) {
      res.status(200).json({
        success: true,
        message: "Service updated successfully",
        data: result.rows,
      });
    } else {
      res.status(404).json({
        status: false,
        message: `Service not found `,
        error: error.message,
      });
    }
  } catch (err) {
    res.status(500).json({
      success: false,
      message: "Server error",
      err: err.message,
    });
  }
};
services.deleteServiceById = (req, res) => {
  const id = req.params.id;
  const provider_id = req.token.providerId;
  values = [id, provider_id];
  const query = `UPDATE services
    SET is_deleted = 1
    WHERE service_id=$1 AND provider_id=$2;`;
  client
    .query(query, values)
    .then((result) => {
      res.status(201).json({
        success: true,
        message: `Service deleted successfully`,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "server error",
        err: err.message,
      });
    });
};
module.exports = { services };
