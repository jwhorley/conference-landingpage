/*
  # Fix storage policies
  
  1. Changes
    - Drop existing storage policies
    - Create simplified storage policies without recursive checks
  
  2. Security
    - Allow public uploads
    - Restrict admin access using direct auth checks
*/

-- Drop existing policies
DROP POLICY IF EXISTS "Public can upload papers" ON storage.objects;
DROP POLICY IF EXISTS "Only admins can view files" ON storage.objects;
DROP POLICY IF EXISTS "Only admins can manage files" ON storage.objects;

-- Simple upload policy without recursive checks
CREATE POLICY "Allow paper uploads"
ON storage.objects
FOR INSERT
TO public
WITH CHECK (
  bucket_id = 'paper-submissions'
  AND LENGTH(name) > 1
  AND LENGTH(name) < 255
);

-- Admin view policy using direct auth check
CREATE POLICY "Admins can view papers"
ON storage.objects
FOR SELECT
TO authenticated
USING (
  bucket_id = 'paper-submissions'
  AND auth.uid() IN (SELECT user_id FROM admin_users)
);

-- Admin management policy using direct auth check
CREATE POLICY "Admins can manage papers"
ON storage.objects
FOR ALL
TO authenticated
USING (
  bucket_id = 'paper-submissions'
  AND auth.uid() IN (SELECT user_id FROM admin_users)
);