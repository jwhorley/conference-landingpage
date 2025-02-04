/*
  # Fix storage policies with non-recursive approach
  
  1. Changes
    - Drop existing storage policies
    - Create simplified storage policies using direct user checks
    - Separate policies for different operations
  
  2. Security
    - Allow public uploads for submissions
    - Restrict admin access using direct user ID checks
*/

-- Drop existing policies
DROP POLICY IF EXISTS "Allow paper uploads" ON storage.objects;
DROP POLICY IF EXISTS "Admins can view papers" ON storage.objects;
DROP POLICY IF EXISTS "Admins can manage papers" ON storage.objects;

-- Create separate policies for different operations
CREATE POLICY "Anyone can upload submissions"
ON storage.objects
FOR INSERT
TO public
WITH CHECK (
  bucket_id = 'paper-submissions'
  AND LENGTH(name) > 1
  AND LENGTH(name) < 255
);

-- Allow submitters to view their own uploads
CREATE POLICY "Submitters can view their uploads"
ON storage.objects
FOR SELECT
TO public
USING (
  bucket_id = 'paper-submissions'
  AND owner = auth.uid()
);

-- Super admin can view all submissions
CREATE POLICY "Super admin can view all submissions"
ON storage.objects
FOR SELECT
TO authenticated
USING (
  bucket_id = 'paper-submissions'
  AND auth.uid() = '452549c3-5b39-4a1b-9584-4815f2c0338c'
);

-- Super admin can manage all submissions
CREATE POLICY "Super admin can manage all submissions"
ON storage.objects
FOR ALL
TO authenticated
USING (
  bucket_id = 'paper-submissions'
  AND auth.uid() = '452549c3-5b39-4a1b-9584-4815f2c0338c'
);