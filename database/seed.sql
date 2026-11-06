-- Data dummy Desantara. Jalankan SETELAH schema.sql, pada database yang masih kosong
-- (ID identity dimulai dari 1, urutan insert di bawah bergantung pada hal itu).

-- 1. users (1 admin, 3 pemilik UMKM, 3 pembeli)
INSERT INTO users (nama, email, password, role, no_hp) VALUES
('Admin Desantara', 'admin@desantara.id',  'hashed_password', 'admin',        '081200000001'),
('Budi Santoso',    'budi@desantara.id',   'hashed_password', 'pemilik_umkm', '081234567801'),
('Sari Wulandari',  'sari@desantara.id',   'hashed_password', 'pemilik_umkm', '081234567802'),
('Joko Prasetyo',   'joko@desantara.id',   'hashed_password', 'pemilik_umkm', '081234567803'),
('Rina Wati',       'rina@desantara.id',   'hashed_password', 'pembeli',      '081234567804'),
('Dewi Lestari',    'dewi@desantara.id',   'hashed_password', 'pembeli',      '081234567805'),
('Andi Pratama',    'andi@desantara.id',   'hashed_password', 'pembeli',      '081234567806');

-- 2. umkm (one to one dengan users: id_user 2, 3, 4)
INSERT INTO umkm (id_user, nama_usaha, deskripsi, alamat, no_whatsapp, latitude, longitude) VALUES
(2, 'Keripik Bu Budi',      'Aneka keripik dan sambal olahan rumahan.',   'Dusun Krajan RT 02 RW 01, Desa Sukamaju',  '081234567801', -7.2574720, 112.7520880),
(3, 'Kopi & Madu Sari',     'Kopi bubuk, teh herbal, dan madu hutan.',    'Dusun Kidul RT 05 RW 02, Desa Sukamaju',   '081234567802', -7.2601110, 112.7555320),
(4, 'Kriya Tani Joko',      'Kerajinan anyaman dan beras organik.',       'Dusun Lor RT 01 RW 03, Desa Sukamaju',     '081234567803', -7.2533400, 112.7489900);

-- 3. kategori
INSERT INTO kategori (nama_kategori) VALUES
('Makanan'), ('Minuman'), ('Kerajinan'), ('Hasil Bumi');

-- 4. produk (one to many: umkm -> produk, kategori -> produk)
INSERT INTO produk (id_umkm, id_kategori, nama_produk, deskripsi, harga, stok, foto_url) VALUES
(1, 1, 'Keripik Singkong Original', 'Keripik singkong renyah, kemasan 250 gram.',      15000, 50, 'https://example.com/img/keripik-singkong.jpg'),
(1, 1, 'Keripik Pisang Coklat',     'Keripik pisang dengan lapisan coklat, 200 gram.', 18000, 40, 'https://example.com/img/keripik-pisang.jpg'),
(2, 2, 'Kopi Robusta Bubuk 250g',   'Kopi robusta lokal sangrai medium.',              35000, 30, 'https://example.com/img/kopi-robusta.jpg'),
(2, 2, 'Teh Herbal Jahe Merah',     'Seduhan jahe merah dan serai, isi 10 sachet.',    22000, 25, 'https://example.com/img/teh-jahe.jpg'),
(2, 4, 'Madu Hutan 500ml',          'Madu murni dari hutan sekitar desa.',             85000, 15, 'https://example.com/img/madu-hutan.jpg'),
(3, 3, 'Tas Anyaman Pandan',        'Tas anyaman pandan buatan tangan.',               65000, 10, 'https://example.com/img/tas-pandan.jpg'),
(3, 3, 'Keranjang Bambu Serbaguna', 'Keranjang bambu ukuran sedang.',                  45000, 20, 'https://example.com/img/keranjang-bambu.jpg'),
(3, 4, 'Beras Organik 5kg',         'Beras organik tanpa pestisida dari sawah desa.',  70000, 35, 'https://example.com/img/beras-organik.jpg'),
(1, 1, 'Sambal Terasi Botol',       'Sambal terasi pedas, botol 200 gram.',            20000, 60, 'https://example.com/img/sambal-terasi.jpg');

-- 5. keranjang (one to one dengan users pembeli: id_user 5, 6, 7)
INSERT INTO keranjang (id_user) VALUES (5), (6), (7);

-- 6. detail_keranjang (many to many: keranjang <-> produk)
INSERT INTO detail_keranjang (id_keranjang, id_produk, jumlah) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 6, 1),
(3, 8, 1),
(3, 9, 2);

-- 7. pesanan
INSERT INTO pesanan (id_user, tanggal_pesanan, total_harga, status_pesanan) VALUES
(5, NOW() - INTERVAL '10 days', 121000, 'selesai'),
(6, NOW() - INTERVAL '4 days',   92000, 'dikirim'),
(7, NOW() - INTERVAL '2 days',  110000, 'diproses'),
(5, NOW() - INTERVAL '1 day',    60000, 'menunggu_pembayaran'),
(6, NOW() - INTERVAL '6 days',   70000, 'dibatalkan');

-- 8. detail_pesanan (many to many: pesanan <-> produk)
INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, harga_satuan) VALUES
(1, 2, 2, 18000),
(1, 5, 1, 85000),
(2, 3, 2, 35000),
(2, 4, 1, 22000),
(3, 6, 1, 65000),
(3, 7, 1, 45000),
(4, 9, 3, 20000),
(5, 8, 1, 70000);

-- 9. pembayaran (one to one dengan pesanan)
INSERT INTO pembayaran (id_pesanan, metode_pembayaran, status_pembayaran, tanggal_pembayaran) VALUES
(1, 'transfer_bank', 'berhasil', NOW() - INTERVAL '10 days'),
(2, 'qris',          'berhasil', NOW() - INTERVAL '4 days'),
(3, 'ewallet',       'berhasil', NOW() - INTERVAL '2 days'),
(4, 'transfer_bank', 'menunggu', NULL),
(5, 'qris',          'gagal',    NOW() - INTERVAL '6 days');

-- 10. pengiriman (one to one dengan pesanan; hanya pesanan yang sudah dibayar)
INSERT INTO pengiriman (id_pesanan, jenis_pengiriman, alamat_tujuan, nama_kurir, nomor_resi, status_pengiriman) VALUES
(1, 'kurir_desa', 'Jl. Melati No. 12, Surabaya',      'Pak Slamet',  NULL,           'diterima'),
(2, 'ekspedisi',  'Jl. Kenanga No. 5, Sidoarjo',      'JNE Reguler', 'JNE1234567890', 'dikirim'),
(3, 'kurir_desa', 'Jl. Mawar No. 21, Gresik',         'Pak Slamet',  NULL,           'diproses');

-- 11. riwayat_status_pesanan
INSERT INTO riwayat_status_pesanan (id_pesanan, status, waktu, keterangan) VALUES
(1, 'menunggu_pembayaran', NOW() - INTERVAL '10 days',            'Pesanan dibuat'),
(1, 'diproses',            NOW() - INTERVAL '10 days' + INTERVAL '1 hour', 'Pembayaran berhasil'),
(1, 'dikirim',             NOW() - INTERVAL '9 days',             'Diantar kurir desa'),
(1, 'selesai',             NOW() - INTERVAL '8 days',             'Pesanan diterima pembeli'),
(2, 'menunggu_pembayaran', NOW() - INTERVAL '4 days',             'Pesanan dibuat'),
(2, 'diproses',            NOW() - INTERVAL '4 days' + INTERVAL '30 minutes', 'Pembayaran berhasil'),
(2, 'dikirim',             NOW() - INTERVAL '3 days',             'Dikirim via JNE'),
(3, 'menunggu_pembayaran', NOW() - INTERVAL '2 days',             'Pesanan dibuat'),
(3, 'diproses',            NOW() - INTERVAL '2 days' + INTERVAL '20 minutes', 'Pembayaran berhasil'),
(4, 'menunggu_pembayaran', NOW() - INTERVAL '1 day',              'Pesanan dibuat'),
(5, 'menunggu_pembayaran', NOW() - INTERVAL '6 days',             'Pesanan dibuat'),
(5, 'dibatalkan',          NOW() - INTERVAL '6 days' + INTERVAL '2 hours', 'Pembayaran gagal, pesanan dibatalkan');
