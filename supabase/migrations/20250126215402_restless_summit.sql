/*
  # Query to check super admin
  
  This query will:
  1. Find the first admin user (super admin)
  2. Join with auth.users to get their email
*/

SELECT au.user_id, u.email, au.created_at
FROM admin_users au
JOIN auth.users u ON au.user_id = u.id
WHERE au.created_at = (
  SELECT MIN(created_at) 
  FROM admin_users
);