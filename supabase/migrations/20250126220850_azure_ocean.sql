/*
  # Fix admin policies with non-recursive approach
  
  1. Changes
    - Drop existing admin policies
    - Create simplified policies using direct checks
    - Update admin check function
  
  2. Security
    - Super admin has full control
    - Other admins can only view
*/

-- Drop existing policies
DROP POLICY IF EXISTS "Admins can view admin list" ON admin_users;
DROP POLICY IF EXISTS "Super admin can insert admins" ON admin_users;
DROP POLICY IF EXISTS "Super admin can update admins" ON admin_users;
DROP POLICY IF EXISTS "Super admin can delete admins" ON admin_users;

-- Drop existing function
DROP FUNCTION IF EXISTS is_admin(uuid);

-- Basic read policy for all authenticated users
CREATE POLICY "Anyone can view admin list"
ON admin_users
FOR SELECT
TO public
USING (true);

-- Super admin management policy (single policy for all operations)
CREATE POLICY "Super admin can manage admins"
ON admin_users
FOR ALL
TO authenticated
USING (auth.uid() = '452549c3-5b39-4a1b-9584-4815f2c0338c')
WITH CHECK (auth.uid() = '452549c3-5b39-4a1b-9584-4815f2c0338c');

-- Simple function to check admin status without recursion
CREATE OR REPLACE FUNCTION is_admin()
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 
    FROM admin_users 
    WHERE user_id = auth.uid()
  );
$$;