-- =========================================================================
-- SUPABASE ROW LEVEL SECURITY (RLS) POLICIES - MULTI-TENANT ISOLATION
-- =========================================================================
-- Jalankan skrip ini di: Supabase Dashboard > SQL Editor > Run
--
-- Tujuan:
-- 1. Mengaktifkan Row Level Security (RLS) pada tabel `presets` dan `shortcuts`.
-- 2. Membatasi akses sehingga setiap pengguna hanya dapat membaca, menambah,
--    memperbarui, dan menghapus preset serta shortcut miliknya sendiri (auth.uid() = user_id),
--    atau data bawaan publik (user_id IS NULL).
-- =========================================================================

-- 1. Aktifkan Row Level Security (RLS)
ALTER TABLE public.presets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shortcuts ENABLE ROW LEVEL SECURITY;

-- 2. Hapus kebijakan lama jika ada (idempotent / aman dijalankan berulang kali)
DROP POLICY IF EXISTS "Users access own presets" ON public.presets;
DROP POLICY IF EXISTS "Users access own shortcuts" ON public.shortcuts;
DROP POLICY IF EXISTS "Users can view their own presets" ON public.presets;
DROP POLICY IF EXISTS "Users can insert their own presets" ON public.presets;
DROP POLICY IF EXISTS "Users can update their own presets" ON public.presets;
DROP POLICY IF EXISTS "Users can delete their own presets" ON public.presets;

-- 3. Kebijakan Multi-Tenant untuk tabel `presets`
CREATE POLICY "Users access own presets" ON public.presets 
FOR ALL USING (auth.uid()::text = user_id::text OR user_id IS NULL)
WITH CHECK (auth.uid()::text = user_id::text OR user_id IS NULL);

-- 4. Kebijakan Multi-Tenant untuk tabel `shortcuts`
CREATE POLICY "Users access own shortcuts" ON public.shortcuts 
FOR ALL USING (auth.uid()::text = user_id::text OR user_id IS NULL)
WITH CHECK (auth.uid()::text = user_id::text OR user_id IS NULL);
