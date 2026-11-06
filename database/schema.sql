CREATE TABLE users (
id_user INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nama VARCHAR(100) NOT NULL,
email VARCHAR(150) NOT NULL UNIQUE,
password TEXT NOT NULL,
role VARCHAR(20) NOT NULL
CHECK (role IN ('admin', 'pemilik_umkm', 'pembeli')),
no_hp VARCHAR(20),
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE umkm (
id_umkm INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_user INTEGER NOT NULL UNIQUE,
nama_usaha VARCHAR(150) NOT NULL,
deskripsi TEXT,
alamat TEXT NOT NULL,
no_whatsapp VARCHAR(20),
latitude NUMERIC(10,7),
longitude NUMERIC(10,7),
CONSTRAINT fk_umkm_user FOREIGN KEY (id_user)
REFERENCES users(id_user) ON DELETE RESTRICT
);

CREATE TABLE kategori (
id_kategori INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nama_kategori VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE produk (
id_produk INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_umkm INTEGER NOT NULL,
id_kategori INTEGER,
nama_produk VARCHAR(150) NOT NULL,
deskripsi TEXT,
harga NUMERIC(12,2) NOT NULL CHECK (harga >= 0),
stok INTEGER NOT NULL DEFAULT 0 CHECK (stok >= 0),
foto_url TEXT,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_produk_umkm FOREIGN KEY (id_umkm)
REFERENCES umkm(id_umkm) ON DELETE RESTRICT,
CONSTRAINT fk_produk_kategori FOREIGN KEY (id_kategori)
REFERENCES kategori(id_kategori) ON DELETE SET NULL
);

CREATE TABLE keranjang (
id_keranjang INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_user INTEGER NOT NULL UNIQUE,
tanggal_dibuat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_keranjang_user FOREIGN KEY (id_user)
REFERENCES users(id_user) ON DELETE CASCADE
);

CREATE TABLE detail_keranjang (
id_detail_keranjang INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_keranjang INTEGER NOT NULL,
id_produk INTEGER NOT NULL,
jumlah INTEGER NOT NULL CHECK (jumlah > 0),
CONSTRAINT fk_detail_keranjang FOREIGN KEY (id_keranjang)
REFERENCES keranjang(id_keranjang) ON DELETE CASCADE,
CONSTRAINT fk_detail_produk FOREIGN KEY (id_produk)
REFERENCES produk(id_produk) ON DELETE RESTRICT,
CONSTRAINT uq_keranjang_produk UNIQUE (id_keranjang, id_produk)
);

CREATE TABLE pesanan (
id_pesanan INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_user INTEGER NOT NULL,
tanggal_pesanan TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
total_harga NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (total_harga >= 0),
status_pesanan VARCHAR(30) NOT NULL DEFAULT 'menunggu_pembayaran'
CHECK (status_pesanan IN
('menunggu_pembayaran', 'diproses', 'dikirim', 'selesai', 'dibatalkan')),
CONSTRAINT fk_pesanan_user FOREIGN KEY (id_user)
REFERENCES users(id_user) ON DELETE RESTRICT
);

CREATE TABLE detail_pesanan (
id_detail_pesanan INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_pesanan INTEGER NOT NULL,
id_produk INTEGER NOT NULL,
jumlah INTEGER NOT NULL CHECK (jumlah > 0),
harga_satuan NUMERIC(12,2) NOT NULL CHECK (harga_satuan >= 0),
CONSTRAINT fk_detail_pesanan FOREIGN KEY (id_pesanan)
REFERENCES pesanan(id_pesanan) ON DELETE CASCADE,
CONSTRAINT fk_detail_pesanan_produk FOREIGN KEY (id_produk)
REFERENCES produk(id_produk) ON DELETE RESTRICT
);

CREATE TABLE pembayaran (
id_pembayaran INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_pesanan INTEGER NOT NULL UNIQUE,
metode_pembayaran VARCHAR(50) NOT NULL,
status_pembayaran VARCHAR(30) NOT NULL DEFAULT 'menunggu'
CHECK (status_pembayaran IN ('menunggu', 'berhasil', 'gagal')),
tanggal_pembayaran TIMESTAMP,
CONSTRAINT fk_pembayaran_pesanan FOREIGN KEY (id_pesanan)
REFERENCES pesanan(id_pesanan) ON DELETE RESTRICT
);

CREATE TABLE pengiriman (
id_pengiriman INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_pesanan INTEGER NOT NULL UNIQUE,
jenis_pengiriman VARCHAR(30) NOT NULL
CHECK (jenis_pengiriman IN ('kurir_desa', 'ekspedisi')),
alamat_tujuan TEXT NOT NULL,
nama_kurir VARCHAR(100),
nomor_resi VARCHAR(100),
status_pengiriman VARCHAR(30) NOT NULL DEFAULT 'menunggu'
CHECK (status_pengiriman IN
('menunggu', 'diproses', 'dikirim', 'diterima')),
CONSTRAINT fk_pengiriman_pesanan FOREIGN KEY (id_pesanan)
REFERENCES pesanan(id_pesanan) ON DELETE RESTRICT
);

CREATE TABLE riwayat_status_pesanan (
id_riwayat INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_pesanan INTEGER NOT NULL,
status VARCHAR(30) NOT NULL,
waktu TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
keterangan TEXT,
CONSTRAINT fk_riwayat_pesanan FOREIGN KEY (id_pesanan)
REFERENCES pesanan(id_pesanan) ON DELETE CASCADE
);

