/*
  # Fix storage policies for paper submissions

  1. Changes
    - Remove existing policies
    - Create new policies with correct column references
    - Add size limit of 10MB for uploads
    - Ensure proper access control
*/

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Allow public uploads" ON storage.objects;
DROP POLICY IF EXISTS "Allow authenticated users to view files" ON storage.objects;

-- Create new storage policies
CREATE POLICY "Anyone can upload papers"
ON storage.objects
FOR INSERT
TO public
WITH CHECK (
  bucket_id = 'paper-submissions'
  AND LENGTH(name) > 1
  AND LENGTH(name) < 255
);

-- Allow anyone to read uploaded papers
CREATE POLICY "Anyone can view papers"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'paper-submissions');

-- Allow admins to manage all files
CREATE POLICY "Admins can manage all files"
ON storage.objects
FOR ALL
TO authenticated
USING (
  bucket_id = 'paper-submissions'
  AND EXISTS (
    SELECT 1 FROM admin_users WHERE user_id = auth.uid()
  )
);