const express = require("express");
require("dotenv").config();
const cors = require("cors");
require("./models/db");


//routers

const role_permissionsRouter = require("./routes/role_permissions");
const rolesRouter = require("./routes/roles");
const permissionsRouter = require("./routes/permissions");
const usersRouter = require("./routes/users");
const categoriesRouter = require("./routes/categories");
const orderRouter = require("./routes/orders");
const providerRouter = require("./routes/providers");
const serviceRouter = require("./routes/services");
const reviewsRouter = require("./routes/reviews");
const historyRouter=require("./routes/history")
const scheduleRouter=require("./routes/schedule");
const infoRouter = require("./routes/provider_info");
const noteRouter = require("./routes/notes");




const app = express();

//built-in middleware
app.use(express.json());
app.use(cors());

// router middleware
app.use("/role_permissions", role_permissionsRouter);
app.use("/roles", rolesRouter);
app.use("/permissions", permissionsRouter);
app.use("/users", usersRouter);
app.use("/categories", categoriesRouter);
app.use("/reviews" ,reviewsRouter)
app.use("/orders", orderRouter);
app.use("/providers", providerRouter);
app.use("/services", serviceRouter);
app.use("/history",historyRouter)
app.use("/schedules",scheduleRouter)
app.use("/provider_info",infoRouter)
app.use("/notes",noteRouter)


// const PORT = 5000;

// Handles any other endpoints [unassigned - endpoints]
app.use("*", (req, res) =>{
  res.status(404).json("NO content at this path")
} );



const PORT = process.env.PORT || 5000;


app.listen(PORT, () => {
  console.log(`server on ${PORT}`);
});
