const express = require("express");
const { RolePermission } = require("../controllers/role_permissions");

const role_permissionsRouter = express.Router();

role_permissionsRouter.post("/", RolePermission.createNewRolePermission);
role_permissionsRouter.get("/", RolePermission.GetALLRolePermission);
role_permissionsRouter.delete("/:id", RolePermission.DeleteRolePermissionById);

module.exports = role_permissionsRouter;
