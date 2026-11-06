# Desantara API

REST API Express.js + PostgreSQL untuk tabel `produk`.

## Setup
1. Buat database: `CREATE DATABASE desantara;`
2. Jalankan `database/schema.sql`, lalu `database/seed.sql` (psql / pgAdmin).
3. `copy .env.example .env` lalu isi password PostgreSQL.
4. `npm install`
5. `npm run dev`

## Endpoint
| Method | URL | Keterangan |
|---|---|---|
| GET | /api/produk | Semua produk |
| GET | /api/produk/:id | Produk berdasarkan ID |
| POST | /api/produk | Buat produk baru |
| PUT | /api/produk/:id | Update produk |
| DELETE | /api/produk/:id | Hapus produk |

Contoh body POST (JSON):
```json
{
  "id_umkm": 1,
  "id_kategori": 1,
  "nama_produk": "Keripik Singkong Pedas",
  "deskripsi": "Keripik renyah level pedas",
  "harga": 15000,
  "stok": 50,
  "foto_url": "https://example.com/keripik.jpg"
}
```

## Endpoint UMKM
| Method | URL | Keterangan |
|---|---|---|
| GET | /api/umkm | Semua UMKM |
| GET | /api/umkm/:id | UMKM berdasarkan ID |
| POST | /api/umkm | Buat UMKM (wajib: id_user, nama_usaha, alamat) |
| PUT | /api/umkm/:id | Update UMKM |
| DELETE | /api/umkm/:id | Hapus UMKM (ditolak jika masih punya produk) |

## Data dummy
`database/seed.sql` berisi data contoh untuk ke-11 tabel (7 user, 3 UMKM, 4 kategori, 9 produk, 5 pesanan, dst).
Jalankan hanya pada database kosong, setelah `schema.sql`.
