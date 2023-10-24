const express=require("express")
const authentication=require("../middlewares/authentication")
const authorization=require("../middlewares/authorization")
const{services}=require("../controllers/services")
const serviceRouter=express.Router()
serviceRouter.post("/",authentication,services.createNewService)
serviceRouter.get("/byId/:id",authentication,services.getServiceByProviderId)
serviceRouter.get("/byName",services.getServiceByName)
serviceRouter.get("/price_DESC/:provider_id",services.getServiceByPriceDes)
serviceRouter.get("/price_ASC/:providerId",authentication,services.getServiceByPriceAsc)
serviceRouter.get("/all",services.GetALLServices)
serviceRouter.get("/all/count",services.countServiceById)

serviceRouter.put("/byId/:id",authentication,services.UpdateService)
serviceRouter.delete("/:id",authentication,services.deleteServiceById)








module.exports=serviceRouter