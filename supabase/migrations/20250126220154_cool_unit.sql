/*
  # Set up super admin user and policies
  
  1. Changes
    - Drop existing policies
    - Create new simplified policies for admin management
    - Insert super admin user
    - Create admin check function
  
  2. Security
    - Enable RLS
    - Add policies for admin viewing and management
*/

-- Drop existing policies to start fresh
DROP POLICY IF EXISTS "Anyone can view admin list" ON admin_users;
DROP POLICY IF EXISTS "Super admin can manage admins" ON admin_users;
DROP POLICY IF EXISTS "Allow first admin creation" ON admin_users;

-- Drop existing function to avoid conflicts
DROP FUNCTION IF EXISTS is_admin(uuid);

-- Insert the super admin
INSERT INTO admin_users (user_id)
VALUES ('452549c3-5b39-4a1b-9584-4815f2c0338c')
ON CONFLICT (user_id) DO NOTHING;

-- Create new simplified policies
CREATE POLICY "Admins can view admin list"
ON admin_users
FOR SELECT
TO authenticated
USING (EXISTS (
  SELECT 1 FROM admin_users WHERE user_id = auth.uid()
));

-- Only super admin can manage other admins (separate policies for each operation)
CREATE POLICY "Super admin can insert admins"
ON admin_users
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = '452549c3-5b39-4a1b-9584-4815f2c0338c');

CREATE POLICY "Super admin can update admins"
ON admin_users
FOR UPDATE
TO authenticated
USING (auth.uid() = '452549c3-5b39-4a1b-9584-4815f2c0338c')
WITH CHECK (auth.uid() = '452549c3-5b39-4a1b-9584-4815f2c0338c');

CREATE POLICY "Super admin can delete admins"
ON admin_users
FOR DELETE
TO authenticated
USING (auth.uid() = '452549c3-5b39-4a1b-9584-4815f2c0338c');

-- Function to safely check if a user is an admin
CREATE OR REPLACE FUNCTION is_admin(uid uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 
    FROM admin_users 
    WHERE user_id = uid
  );
$$;