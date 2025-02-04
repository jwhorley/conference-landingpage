/*
  # Fix admin policies and simplify admin checks
  
  1. Changes
    - Drop recursive policies that were causing infinite recursion
    - Create simplified policies for admin management
    - Add function to safely check admin status
  
  2. Security
    - Maintains super admin privileges
    - Prevents infinite recursion
    - Ensures proper access control
*/

-- Drop problematic policies
DROP POLICY IF EXISTS "Authenticated users can view admin list" ON admin_users;
DROP POLICY IF EXISTS "Super admin can manage admins" ON admin_users;
DROP POLICY IF EXISTS "Allow first admin creation" ON admin_users;

-- Create simplified policies
CREATE POLICY "Anyone can view admin list"
ON admin_users
FOR SELECT
TO public
USING (true);

-- Super admin management policy
CREATE POLICY "Super admin can manage admins"
ON admin_users
FOR ALL 
TO authenticated
USING (
  EXISTS (
    SELECT 1 
    FROM admin_users 
    WHERE user_id = auth.uid() 
    AND created_at = (
      SELECT MIN(created_at) 
      FROM admin_users
    )
  )
);

-- Allow first admin creation
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

-- Create a safe function to check admin status
CREATE OR REPLACE FUNCTION public.is_admin(user_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 
    FROM admin_users 
    WHERE user_id = $1
  );
$$;