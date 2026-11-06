const express = require('express');
const pool = require('../db');

const router = express.Router();

function handleError(res, err) {
  if (err.code === '23505') return res.status(409).json({ message: 'id_user sudah memiliki UMKM' });
  if (err.code === '23503') {
    return res.status(409).json({ message: 'Data terkait tidak valid atau masih dipakai tabel lain (mis. produk)' });
  }
  res.status(500).json({ message: err.message });
}

// GET semua UMKM
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM umkm ORDER BY id_umkm');
    res.json({ message: 'Berhasil mengambil semua UMKM', data: result.rows });
  } catch (err) {
    handleError(res, err);
  }
});

// GET UMKM berdasarkan ID
router.get('/:id', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM umkm WHERE id_umkm = $1', [req.params.id]);
    if (result.rows.length === 0) return res.status(404).json({ message: 'UMKM tidak ditemukan' });
    res.json({ message: 'Berhasil mengambil UMKM', data: result.rows[0] });
  } catch (err) {
    handleError(res, err);
  }
});

// POST UMKM baru
router.post('/', async (req, res) => {
  const { id_user, nama_usaha, deskripsi, alamat, no_whatsapp, latitude, longitude } = req.body;
  if (!id_user || !nama_usaha || !alamat) {
    return res.status(400).json({ message: 'id_user, nama_usaha, dan alamat wajib diisi' });
  }
  try {
    const result = await pool.query(
      `INSERT INTO umkm (id_user, nama_usaha, deskripsi, alamat, no_whatsapp, latitude, longitude)
       VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
      [id_user, nama_usaha, deskripsi || null, alamat, no_whatsapp || null, latitude || null, longitude || null]
    );
    res.status(201).json({ message: 'UMKM berhasil dibuat', data: result.rows[0] });
  } catch (err) {
    handleError(res, err);
  }
});

// PUT update UMKM
router.put('/:id', async (req, res) => {
  const { nama_usaha, deskripsi, alamat, no_whatsapp, latitude, longitude } = req.body;
  try {
    const result = await pool.query(
      `UPDATE umkm SET
         nama_usaha  = COALESCE($1, nama_usaha),
         deskripsi   = COALESCE($2, deskripsi),
         alamat      = COALESCE($3, alamat),
         no_whatsapp = COALESCE($4, no_whatsapp),
         latitude    = COALESCE($5, latitude),
         longitude   = COALESCE($6, longitude)
       WHERE id_umkm = $7 RETURNING *`,
      [nama_usaha, deskripsi, alamat, no_whatsapp, latitude, longitude, req.params.id]
    );
    if (result.rows.length === 0) return res.status(404).json({ message: 'UMKM tidak ditemukan' });
    res.json({ message: 'UMKM berhasil diperbarui', data: result.rows[0] });
  } catch (err) {
    handleError(res, err);
  }
});

// DELETE UMKM
router.delete('/:id', async (req, res) => {
  try {
    const result = await pool.query('DELETE FROM umkm WHERE id_umkm = $1 RETURNING *', [req.params.id]);
    if (result.rows.length === 0) return res.status(404).json({ message: 'UMKM tidak ditemukan' });
    res.json({ message: 'UMKM berhasil dihapus', data: result.rows[0] });
  } catch (err) {
    handleError(res, err);
  }
});

module.exports = router;
