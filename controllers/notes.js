const client = require("../models/db");
const notes = {};

// ===============ADD NOTE=============
notes.AddNote = async (req, res) => {
  const provider_id = req.token.providerId;
  const { user_id, note } = req.body;
  const values = [provider_id, user_id, note];
  const query = `INSERT INTO provider_notes (provider_id, user_id,note) VALUES ($1,$2,$3) RETURNING *;`;

  try {
    const response = await client.query(query, values);

    if (response.rowCount) {
      res.status(201).json({
        status: true,
        message: "Note added successfully",
        data: response.rows,
      });
    }
  } catch (error) {
    res.status(500).json({
      status: false,
      message: "Server error",
      error: error.message,
    });
  }
};
// ===============DELETE NOTE=============
notes.DeleteNote = async (req, res) => {
  const provider_id = req.token.providerId;

  const { id } = req.params;
  const values = [provider_id, id];
  const query = `UPDATE provider_notes SET is_deleted=1 WHERE provider_id=$1  AND provider_note_id=$2 RETURNING *;`;

  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(201).json({
        status: true,
        message: "Note deleted successfully",
        data: response.rows,
      });
    }
  } catch (error) {
    res.status(500).json({
      status: false,
      message: "Server error",
      error: error.message,
    });
  }
};

// ===============GET NOTE=============
notes.GetNotebyProviderId = async (req, res) => {
  const provider_id = req.token.providerId;
  const values = [provider_id];
  const query = `SELECT * from provider_notes INNER JOIN providers ON provider_notes.provider_id=providers.provider_id INNER JOIN users ON provider_notes.user_id=users.user_id WHERE provider_notes.provider_id=$1 AND provider_notes.is_deleted=0  ;`;
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(201).json({
        status: true,
        message: `Your notes`,
        data: response.rows,
      });
    } else {
      res.status(404).json({
        status: false,
        message: `You don't have any notes yet `,
      });
    }
  } catch (error) {
    res.status(500).json({
      status: false,
      message: "Server error",
      error: error.message,
    });
  }
};
// ========================by userID and provider================================
notes.GetNotebyUserId = async (req, res) => {
  const provider_id = req.token.providerId;
  const { id } = req.query;
  const values = [provider_id, id];
  const query = `SELECT * from provider_notes INNER JOIN providers ON provider_notes.provider_id=providers.provider_id INNER JOIN users ON provider_notes.user_id=users.user_id WHERE provider_notes.provider_id=$1 and provider_notes.user_id=$2 and provider_notes.is_deleted=0;`;
  try {
    const response = await client.query(query, values);
    if (response.rowCount) {
      res.status(201).json({
        status: true,
        message: `All notes for the user`,
        data: response.rows,
      });
    } else {
      res.status(404).json({
        status: false,
        message: `No recorded notes for the user `,
      });
    }
  } catch (error) {
    res.status(500).json({
      status: false,
      message: "Server error",
      error: error.message,
    });
  }
};
// ========================by userID and provider================================

//   =====================Update NOTE =====================
notes.UpdateNote = async (req, res) => {
  const provider_id = req.token.providerId;
  const { note, user_id } = req.body;
  const id = req.params.id;
  const values = [note || null, user_id || null, provider_id, id];
  const query = `UPDATE provider_notes SET note=COALESCE($1,note) ,user_id=COALESCE($2,user_id) WHERE provider_note_id=$4 AND provider_id=$3 RETURNING *;`;
  try {
    const result = await client.query(query, values);
    if (result.rowCount) {
      res.status(200).json({
        success: true,
        message: "Note updated successfully",
        data: result.rows,
      });
    } else {
      res.status(404).json({
        status: false,
        message: `Note not found `,
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

module.exports = { notes };
