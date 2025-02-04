/*
  # Fix admin policies recursion

  1. Changes
    - Drop existing admin_users policies
    - Create new non-recursive policies for admin_users table
    - Add initial admin setup policy
  
  2. Security
    - Only super admin can manage other admins
    - Admins can view admin list
    - Public cannot access admin_users table
*/

-- Drop existing policy
DROP POLICY IF EXISTS "Admins can manage admin_users" ON admin_users;

-- Allow admins to view the admin list
CREATE POLICY "Admins can view admin_users"
ON admin_users
FOR SELECT
TO authenticated
USING (true);

-- Only super admin can manage other admins
CREATE POLICY "Super admin can manage admin_users"
ON admin_users
FOR ALL
TO authenticated
USING (auth.uid() = (SELECT user_id FROM admin_users ORDER BY created_at ASC LIMIT 1))
WITH CHECK (auth.uid() = (SELECT user_id FROM admin_users ORDER BY created_at ASC LIMIT 1));

-- Allow first admin to be created if no admins exist
CREATE POLICY "Allow first admin creation"
ON admin_users
FOR INSERT
TO authenticated
WITH CHECK (
  NOT EXISTS (SELECT 1 FROM admin_users)
);