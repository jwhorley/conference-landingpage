/*
  # Fix storage policies for paper submissions

  1. Changes
    - Drop existing policies
    - Modify public upload policy to work without authentication
    - Keep admin-only access for viewing/managing files
    
  2. Security
    - Public can upload files without authentication
    - Only admins can view/manage files
    - Regular users cannot view any files
*/

-- Drop existing policies
DROP POLICY IF EXISTS "Public can upload papers" ON storage.objects;
DROP POLICY IF EXISTS "Only admins can view files" ON storage.objects;
DROP POLICY IF EXISTS "Only admins can manage files" ON storage.objects;

-- Allow public uploads without requiring authentication
CREATE POLICY "Public can upload papers"
ON storage.objects
FOR INSERT
TO public
WITH CHECK (
  bucket_id = 'paper-submissions'
  AND LENGTH(name) > 1
  AND LENGTH(name) < 255
  AND (LOWER(SUBSTRING(name FROM '\.([^\.]+)$')) = '.pdf')
);

-- Only admins can view/download files
CREATE POLICY "Only admins can view files"
ON storage.objects
FOR SELECT
TO authenticated
USING (
  bucket_id = 'paper-submissions'
  AND EXISTS (
    SELECT 1 FROM admin_users WHERE user_id = auth.uid()
  )
);

-- Only admins can manage files (update/delete)
CREATE POLICY "Only admins can manage files"
ON storage.objects
FOR ALL
TO authenticated
USING (
  bucket_id = 'paper-submissions'
  AND EXISTS (
    SELECT 1 FROM admin_users WHERE user_id = auth.uid()
  )
)
WITH CHECK (
  bucket_id = 'paper-submissions'
  AND EXISTS (
    SELECT 1 FROM admin_users WHERE user_id = auth.uid()
  )
);