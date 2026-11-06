const express = require('express');
const pool = require('../db');

const router = express.Router();

// GET semua produk
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM produk ORDER BY id_produk');
    res.json({ message: 'Berhasil mengambil semua produk', data: result.rows });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// GET produk berdasarkan ID
router.get('/:id', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM produk WHERE id_produk = $1', [req.params.id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Produk tidak ditemukan' });
    }
    res.json({ message: 'Berhasil mengambil produk', data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// POST produk baru
router.post('/', async (req, res) => {
  const { id_umkm, id_kategori, nama_produk, deskripsi, harga, stok, foto_url } = req.body;
  if (!id_umkm || !nama_produk || harga === undefined) {
    return res.status(400).json({ message: 'id_umkm, nama_produk, dan harga wajib diisi' });
  }
  try {
    const result = await pool.query(
      `INSERT INTO produk (id_umkm, id_kategori, nama_produk, deskripsi, harga, stok, foto_url)
       VALUES ($1, $2, $3, $4, $5, COALESCE($6, 0), $7) RETURNING *`,
      [id_umkm, id_kategori || null, nama_produk, deskripsi || null, harga, stok, foto_url || null]
    );
    res.status(201).json({ message: 'Produk berhasil dibuat', data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// PUT update produk
router.put('/:id', async (req, res) => {
  const { id_kategori, nama_produk, deskripsi, harga, stok, foto_url } = req.body;
  try {
    const result = await pool.query(
      `UPDATE produk SET
         id_kategori = COALESCE($1, id_kategori),
         nama_produk = COALESCE($2, nama_produk),
         deskripsi   = COALESCE($3, deskripsi),
         harga       = COALESCE($4, harga),
         stok        = COALESCE($5, stok),
         foto_url    = COALESCE($6, foto_url)
       WHERE id_produk = $7 RETURNING *`,
      [id_kategori, nama_produk, deskripsi, harga, stok, foto_url, req.params.id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Produk tidak ditemukan' });
    }
    res.json({ message: 'Produk berhasil diperbarui', data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// DELETE produk
router.delete('/:id', async (req, res) => {
  try {
    const result = await pool.query('DELETE FROM produk WHERE id_produk = $1 RETURNING *', [req.params.id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Produk tidak ditemukan' });
    }
    res.json({ message: 'Produk berhasil dihapus', data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
