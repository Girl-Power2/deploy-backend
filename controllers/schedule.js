const client = require("../models/db");

const schedule = {};

// =====================CREAT NEW SCHEDULE==================
schedule.createNewSchedule = async (req, res) => {
  const providerId = req.token.providerId;

  const { DATE, time_from, time_to } = req.body;
  const values = [providerId, time_from, time_to, DATE];
  const query = `INSERT INTO schedules (provider_id,time_from,time_to,DATE ) VALUES ($1,$2,$3,$4) RETURNING *;`;

  try {

    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(201).json({
        status: true,
        message: `Schedule created successfully`,
        data: response.rows,
      });
    }
  } catch (error) {
    res.status(500).json({
      status: false,
      message: "Server Error",
      error: error.message,
    });
  }
};

// =====================Update chosen in schedule by id =============
schedule.UpdateChosen = async (req, res) => {
  const { id } = req.params;
  const values = [id];
  const query = `UPDATE schedules SET chosen= NOT chosen ,is_viewed=0 WHERE schedule_id=$1 AND is_viewed=1 RETURNING *`;
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(201).json({
        status: true,
        message: `Schedule chosen by the provider `,
        data: response.rows,
      });
    } else {
      res.status(201).json({
        status: false,
        message: `Schedule not found`,
      });
    }
  } catch (error) {

    res.status(500).json({
      status: false,
      message: "Server Error",
      error: error.message,
    });
  }
};
// =====================Update booked in schedule by id =============
schedule.UpdateBooked = async (req, res) => {
  const { schedule_id} = req.body;
  const values = [schedule_id];
  const query = `UPDATE schedules SET booked='true', is_viewed=0 WHERE schedule_id=$1 RETURNING *`;
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(201).json({
        status: true,
        message: `Schedule booked by the user`,
        data: response.rows,
      });
    } else {
      res.status(201).json({
        status: false,
        message: `Schedule not found`,
      });
    }
  } catch (error) {

    res.status(500).json({
      status: false,
      message: "Server Error",
      error: error.message,
    });
  }
};

// =====================update is deleted based on chosen & booked =============
schedule.UpdateIs_viewedIfBooked = async (req, res) => {
  const { id } = req.params;
  const values = [id];
  const query = `UPDATE schedules SET is_viewed=1  WHERE schedule_id=$1 AND booked=true AND chosen=true RETURNING *`;
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(201).json({
        status: true,
        message: `Appointment booked successfully`,
        data: response.rows,
      });
    }
    if (!response.rows.chosen) {
      res.status(201).json({
        status: false,
        message: `Appointment not available for this provider`,
      });
    } else {
      res.status(201).json({
        status: false,
        message: `Appointment not booked`,
      });
    }
  } catch (error) {
    res.status(500).json({
      status: false,
      message: "Server Error",
      error: error.message,
    });
  }
};

// =====================get schedule by is_deleted=============
schedule.getNotDeleted = async (req, res) => {
  const { provider_id } = req.query;
  const values = [provider_id];
  const query = `SELECT * FROM schedules WHERE is_viewed=0 AND  provider_id=$1`;
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(200).json({
        status: true,
        message: "Available appointments",
        data: response.rows,
      });
    } else {
      res.status(404).json({
        status: false,
        message: " This provider has no available appointments",
      });
    }
  } catch (error) {
    res.status(500).json({
      status: false,
      message: " Server Error",
      error: error.message,
    });
  }
};
// =====================get schedule by provider Id=============
schedule.getByProviderId = async (req, res) => {

  const provider_id  = req.params.id;
  const values = [provider_id];
  const query = `SELECT providers.fName,providers.lName,providers.provider_id,schedules.time_from,schedules.time_to,schedules.date,schedules.is_deleted,schedules.booked,schedules.chosen,schedules.schedule_id FROM schedules INNER JOIN providers ON schedules.provider_id=providers.provider_id WHERE schedules.provider_id=$1 AND schedules.is_deleted=0`

 
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(200).json({
        status: true,
        message: "All available appointments for the provider",
        data: response.rows,
      });
    } else {
      res.status(404).json({
        status: false,
        message: " This provider has no appointments",
      });
    }
  } catch (error) {
    res.status(500).json({
      status: false,
      message: " Server Error",
      error: error.message,
    });
  }
};

//=======================getNotBookedSchdual=================

schedule.getNotBookedSchdual = async (req, res) => {

  const provider_id  = req.params.id;
  const values = [provider_id];
  const query = `SELECT providers.fName,providers.lName,providers.provider_id,schedules.time_from,schedules.time_to,schedules.date,schedules.is_deleted,schedules.booked,schedules.chosen,schedules.schedule_id FROM schedules INNER JOIN providers ON schedules.provider_id=providers.provider_id WHERE schedules.provider_id=$1 AND schedules.is_deleted=0 AND booked='false'`

 
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(200).json({
        status: true,
        message: "All available appointments for the provider",
        data: response.rows,
      });
    } else {
      res.status(404).json({
        status: false,
        message: " This provider has no appointments",
      });
    }
  } catch (error) {
    res.status(500).json({
      status: false,
      message: " Server Error",
      error: error.message,
    });
  }
};



























// =====================get booked count by provider Id=============
schedule.getBookedCountByProviderId = async (req, res) => {
  const { provider_id } = req.params;
  const values = [provider_id];
  const query = `
    SELECT providers.fName,providers.lName,providers.provider_id ,COUNT(schedules.schedule_id) AS bookedCount FROM schedules INNER JOIN providers ON schedules.provider_id=providers.provider_id WHERE booked=true AND schedules.is_deleted=0 AND schedules.provider_id=$1
    group by providers.fName,providers.lName,providers.provider_id ;
    `;
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(200).json({
        status: true,
        message: "All booked appointments for the provider",
        data: response.rows,
      });
    } else {
      res.status(404).json({
        status: false,
        message: " This provider has no booked appointments",
      });
    }
  } catch (error) {
    res.status(500).json({
      status: false,
      message: " Server Error",
      error: error.message,
    });
  }
};
// =====================delete schedule by provider Id=============
// sch id
schedule.deleteByScheduleId = async (req, res) => {
  const { schedule_id } = req.params;
  const values = [schedule_id];
  const query = `UPDATE schedules SET is_deleted=1 
     WHERE schedule_id=$1 Returning * `;
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(200).json({
        status: true,
        message: "schedule deleted successfully",
        data: response.rows,
      });
    } else {
      res.status(404).json({
        status: false,
        message: "This provider has no schedules",
      });
    }
  } catch (error) {
    res.status(500).json({
      status: false,
      message: " Server Error",
      error: error.message,
    });
  }
};
// =====================get all schedules=============
schedule.getAllSchedules = async (req, res) => {
  const query = `SELECT providers.fName,providers.lName,providers.provider_id,schedules.time_from,schedules.time_to,schedules.is_deleted,schedules.booked,schedules.chosen FROM schedules INNER JOIN providers ON schedules.provider_id=providers.provider_id WHERE schedules.is_deleted=0 AND providers.is_deleted=0 `;
  try {
    const response = await client.query(query);
    if (response.rowCount) {
      res.status(200).json({
        status: true,
        message: "All  schedules ",
        data: response.rows,
      });
    }
  } catch (error) {
    res.status(500).json({
      status: false,
      message: " Server Error",
      error: error.message,
    });
  }
};

module.exports = { schedule };
