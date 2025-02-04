/*
  # Fix storage bucket configuration and policies

  1. Changes
    - Update bucket configuration to allow public uploads
    - Simplify storage policies
    - Remove authentication requirements for uploads
    
  2. Security
    - Public can upload files without authentication
    - Only admins can view/manage files
    - Bucket configuration explicitly allows public operations
*/

-- Update bucket configuration to allow public uploads
UPDATE storage.buckets
SET public = true
WHERE id = 'paper-submissions';

-- Drop existing policies
DROP POLICY IF EXISTS "Public can upload papers" ON storage.objects;
DROP POLICY IF EXISTS "Only admins can view files" ON storage.objects;
DROP POLICY IF EXISTS "Only admins can manage files" ON storage.objects;

-- Simple public upload policy
CREATE POLICY "Public can upload papers"
ON storage.objects
FOR INSERT
TO public
WITH CHECK (bucket_id = 'paper-submissions');

-- Only admins can view files
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