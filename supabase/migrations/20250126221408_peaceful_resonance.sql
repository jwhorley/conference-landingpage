/*
  # Fix storage and submissions access policies
  
  1. Changes
    - Simplify storage access policies
    - Add performance index
  
  2. Security
    - Allow public uploads
    - Restrict admin access appropriately
*/

-- Drop existing storage policies
DROP POLICY IF EXISTS "Anyone can upload submissions" ON storage.objects;
DROP POLICY IF EXISTS "Submitters can view their uploads" ON storage.objects;
DROP POLICY IF EXISTS "Super admin can view all submissions" ON storage.objects;
DROP POLICY IF EXISTS "Super admin can manage all submissions" ON storage.objects;
DROP POLICY IF EXISTS "Allow uploads" ON storage.objects;
DROP POLICY IF EXISTS "Allow admin access" ON storage.objects;

-- Simplified storage policies
CREATE POLICY "Allow uploads"
ON storage.objects
FOR INSERT
TO public
WITH CHECK (bucket_id = 'paper-submissions');

CREATE POLICY "Allow admin access"
ON storage.objects
FOR ALL
TO authenticated
USING (
  bucket_id = 'paper-submissions' 
  AND EXISTS (
    SELECT 1 FROM admin_users 
    WHERE user_id = auth.uid()
  )
);

-- Add index to improve query performance
CREATE INDEX IF NOT EXISTS idx_submissions_created_at 
ON submissions(created_at DESC);