--
-- PostgreSQL database dump
--

\restrict WXznt5WS3JbZVI4zNeT7X0V0LgusqJMOYqeafltCLQT36houQjSl2qhg2IphptE

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-09-14 02:00:48

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16410)
-- Name: m_dokter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.m_dokter (
    id_dokter integer NOT NULL,
    nama_dokter character varying(100) DEFAULT NULL::character varying,
    spesialis character varying(100) DEFAULT NULL::character varying,
    id_poli integer,
    jadwal_praktik character varying(50) DEFAULT NULL::character varying,
    status character varying(20) DEFAULT NULL::character varying,
    no_str character varying(30) DEFAULT NULL::character varying,
    no_hp character varying(15) DEFAULT NULL::character varying,
    CONSTRAINT m_dokter_status_check CHECK (((status)::text = ANY ((ARRAY['Aktif'::character varying, 'Tidak Aktif'::character varying])::text[])))
);


ALTER TABLE public.m_dokter OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16435)
-- Name: m_layanan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.m_layanan (
    id_layanan integer NOT NULL,
    nama_layanan character varying(100) DEFAULT NULL::character varying,
    kategori character varying(30) DEFAULT NULL::character varying,
    tarif_dasar integer
);


ALTER TABLE public.m_layanan OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16421)
-- Name: m_obat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.m_obat (
    id_obat integer NOT NULL,
    nama_obat character varying(100) DEFAULT NULL::character varying,
    kategori character varying(50) DEFAULT NULL::character varying,
    satuan character varying(20) DEFAULT NULL::character varying,
    harga_satuan integer,
    stok integer
);


ALTER TABLE public.m_obat OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16450)
-- Name: m_pasien; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.m_pasien (
    no_rekam_medis character varying(6) NOT NULL,
    nama_pasien character varying(100) DEFAULT NULL::character varying,
    jenis_kelamin character(1) DEFAULT NULL::bpchar,
    tanggal_lahir date,
    alamat character varying(255) DEFAULT NULL::character varying,
    kota character varying(50) DEFAULT NULL::character varying,
    no_bpjs bigint,
    gol_darah character(2) DEFAULT NULL::bpchar,
    status_aktif character varying(20) DEFAULT NULL::character varying,
    tgl_daftar date,
    no_hp character varying(15) DEFAULT NULL::character varying,
    kontak_darurat character varying(100) DEFAULT NULL::character varying,
    CONSTRAINT m_pasien_status_aktif_check CHECK (((status_aktif)::text = ANY ((ARRAY['TRUE'::character varying, 'FALSE'::character varying])::text[])))
);


ALTER TABLE public.m_pasien OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16441)
-- Name: m_perawat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.m_perawat (
    id_perawat integer NOT NULL,
    nama_perawat character varying(100) DEFAULT NULL::character varying,
    id_poli integer,
    shift character varying(10) DEFAULT NULL::character varying,
    status character varying(20) DEFAULT NULL::character varying,
    no_hp character varying(15) DEFAULT NULL::character varying,
    CONSTRAINT m_perawat_status_check CHECK (((status)::text = ANY ((ARRAY['Aktif'::character varying, 'Tidak Aktif'::character varying])::text[])))
);


ALTER TABLE public.m_perawat OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16401)
-- Name: m_poli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.m_poli (
    id_poli integer NOT NULL,
    nama_poli character varying(100) DEFAULT NULL::character varying,
    lokasi character varying(50) DEFAULT NULL::character varying,
    jam_operasional character varying(50) DEFAULT NULL::character varying,
    status character varying(20) DEFAULT NULL::character varying,
    CONSTRAINT m_poli_status_check CHECK (((status)::text = ANY ((ARRAY['Aktif'::character varying, 'Tidak Aktif'::character varying])::text[])))
);


ALTER TABLE public.m_poli OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16428)
-- Name: m_ruangan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.m_ruangan (
    id_ruangan integer NOT NULL,
    nama_ruangan character varying(50) DEFAULT NULL::character varying,
    kelas character varying(20) DEFAULT NULL::character varying,
    kapasitas_bed integer,
    tarif_per_hari integer,
    status_ruangan character varying(20) DEFAULT NULL::character varying
);


ALTER TABLE public.m_ruangan OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16472)
-- Name: t_diagnosa_pasien; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t_diagnosa_pasien (
    id_diagnosa integer NOT NULL,
    id_kunjungan integer,
    kode_icd10 character varying(10) DEFAULT NULL::character varying,
    nama_penyakit character varying(100) DEFAULT NULL::character varying,
    tipe_diagnosa character varying(20) DEFAULT NULL::character varying,
    tgl_diagnosa date
);


ALTER TABLE public.t_diagnosa_pasien OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16479)
-- Name: t_hasil_lab; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t_hasil_lab (
    id_lab integer NOT NULL,
    id_kunjungan integer,
    jenis_pemeriksaan character varying(100) DEFAULT NULL::character varying,
    nama_parameter character varying(100) DEFAULT NULL::character varying,
    nilai_hasil numeric(12,3) DEFAULT NULL::numeric,
    satuan character varying(10) DEFAULT NULL::character varying,
    nilai_rujukan character varying(20) DEFAULT NULL::character varying,
    status_hasil character varying(20) DEFAULT NULL::character varying,
    tanggal_periksa date
);


ALTER TABLE public.t_hasil_lab OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16465)
-- Name: t_kunjungan_pasien; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t_kunjungan_pasien (
    id_kunjungan integer NOT NULL,
    no_rekam_medis character varying(6) DEFAULT NULL::character varying,
    tgl_kunjungan date,
    waktu_kunjungan time without time zone,
    jenis_kunjungan character varying(50) DEFAULT NULL::character varying,
    id_poli integer,
    id_dokter integer,
    id_ruangan integer,
    status_kunjungan character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE public.t_kunjungan_pasien OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16505)
-- Name: t_penugasan_perawat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t_penugasan_perawat (
    id_penugasan integer NOT NULL,
    id_kunjungan integer,
    id_perawat integer,
    shift character varying(10) DEFAULT NULL::character varying,
    tgl_tugas date
);


ALTER TABLE public.t_penugasan_perawat OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16489)
-- Name: t_resep_obat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t_resep_obat (
    id_resep integer NOT NULL,
    id_kunjungan integer,
    id_obat integer,
    dosis character varying(50) DEFAULT NULL::character varying,
    frekuensi character varying(100) DEFAULT NULL::character varying,
    durasi integer,
    jumlah integer,
    cara_pakai character varying(100) DEFAULT NULL::character varying,
    waktu_resep timestamp without time zone
);


ALTER TABLE public.t_resep_obat OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16496)
-- Name: t_transaksi_billing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t_transaksi_billing (
    id_transaksi integer NOT NULL,
    id_kunjungan integer,
    id_layanan integer,
    rincian character varying(100) DEFAULT NULL::character varying,
    jumlah numeric(12,2) DEFAULT NULL::numeric,
    harga_satuan integer,
    subtotal integer,
    metode_pembayaran character varying(50) DEFAULT NULL::character varying,
    status_bayar character varying(20) DEFAULT NULL::character varying,
    tgl_transaksi date,
    CONSTRAINT t_transaksi_billing_status_bayar_check CHECK (((status_bayar)::text = ANY ((ARRAY['Lunas'::character varying, 'Belum Lunas'::character varying])::text[])))
);


ALTER TABLE public.t_transaksi_billing OWNER TO postgres;

--
-- TOC entry 4861 (class 2606 OID 16513)
-- Name: m_dokter m_dokter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.m_dokter
    ADD CONSTRAINT m_dokter_pkey PRIMARY KEY (id_dokter);


--
-- TOC entry 4867 (class 2606 OID 16520)
-- Name: m_layanan m_layanan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.m_layanan
    ADD CONSTRAINT m_layanan_pkey PRIMARY KEY (id_layanan);


--
-- TOC entry 4863 (class 2606 OID 16516)
-- Name: m_obat m_obat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.m_obat
    ADD CONSTRAINT m_obat_pkey PRIMARY KEY (id_obat);


--
-- TOC entry 4872 (class 2606 OID 16525)
-- Name: m_pasien m_pasien_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.m_pasien
    ADD CONSTRAINT m_pasien_pkey PRIMARY KEY (no_rekam_medis);


--
-- TOC entry 4870 (class 2606 OID 16522)
-- Name: m_perawat m_perawat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.m_perawat
    ADD CONSTRAINT m_perawat_pkey PRIMARY KEY (id_perawat);


--
-- TOC entry 4858 (class 2606 OID 16511)
-- Name: m_poli m_poli_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.m_poli
    ADD CONSTRAINT m_poli_pkey PRIMARY KEY (id_poli);


--
-- TOC entry 4865 (class 2606 OID 16518)
-- Name: m_ruangan m_ruangan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.m_ruangan
    ADD CONSTRAINT m_ruangan_pkey PRIMARY KEY (id_ruangan);


--
-- TOC entry 4881 (class 2606 OID 16533)
-- Name: t_diagnosa_pasien t_diagnosa_pasien_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_diagnosa_pasien
    ADD CONSTRAINT t_diagnosa_pasien_pkey PRIMARY KEY (id_diagnosa);


--
-- TOC entry 4884 (class 2606 OID 16536)
-- Name: t_hasil_lab t_hasil_lab_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_hasil_lab
    ADD CONSTRAINT t_hasil_lab_pkey PRIMARY KEY (id_lab);


--
-- TOC entry 4878 (class 2606 OID 16527)
-- Name: t_kunjungan_pasien t_kunjungan_pasien_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_kunjungan_pasien
    ADD CONSTRAINT t_kunjungan_pasien_pkey PRIMARY KEY (id_kunjungan);


--
-- TOC entry 4896 (class 2606 OID 16547)
-- Name: t_penugasan_perawat t_penugasan_perawat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_penugasan_perawat
    ADD CONSTRAINT t_penugasan_perawat_pkey PRIMARY KEY (id_penugasan);


--
-- TOC entry 4888 (class 2606 OID 16539)
-- Name: t_resep_obat t_resep_obat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_resep_obat
    ADD CONSTRAINT t_resep_obat_pkey PRIMARY KEY (id_resep);


--
-- TOC entry 4892 (class 2606 OID 16543)
-- Name: t_transaksi_billing t_transaksi_billing_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_transaksi_billing
    ADD CONSTRAINT t_transaksi_billing_pkey PRIMARY KEY (id_transaksi);


--
-- TOC entry 4859 (class 1259 OID 16514)
-- Name: idx_m_dokter_id_poli; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_m_dokter_id_poli ON public.m_dokter USING btree (id_poli);


--
-- TOC entry 4868 (class 1259 OID 16523)
-- Name: idx_m_perawat_id_poli; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_m_perawat_id_poli ON public.m_perawat USING btree (id_poli);


--
-- TOC entry 4879 (class 1259 OID 16534)
-- Name: idx_t_diagnosa_pasien_id_kunjungan; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_t_diagnosa_pasien_id_kunjungan ON public.t_diagnosa_pasien USING btree (id_kunjungan);


--
-- TOC entry 4882 (class 1259 OID 16537)
-- Name: idx_t_hasil_lab_id_kunjungan; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_t_hasil_lab_id_kunjungan ON public.t_hasil_lab USING btree (id_kunjungan);


--
-- TOC entry 4873 (class 1259 OID 16530)
-- Name: idx_t_kunjungan_pasien_id_dokter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_t_kunjungan_pasien_id_dokter ON public.t_kunjungan_pasien USING btree (id_dokter);


--
-- TOC entry 4874 (class 1259 OID 16529)
-- Name: idx_t_kunjungan_pasien_id_poli; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_t_kunjungan_pasien_id_poli ON public.t_kunjungan_pasien USING btree (id_poli);


--
-- TOC entry 4875 (class 1259 OID 16531)
-- Name: idx_t_kunjungan_pasien_id_ruangan; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_t_kunjungan_pasien_id_ruangan ON public.t_kunjungan_pasien USING btree (id_ruangan);


--
-- TOC entry 4876 (class 1259 OID 16528)
-- Name: idx_t_kunjungan_pasien_no_rekam_medis; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_t_kunjungan_pasien_no_rekam_medis ON public.t_kunjungan_pasien USING btree (no_rekam_medis);


--
-- TOC entry 4893 (class 1259 OID 16548)
-- Name: idx_t_penugasan_perawat_id_kunjungan; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_t_penugasan_perawat_id_kunjungan ON public.t_penugasan_perawat USING btree (id_kunjungan);


--
-- TOC entry 4894 (class 1259 OID 16549)
-- Name: idx_t_penugasan_perawat_id_perawat; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_t_penugasan_perawat_id_perawat ON public.t_penugasan_perawat USING btree (id_perawat);


--
-- TOC entry 4885 (class 1259 OID 16540)
-- Name: idx_t_resep_obat_id_kunjungan; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_t_resep_obat_id_kunjungan ON public.t_resep_obat USING btree (id_kunjungan);


--
-- TOC entry 4886 (class 1259 OID 16541)
-- Name: idx_t_resep_obat_id_obat; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_t_resep_obat_id_obat ON public.t_resep_obat USING btree (id_obat);


--
-- TOC entry 4889 (class 1259 OID 16544)
-- Name: idx_t_transaksi_billing_id_kunjungan; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_t_transaksi_billing_id_kunjungan ON public.t_transaksi_billing USING btree (id_kunjungan);


--
-- TOC entry 4890 (class 1259 OID 16545)
-- Name: idx_t_transaksi_billing_id_layanan; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_t_transaksi_billing_id_layanan ON public.t_transaksi_billing USING btree (id_layanan);


--
-- TOC entry 4899 (class 2606 OID 16570)
-- Name: t_kunjungan_pasien m_dokter_t_kunjungan_pasien; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_kunjungan_pasien
    ADD CONSTRAINT m_dokter_t_kunjungan_pasien FOREIGN KEY (id_dokter) REFERENCES public.m_dokter(id_dokter) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4907 (class 2606 OID 16605)
-- Name: t_transaksi_billing m_layanan_t_transaksi_billing; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_transaksi_billing
    ADD CONSTRAINT m_layanan_t_transaksi_billing FOREIGN KEY (id_layanan) REFERENCES public.m_layanan(id_layanan) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4905 (class 2606 OID 16595)
-- Name: t_resep_obat m_obat_t_resep_obat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_resep_obat
    ADD CONSTRAINT m_obat_t_resep_obat FOREIGN KEY (id_obat) REFERENCES public.m_obat(id_obat) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4900 (class 2606 OID 16560)
-- Name: t_kunjungan_pasien m_pasien_t_kunjungan_pasien; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_kunjungan_pasien
    ADD CONSTRAINT m_pasien_t_kunjungan_pasien FOREIGN KEY (no_rekam_medis) REFERENCES public.m_pasien(no_rekam_medis) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4909 (class 2606 OID 16615)
-- Name: t_penugasan_perawat m_perawat_t_penugasan_perawat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_penugasan_perawat
    ADD CONSTRAINT m_perawat_t_penugasan_perawat FOREIGN KEY (id_perawat) REFERENCES public.m_perawat(id_perawat) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4897 (class 2606 OID 16550)
-- Name: m_dokter m_poli_m_dokter; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.m_dokter
    ADD CONSTRAINT m_poli_m_dokter FOREIGN KEY (id_poli) REFERENCES public.m_poli(id_poli) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4898 (class 2606 OID 16555)
-- Name: m_perawat m_poli_m_perawat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.m_perawat
    ADD CONSTRAINT m_poli_m_perawat FOREIGN KEY (id_poli) REFERENCES public.m_poli(id_poli) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4901 (class 2606 OID 16565)
-- Name: t_kunjungan_pasien m_poli_t_kunjungan_pasien; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_kunjungan_pasien
    ADD CONSTRAINT m_poli_t_kunjungan_pasien FOREIGN KEY (id_poli) REFERENCES public.m_poli(id_poli) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4902 (class 2606 OID 16575)
-- Name: t_kunjungan_pasien m_ruangan_t_kunjungan_pasien; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_kunjungan_pasien
    ADD CONSTRAINT m_ruangan_t_kunjungan_pasien FOREIGN KEY (id_ruangan) REFERENCES public.m_ruangan(id_ruangan) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4903 (class 2606 OID 16580)
-- Name: t_diagnosa_pasien t_kunjungan_pasien_t_diagnosa_pasien; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_diagnosa_pasien
    ADD CONSTRAINT t_kunjungan_pasien_t_diagnosa_pasien FOREIGN KEY (id_kunjungan) REFERENCES public.t_kunjungan_pasien(id_kunjungan) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4904 (class 2606 OID 16585)
-- Name: t_hasil_lab t_kunjungan_pasien_t_hasil_lab; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_hasil_lab
    ADD CONSTRAINT t_kunjungan_pasien_t_hasil_lab FOREIGN KEY (id_kunjungan) REFERENCES public.t_kunjungan_pasien(id_kunjungan) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4910 (class 2606 OID 16610)
-- Name: t_penugasan_perawat t_kunjungan_pasien_t_penugasan_perawat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_penugasan_perawat
    ADD CONSTRAINT t_kunjungan_pasien_t_penugasan_perawat FOREIGN KEY (id_kunjungan) REFERENCES public.t_kunjungan_pasien(id_kunjungan) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4906 (class 2606 OID 16590)
-- Name: t_resep_obat t_kunjungan_pasien_t_resep_obat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_resep_obat
    ADD CONSTRAINT t_kunjungan_pasien_t_resep_obat FOREIGN KEY (id_kunjungan) REFERENCES public.t_kunjungan_pasien(id_kunjungan) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4908 (class 2606 OID 16600)
-- Name: t_transaksi_billing t_kunjungan_pasien_t_transaksi_billing; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t_transaksi_billing
    ADD CONSTRAINT t_kunjungan_pasien_t_transaksi_billing FOREIGN KEY (id_kunjungan) REFERENCES public.t_kunjungan_pasien(id_kunjungan) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2026-09-14 02:00:49

--
-- PostgreSQL database dump complete
--

\unrestrict WXznt5WS3JbZVI4zNeT7X0V0LgusqJMOYqeafltCLQT36houQjSl2qhg2IphptE

