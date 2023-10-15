const client = require("../models/db");
const categories = {};
//===========Create new category==============
categories.createNewCategory = async (req, res) => {
  const { category, img } = req.body;

  const values = [category,img];
  const query = `INSERT INTO categories (category,img) VALUES ($1,$2) RETURNING *;`;
  try {
    const result = await client.query(query, values);

    if (result.rowCount) {
      res.status(200).json({
        success: true,
        message: "Category created successfully",
        data: result.rows,
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
//=========== update category by id ==============

categories.UpdateCategorybyId = async (req, res) => {
  const { category, img } = req.body;
  const id = req.params.id;
  const values = [category || null, id, img || null];
  const query = `UPDATE categories SET category=COALESCE($1,category) ,img=COALESCE($3,img) WHERE category_id=$2 AND is_deleted=0 RETURNING *;`;
  try {
    const result = await client.query(query, values);
    if (result.rowCount) {
      res.status(200).json({
        success: true,
        message: "Category updated successfully",
        data: result.rows,
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
//=========== delete category ==============
categories.DeleteCategorybyId = async (req, res) => {
  const id = req.params.id;
  const values = [id];
  const query = `UPDATE  categories SET is_deleted=1 WHERE category_id=$1 AND is_deleted=0 RETURNING *;`;
  try {
    const result = await client.query(query, values);
    if (result.rowCount) {
      res.status(200).json({
        success: true,
        message: "Category deleted successfully",
        data: result.rows,
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
//=========== get all categories==============
categories.getAllCategories = async (req, res) => {
  const query = `SELECT * FROM categories WHERE is_deleted=0 `;
  try {
    const response = await client.query(query);
    if (response.rowCount) {
      res.status(200).json({
        status: true,
        message: "All Categories",
        data: response.rows,
      });
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Server error",
      err: err.message,
    });
  }
};

categories.countAllCategories =(req,res)=>{
  const query =`SELECT COUNT(category_id) 
  FROM categories;`
  client.query(query).then((result)=>{
    res.status(201).json({
        success: true,
        message: "Count All Categories",
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

module.exports = { categories };
