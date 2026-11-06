require('dotenv').config();
const express = require('express');
const produkRoutes = require('./routes/produk');
const umkmRoutes = require('./routes/umkm');

const app = express();
app.use(express.json());

app.get('/', (req, res) => res.json({ message: 'Desantara API berjalan' }));
app.use('/api/produk', produkRoutes);
app.use('/api/umkm', umkmRoutes);

app.use((req, res) => res.status(404).json({ message: 'Route tidak ditemukan' }));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server berjalan di http://localhost:${PORT}`));
