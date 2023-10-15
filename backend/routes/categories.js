const express = require("express");
const authentication = require("../middlewares/authentication");
const authorization = require("../middlewares/authorization");
const { categories } = require("../controllers/categories");
const categoriesRouter = express.Router();
categoriesRouter.post(

  "/", categories.createNewCategory

);

categoriesRouter.put(
  "/update/:id",
categories.UpdateCategorybyId
);
categoriesRouter.delete(
  "/delete/:id",
 categories.DeleteCategorybyId
);
categoriesRouter.get("/",categories.getAllCategories);
categoriesRouter.get("/countAllCategories",authentication ,categories.countAllCategories)
module.exports = categoriesRouter;
