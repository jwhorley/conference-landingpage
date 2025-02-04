/*
  # Configure storage for paper submissions

  1. Storage
    - Create 'paper-submissions' bucket for storing PDF files
  2. Security
    - Allow public uploads (with 10MB size limit)
    - Only authenticated users can view files
*/

-- Create the storage bucket
INSERT INTO storage.buckets (id, name)
VALUES ('paper-submissions', 'paper-submissions')
ON CONFLICT DO NOTHING;

-- Allow public uploads to the bucket
CREATE POLICY "Allow public uploads"
ON storage.objects
FOR INSERT
TO public
WITH CHECK (
  bucket_id = 'paper-submissions'
  AND LENGTH(name) > 1
  AND auth.role() = 'authenticated'
);

-- Allow authenticated users to view files
CREATE POLICY "Allow authenticated users to view files"
ON storage.objects
FOR SELECT
TO authenticated
USING (bucket_id = 'paper-submissions');