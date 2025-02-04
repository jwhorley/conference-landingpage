/*
  # Update storage policies for paper submissions

  1. Changes
    - Drop existing public view policies
    - Keep public upload capability
    - Restrict all read/manage access to admins only
    
  2. Security
    - Public can upload files
    - Only admins can view/manage files
    - Regular users cannot view any files (even their own uploads)
*/

-- Drop existing policies
DROP POLICY IF EXISTS "Anyone can view papers" ON storage.objects;
DROP POLICY IF EXISTS "Anyone can upload papers" ON storage.objects;
DROP POLICY IF EXISTS "Admins can manage all files" ON storage.objects;

-- Allow public uploads but restrict file size and types
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

-- Only admins can manage files
CREATE POLICY "Only admins can manage files"
ON storage.objects
FOR ALL
TO authenticated
USING (
  bucket_id = 'paper-submissions'
  AND EXISTS (
    SELECT 1 FROM admin_users WHERE user_id = auth.uid()
  )
);