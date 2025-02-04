/*
  # Query to check super admin
  
  This migration adds a function to safely check who is the super admin
  without modifying any existing policies or data.
*/

-- Function to get super admin info
CREATE OR REPLACE FUNCTION get_super_admin_info()
RETURNS TABLE (
  user_id uuid,
  email text,
  created_at timestamptz
) 
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT au.user_id, u.email, au.created_at
  FROM admin_users au
  JOIN auth.users u ON au.user_id = u.id
  WHERE au.created_at = (
    SELECT MIN(created_at) 
    FROM admin_users
  )
  ORDER BY au.created_at ASC
  LIMIT 1;
$$;