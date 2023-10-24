const pool=require ("../models/db")
const RolePermission={}
// ==================ADD NEW ROLE_PERMISSION===================
RolePermission.createNewRolePermission = (req, res) => {
    const { role_id, permission_id } = req.body;
    const query = `INSERT INTO role_permissions (role_id,
      permission_id) VALUES ($1,$2) RETURNING *`;
    const data = [role_id, permission_id];
  
    pool
      .query(query, data)
      .then((result) => {
        res.status(201).json({
          success: true,
          message: ` Role Permission created successfully`,
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
// ================== Get ALL Role Permissions===================

  RolePermission.GetALLRolePermission = (req, res) => {
    const query = `SELECT * FROM role_permissions;`;
  
    pool
      .query(query)
      .then((result) => {
        res.status(201).json({
          success: true,
          message: ` ALL Role Permissions `,
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

// ================== Delete Role Permission By Id===================
RolePermission.DeleteRolePermissionById=async(req,res)=>{
  const id=req.params.id
const values=[id]
const query=`DELETE FROM role_permissions WHERE role_permission_id =$1 RETURNING *`
try {
  const response=await client.query(query,values)
  if(response.rowCount){
    res.status(200).json({
      status:true,
      message:"ROLE_PERMISSION deleted",
      data:response.rows
    })
  }
} catch (error) {
  res.status(500).json({
    success: false,
    message: `Server error`,
    err: err.message,
  });
}
}

  module.exports = {RolePermission}
