const express = require("express");
const { providers_functions } = require("../controllers/providers");
const providerRouter = express.Router();
const authentication=require("../middlewares/authentication")
providerRouter.post("/", providers_functions.CreateNewProvider);

providerRouter.get("/byId/:id", providers_functions.getProviderById);
providerRouter.get(
  "/byCategory/:category",
  providers_functions.getProviderByCategoryId
);

providerRouter.get("/byName/", providers_functions.getProviderByName);
providerRouter.get("/byGender/", providers_functions.getProviderByGender);
providerRouter.get("/all",authentication, providers_functions.GetALLProviders); //authorizaion
providerRouter.get("/all/count", providers_functions.countProviderById);

providerRouter.delete("/:id", providers_functions.deleteProviderById);

module.exports = providerRouter;
