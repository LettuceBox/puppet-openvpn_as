# == Class: openvpn_as::config::db
#
class openvpn_as::config::db(
    $use_mysql      = false,
    $mysql_username = 'openvpn',
    $mysql_password = 'defaultpassword',
    $mysql_host     = 'localhost',
) {

  # Prepare the database paths (MySQL or SQLite):
  if $use_mysql {
    $openvpn_certs_db     = "mysql://${mysql_username}:${mysql_password}@${mysql_host}/as_certs"
    $openvpn_user_prop_db = "mysql://${mysql_username}:${mysql_password}@${mysql_host}/as_userprop"
    $openvpn_config_db    = "mysql://${mysql_username}:${mysql_password}@${mysql_host}/as_config"
    $openvpn_log_db       = "mysql://${mysql_username}:${mysql_password}@${mysql_host}/as_log"
  } else {
    $openvpn_certs_db     = 'sqlite:///~/db/certs.db'
    $openvpn_user_prop_db = 'sqlite:///~/db/userprop.db'
    $openvpn_config_db    = 'sqlite:///~/db/config.db'
    $openvpn_log_db       = 'sqlite:///~/db/log.db'
  }
}
