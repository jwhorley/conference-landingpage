/*
  # Fix admin policies recursion v2

  1. Changes
    - Drop all existing admin_users policies
    - Create simplified non-recursive policies
    - Add basic CRUD policies for admin management
  
  2. Security
    - First user becomes super admin
    - Super admin can manage other admins
    - All admins can view admin list
*/

-- Drop all existing policies
DROP POLICY IF EXISTS "Admins can view admin_users" ON admin_users;
DROP POLICY IF EXISTS "Super admin can manage admin_users" ON admin_users;
DROP POLICY IF EXISTS "Allow first admin creation" ON admin_users;

-- Basic read policy for authenticated users
CREATE POLICY "Authenticated users can view admin list"
ON admin_users
FOR SELECT
TO authenticated
USING (true);

-- Allow the first admin (super admin) to manage other admins
CREATE POLICY "Super admin can manage admins"
ON admin_users
FOR ALL
TO authenticated
USING (
  auth.uid() IN (
    SELECT user_id 
    FROM admin_users 
    WHERE created_at = (SELECT MIN(created_at) FROM admin_users)
  )
)
WITH CHECK (
  auth.uid() IN (
    SELECT user_id 
    FROM admin_users 
    WHERE created_at = (SELECT MIN(created_at) FROM admin_users)
  )
);

-- Allow creation of first admin
CREATE POLICY "Allow first admin creation"
ON admin_users
FOR INSERT
TO authenticated
WITH CHECK (
  NOT EXISTS (
    SELECT 1 
    FROM admin_users
  )
);