/*
  # Conference Submissions Schema

  1. New Tables
    - `submissions`
      - `id` (uuid, primary key)
      - `title` (text)
      - `author_name` (text)
      - `author_email` (text)
      - `affiliation` (text)
      - `pdf_url` (text)
      - `status` (text) - Can be 'pending', 'accepted', or 'rejected'
      - `reviewer_notes` (text)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on submissions table
    - Add policies for submission creation and viewing
*/

CREATE TABLE IF NOT EXISTS submissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  author_name text NOT NULL,
  author_email text NOT NULL,
  affiliation text NOT NULL,
  pdf_url text NOT NULL,
  status text DEFAULT 'pending',
  reviewer_notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;

-- Allow anyone to create a submission
CREATE POLICY "Anyone can create submissions"
  ON submissions
  FOR INSERT
  TO public
  WITH CHECK (true);

-- Only authenticated users (reviewers) can view all submissions
CREATE POLICY "Authenticated users can view submissions"
  ON submissions
  FOR SELECT
  TO authenticated
  USING (true);

-- Authors can view their own submissions
CREATE POLICY "Authors can view their own submissions"
  ON submissions
  FOR SELECT
  TO public
  USING (author_email = current_user);