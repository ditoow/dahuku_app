-- =====================================================
-- DAHUKU APP - SUPABASE DATABASE SCHEMA (BAHASA INDONESIA)
-- Copy semua SQL di bawah ini ke Supabase SQL Editor
-- Version: 1.0.0
-- Last Updated: 2024-12-22
-- =====================================================

-- ===================
-- 1. TIPE ENUM
-- ===================
CREATE TYPE tipe_dompet AS ENUM ('belanja', 'tabungan', 'darurat');
CREATE TYPE tipe_transaksi AS ENUM ('pemasukan', 'pengeluaran', 'transfer');
CREATE TYPE frekuensi_berulang AS ENUM ('harian', 'mingguan', 'bulanan', 'tahunan');

-- ===================
-- 2. TABEL PENGGUNA
-- ===================
CREATE TABLE pengguna (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  nama VARCHAR(100) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  url_avatar TEXT,
  telepon VARCHAR(20),
  dibuat_pada TIMESTAMPTZ DEFAULT NOW(),
  diperbarui_pada TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE pengguna ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Pengguna bisa lihat profil sendiri" ON pengguna
  FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Pengguna bisa update profil sendiri" ON pengguna
  FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Pengguna bisa insert profil sendiri" ON pengguna
  FOR INSERT WITH CHECK (auth.uid() = id);

-- ===================
-- 3. TABEL DOMPET
-- ===================
CREATE TABLE dompet (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_pengguna UUID REFERENCES pengguna(id) ON DELETE CASCADE NOT NULL,
  nama VARCHAR(50) NOT NULL,
  tipe tipe_dompet NOT NULL,
  saldo DECIMAL(15, 2) DEFAULT 0,
  utama BOOLEAN DEFAULT FALSE,
  nama_ikon VARCHAR(50),
  warna_hex VARCHAR(7),
  dibuat_pada TIMESTAMPTZ DEFAULT NOW(),
  diperbarui_pada TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE dompet ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Pengguna kelola dompet sendiri" ON dompet
  FOR ALL USING (auth.uid() = id_pengguna);

-- ===================
-- 4. TABEL KATEGORI
-- ===================
CREATE TABLE kategori (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_pengguna UUID REFERENCES pengguna(id) ON DELETE CASCADE,
  nama VARCHAR(50) NOT NULL,
  nama_ikon VARCHAR(50) NOT NULL,
  warna_hex VARCHAR(7) NOT NULL,
  tipe tipe_transaksi NOT NULL,
  adalah_default BOOLEAN DEFAULT FALSE,
  dibuat_pada TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE kategori ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Pengguna lihat kategori sendiri dan default" ON kategori
  FOR SELECT USING (auth.uid() = id_pengguna OR adalah_default = TRUE);
CREATE POLICY "Pengguna insert kategori sendiri" ON kategori
  FOR INSERT WITH CHECK (auth.uid() = id_pengguna);
CREATE POLICY "Pengguna update kategori sendiri" ON kategori
  FOR UPDATE USING (auth.uid() = id_pengguna);
CREATE POLICY "Pengguna hapus kategori sendiri" ON kategori
  FOR DELETE USING (auth.uid() = id_pengguna);

-- ===================
-- 5. TABEL TRANSAKSI
-- ===================
CREATE TABLE transaksi (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_pengguna UUID REFERENCES pengguna(id) ON DELETE CASCADE NOT NULL,
  id_dompet UUID REFERENCES dompet(id) ON DELETE CASCADE NOT NULL,
  id_kategori UUID REFERENCES kategori(id) ON DELETE SET NULL,
  
  judul VARCHAR(100) NOT NULL,
  deskripsi TEXT,
  jumlah DECIMAL(15, 2) NOT NULL,
  tipe tipe_transaksi NOT NULL,
  
  -- Transfer specific
  id_dompet_tujuan UUID REFERENCES dompet(id),
  
  -- Recurring reference
  id_transaksi_berulang UUID,
  
  tanggal_transaksi DATE NOT NULL DEFAULT CURRENT_DATE,
  dibuat_pada TIMESTAMPTZ DEFAULT NOW(),
  diperbarui_pada TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE transaksi ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Pengguna kelola transaksi sendiri" ON transaksi
  FOR ALL USING (auth.uid() = id_pengguna);

-- Indexes untuk performa
CREATE INDEX idx_transaksi_pengguna_tanggal ON transaksi(id_pengguna, tanggal_transaksi DESC);
CREATE INDEX idx_transaksi_dompet ON transaksi(id_dompet);
CREATE INDEX idx_transaksi_kategori ON transaksi(id_kategori);

-- ===================
-- 6. TABEL TRANSAKSI BERULANG
-- ===================
CREATE TABLE transaksi_berulang (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_pengguna UUID REFERENCES pengguna(id) ON DELETE CASCADE NOT NULL,
  id_dompet UUID REFERENCES dompet(id) ON DELETE CASCADE NOT NULL,
  id_kategori UUID REFERENCES kategori(id) ON DELETE SET NULL,
  
  judul VARCHAR(100) NOT NULL,
  deskripsi TEXT,
  jumlah DECIMAL(15, 2) NOT NULL,
  tipe tipe_transaksi NOT NULL,
  
  -- Pengaturan berulang
  frekuensi frekuensi_berulang NOT NULL,
  hari_dalam_bulan INT CHECK (hari_dalam_bulan BETWEEN 1 AND 31),
  hari_dalam_minggu INT CHECK (hari_dalam_minggu BETWEEN 0 AND 6),
  
  tanggal_mulai DATE NOT NULL,
  tanggal_selesai DATE,
  tanggal_jalan_berikutnya DATE NOT NULL,
  
  aktif BOOLEAN DEFAULT TRUE,
  terakhir_dijalankan TIMESTAMPTZ,
  
  dibuat_pada TIMESTAMPTZ DEFAULT NOW(),
  diperbarui_pada TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE transaksi_berulang ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Pengguna kelola transaksi berulang sendiri" ON transaksi_berulang
  FOR ALL USING (auth.uid() = id_pengguna);

CREATE INDEX idx_berulang_tanggal_jalan ON transaksi_berulang(tanggal_jalan_berikutnya) WHERE aktif = TRUE;

-- ===================
-- 7. TABEL ANGGARAN
-- ===================
CREATE TABLE anggaran (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_pengguna UUID REFERENCES pengguna(id) ON DELETE CASCADE NOT NULL,
  id_kategori UUID REFERENCES kategori(id) ON DELETE CASCADE,
  jumlah DECIMAL(15, 2) NOT NULL,
  bulan_periode INT CHECK (bulan_periode BETWEEN 1 AND 12),
  tahun_periode INT CHECK (tahun_periode >= 2020),
  dibuat_pada TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE anggaran ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Pengguna kelola anggaran sendiri" ON anggaran
  FOR ALL USING (auth.uid() = id_pengguna);

CREATE UNIQUE INDEX idx_anggaran_unik ON anggaran(id_pengguna, id_kategori, bulan_periode, tahun_periode);

-- ===================
-- 8. TABEL PENGATURAN PENGGUNA
-- ===================
CREATE TABLE pengaturan_pengguna (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_pengguna UUID UNIQUE REFERENCES pengguna(id) ON DELETE CASCADE NOT NULL,
  mode_offline BOOLEAN DEFAULT FALSE,
  ukuran_font VARCHAR(10) DEFAULT 'sedang',
  kontras_tinggi BOOLEAN DEFAULT FALSE,
  bahasa VARCHAR(5) DEFAULT 'id',
  notifikasi_aktif BOOLEAN DEFAULT TRUE,
  biometrik_aktif BOOLEAN DEFAULT FALSE,
  diperbarui_pada TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE pengaturan_pengguna ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Pengguna kelola pengaturan sendiri" ON pengaturan_pengguna
  FOR ALL USING (auth.uid() = id_pengguna);

-- ===================
-- 9. TABEL RESPON KUESIONER
-- ===================
CREATE TABLE respon_kuesioner (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_pengguna UUID UNIQUE REFERENCES pengguna(id) ON DELETE CASCADE NOT NULL,
  
  -- Saldo awal dompet
  saldo_awal_belanja DECIMAL(15, 2) DEFAULT 0,
  saldo_awal_tabungan DECIMAL(15, 2) DEFAULT 0,
  saldo_awal_darurat DECIMAL(15, 2) DEFAULT 0,
  
  -- Hutang
  punya_hutang BOOLEAN DEFAULT FALSE,
  jumlah_hutang DECIMAL(15, 2),
  tipe_hutang VARCHAR(50),
  
  selesai_pada TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE respon_kuesioner ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Pengguna kelola kuesioner sendiri" ON respon_kuesioner
  FOR ALL USING (auth.uid() = id_pengguna);

-- ===================
-- 10. TABEL PIN PENGGUNA
-- ===================
CREATE TABLE pin_pengguna (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_pengguna UUID UNIQUE REFERENCES pengguna(id) ON DELETE CASCADE NOT NULL,
  hash_pin VARCHAR(255) NOT NULL,
  biometrik_aktif BOOLEAN DEFAULT FALSE,
  dibuat_pada TIMESTAMPTZ DEFAULT NOW(),
  diperbarui_pada TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE pin_pengguna ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Pengguna kelola PIN sendiri" ON pin_pengguna
  FOR ALL USING (auth.uid() = id_pengguna);

-- ===================
-- 11. KATEGORI DEFAULT (SEED DATA)
-- ===================
INSERT INTO kategori (nama, nama_ikon, warna_hex, tipe, adalah_default) VALUES
  -- Kategori pengeluaran
  ('Makan & Minum', 'restaurant', '#FF6B6B', 'pengeluaran', TRUE),
  ('Transportasi', 'directions_car', '#4ECDC4', 'pengeluaran', TRUE),
  ('Belanja', 'shopping_bag', '#FFE66D', 'pengeluaran', TRUE),
  ('Tagihan', 'receipt_long', '#95E1D3', 'pengeluaran', TRUE),
  ('Hiburan', 'movie', '#DDA0DD', 'pengeluaran', TRUE),
  ('Kesehatan', 'medical_services', '#98D8C8', 'pengeluaran', TRUE),
  ('Pendidikan', 'school', '#F7DC6F', 'pengeluaran', TRUE),
  ('Lainnya', 'more_horiz', '#BDC3C7', 'pengeluaran', TRUE),
  -- Kategori pemasukan
  ('Gaji', 'payments', '#2ECC71', 'pemasukan', TRUE),
  ('Bonus', 'card_giftcard', '#27AE60', 'pemasukan', TRUE),
  ('Investasi', 'trending_up', '#1ABC9C', 'pemasukan', TRUE),
  ('Freelance', 'work', '#16A085', 'pemasukan', TRUE),
  ('Lainnya', 'add_circle', '#3498DB', 'pemasukan', TRUE);

-- ===================
-- 12. FUNGSI RINGKASAN DASHBOARD
-- ===================
CREATE OR REPLACE FUNCTION dapatkan_ringkasan_dashboard(p_id_pengguna UUID)
RETURNS JSON AS $$
DECLARE
  hasil JSON;
BEGIN
  SELECT json_build_object(
    'total_saldo', COALESCE((SELECT SUM(saldo) FROM dompet WHERE id_pengguna = p_id_pengguna), 0),
    'pengeluaran_mingguan', COALESCE((
      SELECT SUM(jumlah) FROM transaksi 
      WHERE id_pengguna = p_id_pengguna 
        AND tipe = 'pengeluaran'
        AND tanggal_transaksi >= CURRENT_DATE - INTERVAL '7 days'
    ), 0),
    'anggaran_bulanan', COALESCE((
      SELECT SUM(jumlah) FROM anggaran 
      WHERE id_pengguna = p_id_pengguna 
        AND bulan_periode = EXTRACT(MONTH FROM CURRENT_DATE)
        AND tahun_periode = EXTRACT(YEAR FROM CURRENT_DATE)
    ), 0),
    'terpakai_bulanan', COALESCE((
      SELECT SUM(jumlah) FROM transaksi 
      WHERE id_pengguna = p_id_pengguna 
        AND tipe = 'pengeluaran'
        AND EXTRACT(MONTH FROM tanggal_transaksi) = EXTRACT(MONTH FROM CURRENT_DATE)
        AND EXTRACT(YEAR FROM tanggal_transaksi) = EXTRACT(YEAR FROM CURRENT_DATE)
    ), 0)
  ) INTO hasil;
  
  RETURN hasil;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ===================
-- 13. TRIGGER: UPDATE SALDO DOMPET
-- ===================
CREATE OR REPLACE FUNCTION perbarui_saldo_dompet()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.tipe = 'pengeluaran' THEN
      UPDATE dompet SET saldo = saldo - NEW.jumlah, diperbarui_pada = NOW() WHERE id = NEW.id_dompet;
    ELSIF NEW.tipe = 'pemasukan' THEN
      UPDATE dompet SET saldo = saldo + NEW.jumlah, diperbarui_pada = NOW() WHERE id = NEW.id_dompet;
    ELSIF NEW.tipe = 'transfer' AND NEW.id_dompet_tujuan IS NOT NULL THEN
      UPDATE dompet SET saldo = saldo - NEW.jumlah, diperbarui_pada = NOW() WHERE id = NEW.id_dompet;
      UPDATE dompet SET saldo = saldo + NEW.jumlah, diperbarui_pada = NOW() WHERE id = NEW.id_dompet_tujuan;
    END IF;
  ELSIF TG_OP = 'DELETE' THEN
    IF OLD.tipe = 'pengeluaran' THEN
      UPDATE dompet SET saldo = saldo + OLD.jumlah, diperbarui_pada = NOW() WHERE id = OLD.id_dompet;
    ELSIF OLD.tipe = 'pemasukan' THEN
      UPDATE dompet SET saldo = saldo - OLD.jumlah, diperbarui_pada = NOW() WHERE id = OLD.id_dompet;
    ELSIF OLD.tipe = 'transfer' AND OLD.id_dompet_tujuan IS NOT NULL THEN
      UPDATE dompet SET saldo = saldo + OLD.jumlah, diperbarui_pada = NOW() WHERE id = OLD.id_dompet;
      UPDATE dompet SET saldo = saldo - OLD.jumlah, diperbarui_pada = NOW() WHERE id = OLD.id_dompet_tujuan;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_perbarui_saldo_dompet
AFTER INSERT OR DELETE ON transaksi
FOR EACH ROW EXECUTE FUNCTION perbarui_saldo_dompet();

-- =====================================================
-- SELESAI - SCHEMA v1.0.0 (BAHASA INDONESIA)
-- =====================================================
