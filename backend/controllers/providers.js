const client = require("../models/db");
const providers_functions = {};
const bcrypt = require("bcrypt");
//=============== CREATE NEW PROVIDER ================
providers_functions.CreateNewProvider = async (req, res) => {
  const {
    fName,
    lName,
    birthDate,
    gender,
    email,
    password,
    city,
    phoneNumber,
    category_id,
  } = req.body;

  const role_id = 3;
  const Hashed_password = await bcrypt.hash(password, 7);

  const values = [
    fName,
    lName,
    birthDate,
    gender,
    email,
    Hashed_password,
    city,
    phoneNumber,
    role_id,
    category_id,
  ];
  const query = `INSERT INTO providers  (fName,
  lName,
  birthDate,
  gender,
  email,
  password,
  city,
  phoneNumber,
  role_id,
  category_id) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) RETURNING *`;
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(201).json({
        success: true,
        message: "Provider account created successfully",
        response: response.rows,
      });
    }
  } catch (error) {
    if (error.constraint === "providers_email_key") {
      res.status(409).json({
        success: false,
        message: "The email already exists",
      })}
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
  }
};

// ===============get provider by id================
providers_functions.getProviderById = async (req, res) => {
  const id = req.params.id;
  const values = [id];
  const query = `SELECT * FROM  providers WHERE provider_id=$1 AND is_deleted=0`;
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
        message: "Provider not found",
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
// ===============Countprovider by id================
providers_functions.countProviderById = async (req, res) => {
  const query = `
  SELECT 
    COUNT(*) AS numberOfProviders
  FROM providers
  
  WHERE 
     IS_DELETED = 0`;
  try {
    const response = await client.query(query);
    if (response.rowCount) {
      res.status(200).json({
        status: true,
        data: response.rows,
      });
    } else {
      res.status(404).json({
        status: false,
        message: "Providers not found",
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
// ===============delete provider by id================
providers_functions.deleteProviderById = async (req, res) => {
  const id = req.params.id;
  const values = [id];
  const query = `UPDATE providers SET is_deleted=1 WHERE provider_id=$1 AND is_deleted=0 RETURNING *`;
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(200).json({
        status: true,
        message: "Provider deleted successfully",
        data: response.rows,
      });
    } else {
      res.status(404).json({
        status: false,
        message: "Provider not found",
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
// ===============get provider by  category_id================
providers_functions.getProviderByCategoryId = async (req, res) => {
  const id = req.params.category;
  const values = [id];
  const query = `SELECT * FROM  providers WHERE category_id=$1 AND is_deleted=0`;
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
        message: "No providers in this category yet",
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

// ===============get provider by name================
providers_functions.getProviderByName = async (req, res) => {
  const { fname } = req.query;

  const values = [fname.toLowerCase() + "%"];
  const query = `SELECT * FROM  providers INNER JOIN categories ON providers.category_id = categories.category_id WHERE fname LIKE $1 OR lname LIKE $1 ;`;

  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(200).json({
        status: true,
        data: response.rows,
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

// ===============get provider by gender================
providers_functions.getProviderByGender = async (req, res) => {
  const { gender } = req.query;

  const values = [gender];
  const query = `SELECT * FROM  providers WHERE gender=$1 AND is_deleted=0`;
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(200).json({
        status: true,
        data: response.rows,
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

// ===============get  all providers================
providers_functions.GetALLProviders = (req, res) => {
  const {skip} = req.query  

  const query = `SELECT *
  FROM PROVIDERS
  INNER JOIN CATEGORIES ON PROVIDERS.CATEGORY_ID = CATEGORIES.CATEGORY_ID
  group by PROVIDERS.PROVIDER_ID,CATEGORIES.CATEGORY_ID
   order BY 
    PROVIDERS.PROVIDER_ID ASC
  limit 5 offset ${skip};
  SELECT COUNT(order_id) ,PROVIDER_ID
  FROM orders WHERE status = 'Done'
  group by orders.PROVIDER_ID
   order BY 
    PROVIDER_ID ASC
  limit 5 offset ${skip};
  SELECT 
	COUNT(SERVICE_ID) AS NUMBEROFSERVICES,providers.provider_id
FROM PROVIDERS
INNER JOIN SERVICES ON SERVICES.PROVIDER_ID = PROVIDERS.PROVIDER_ID
group by PROVIDERS.PROVIDER_ID
  order BY 
    PROVIDERS.PROVIDER_ID ASC
  limit 5 offset ${skip}
    ;`
    

  client
    .query(query)
    .then((result) => {


      res.status(201).json({
        success: true,
        message: ` ALL providers `,
        providers: result[0].rows,
        orders:result[1].rows,
        services:result[2].rows
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

module.exports = { providers_functions };
