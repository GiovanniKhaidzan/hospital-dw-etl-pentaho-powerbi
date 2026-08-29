# Data Warehouse Rumah Sakit

Project pembangunan Data Warehouse untuk kebutuhan pelaporan dan analisis manajemen rumah sakit, mencakup proses ETL menggunakan Pentaho Data Integration (Kettle) dan visualisasi menggunakan Power BI.

## Latar Belakang

Manajemen rumah sakit membutuhkan laporan dan analisis terkait operasional pasien, kinerja poli dan dokter, diagnosis, laboratorium, farmasi, dan pendapatan. Data operasional tersimpan di database transaksional (OLTP) yang tidak efisien untuk kebutuhan analisis berskala besar, sehingga dibangun sebuah data warehouse dengan pendekatan dimensional modeling (star schema) agar proses pelaporan lebih cepat, konsisten, dan mudah dikembangkan.

## Business Process yang Diidentifikasi

1. Kunjungan Pasien (registrasi dan operasional)
2. Diagnosis Penyakit
3. Pemeriksaan Laboratorium
4. Peresepan Obat (Farmasi)
5. Transaksi dan Billing (Pendapatan)

Rincian lengkap pertanyaan bisnis dari tiap unit dapat dilihat di file [`pertanyaan_bisnis.txt`](pertanyaan_bisnis.txt).

## Arsitektur Data Warehouse

Skema yang digunakan adalah **fact constellation (galaxy schema)**, yaitu beberapa fact table dengan grain masing-masing yang berbagi dimensi yang sama (conformed dimension), karena kelima business process di atas memiliki grain yang berbeda sehingga tidak dapat digabung ke dalam satu fact table tunggal.

### Dimension Table

| Dimensi | Sumber | Keterangan |
|---|---|---|
| dim_waktu | Generated | Tahun, kuartal, bulan, minggu, hari |
| dim_pasien | m_pasien | Data master pasien |
| dim_poli | m_poli | Data master poli |
| dim_dokter | m_dokter | Data master dokter |
| dim_perawat | m_perawat | Data master perawat |
| dim_ruangan | m_ruangan | Data master ruangan |
| dim_obat | m_obat | Data master obat |
| dim_layanan | m_layanan | Data master layanan |
| dim_diagnosa | t_diagnosa_pasien (distinct) | Kode ICD-10 dan nama penyakit |
| dim_parameter_lab | t_hasil_lab (distinct) | Jenis pemeriksaan dan parameter lab |
| dim_metode_bayar | t_transaksi_billing (distinct) | Metode pembayaran |

### Fact Table

| Fact Table | Grain | Measure |
|---|---|---|
| fact_kunjungan | 1 baris per kunjungan | jumlah_kunjungan |
| fact_diagnosa | 1 baris per diagnosis per kunjungan | jumlah_diagnosis |
| fact_hasil_lab | 1 baris per parameter hasil lab per kunjungan | nilai_hasil, jumlah_pemeriksaan, flag_abnormal |
| fact_resep_obat | 1 baris per obat diresepkan per kunjungan | jumlah, durasi, jumlah_resep |
| fact_billing | 1 baris per rincian layanan per transaksi | subtotal, jumlah, harga_satuan |

## Proses ETL (Pentaho Data Integration)

Setiap dimensi dan fact table memiliki transformation (`.ktr`) tersendiri. Pola umum yang digunakan pada transformation fact table:

1. **Table Input** — mengambil data transaksi dari tabel OLTP, digabungkan (JOIN) dengan tabel kunjungan untuk mendapatkan konteks pasien, poli, dan dokter.
2. **Table Input pendukung** — membaca isi tiap dimension table yang dibutuhkan sebagai pembanding lookup.
3. **Stream Lookup** — menukar natural key (id operasional) menjadi surrogate key dimensi, dengan default value untuk menangani baris yang tidak ditemukan pasangannya di dimensi.
4. **Calculator** — digunakan pada beberapa transformation untuk menyesuaikan tipe data tanggal/waktu sebelum dicocokkan ke dim_waktu.
5. **Select values** — merapikan kolom akhir yang akan dimuat ke fact table.
6. **Table Output** — menulis hasil akhir ke tabel target di database data warehouse.

Seluruh transformation dirangkai dalam satu job orchestration ([`job_load_dw_rs.kjb`](job/job_load_dw_rs.kjb)), dengan urutan eksekusi seluruh dimension table terlebih dahulu secara paralel, kemudian dilanjutkan seluruh fact table secara paralel, serta penanganan error dengan mencatat log jika ada transformation yang gagal.

## Struktur Folder

```
datawarehose_rumahsakit/
├── dimensi/              transformation Pentaho untuk seluruh dimension table
├── fact/                 transformation Pentaho untuk seluruh fact table
├── job/                  job orchestration Pentaho (.kjb)
├── dashboard/            dashboard Power BI (.pbix)
├── pertanyaan_bisnis.txt daftar kebutuhan analisis dari tiap unit manajemen
└── README.md
```

## Dashboard (Power BI)

File dashboard tersedia di [`dashboard/Dashboard_DW_RumahSakit.pbix`](dashboard/Dashboard_DW_RumahSakit.pbix), terdiri dari beberapa halaman yang masing-masing menjawab kategori pertanyaan bisnis:

- Kunjungan dan Kinerja Poli/Dokter
- Diagnosis
- Laboratorium
- Farmasi
- Pendapatan

## Tools yang Digunakan

- PostgreSQL — database sumber (OLTP) dan target (data warehouse)
- Pentaho Data Integration (Kettle) versi 9.0 — proses ETL
- Power BI Desktop — visualisasi dan pelaporan

## Cara Menjalankan

1. Siapkan database PostgreSQL untuk sumber data OLTP dan data warehouse tujuan.
2. Buat seluruh tabel dimension dan fact table sesuai skema di atas pada database data warehouse.
3. Buka Pentaho Spoon, sesuaikan koneksi database pada tiap transformation (`.ktr`) dengan environment masing-masing.
4. Jalankan `job/job_load_dw_rs.kjb` untuk memuat seluruh data dimensi dan fact secara otomatis dan berurutan.
5. Buka `dashboard/Dashboard_DW_RumahSakit.pbix` dengan Power BI Desktop, perbarui koneksi database sesuai environment, lalu klik Refresh.

## Catatan

Project ini merupakan hasil latihan pembangunan data warehouse dari tahap identifikasi kebutuhan bisnis, perancangan dimensional model, proses ETL, hingga visualisasi laporan, dengan menggunakan skema data rumah sakit yang kompleks sebagai studi kasus.
