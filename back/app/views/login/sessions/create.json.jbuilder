json.merge!(
  redirect: current_user.profile_admin? ? admin_session_path : standard_session_path
)
