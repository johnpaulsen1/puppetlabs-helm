# Defined Type helm::repo
#
# @summary
#   Adds a Helm repository.
#
# @param ensure
#   Specifies whether a repo is added.
#   Valid values are 'present', 'absent'.
#
# @param ca_file
#   Verify the certificates of HTTPS-enabled servers that are using the current CA bundle.
#
# @param cert_file
#   Use the SSL certificate file to identify the HTTPS client.
#
# @param debug
#   Specifies whether to enable verbose output.
#   Values true, false.
#
# @param env
#   Sets the environment variables required for Helm to connect to the kubernetes cluster.
#
# @param exec_user
#   The user to run the 'helm repo' command as.
#
# @param key_file
#   Use the SSL key file to identify the HTTPS client.
#
# @param no_update
#   Specifies whether to create an error when the repository is already registered.
#   Values true, false.
#
# @param home
#   Location of your Helm config. This value overrrides $HELM_HOME.
#
# @param host
#   The address for Tiller. This value overrides $HELM_HOST.
#
# @param kube_context
#   The name for the kubeconfig context to use.
#
# @param path
#   The PATH variable used for exec types.
#
# @param tiller_namespace
#   The namespace for Tiller.
#
# @param username
#   The username for the remote repository
#
# @param password
#   The password for the remote repository.
#
# @param repo_cache
#   The path to the file containing cached repository indexes.
#
# @param repo_config
#   The path to the file containing repository names and URLs.
#
# @param reg_config
#   The path to the file containing registry config.
#
# @param repo_name
#   The name for the remote repository.
#
# @param url
#   The URL for the remote repository.
#
define helm::repo (
  String $ensure                     = present,
  Optional[String] $ca_file          = undef,
  Optional[String] $cert_file        = undef,
  Boolean $debug                     = false,
  Optional[Array] $env               = undef,
  Optional[String] $exec_user        = undef,
  Optional[String] $key_file         = undef,
  Boolean $no_update                 = false,
  Optional[String] $home             = undef,
  Optional[String] $host             = undef,
  Optional[String] $kube_context     = undef,
  Optional[Array] $path              = undef,
  Optional[String] $tiller_namespace = undef,
  Optional[String] $username         = undef,
  Optional[String] $password         = undef,
  Optional[String] $reg_config       = undef,
  Optional[String] $repo_cache       = undef,
  Optional[String] $repo_config      = undef,
  Optional[String] $repo_name        = undef,
  Optional[String] $url              = undef,
) {
  include ::helm::params
  if $ensure == present {
    $helm_repo_add_flags = helm_repo_add_flags({
        ensure => $ensure,
        ca_file => $ca_file,
        cert_file => $cert_file,
        debug => $debug,
        key_file => $key_file,
        no_update => $no_update,
        home => $home,
        host => $host,
        kube_context => $kube_context,
        tiller_namespace => $tiller_namespace,
        username => $username,
        password => $password,
        reg_config => $reg_config,
        repo_cache => $repo_cache,
        repo_config => $repo_config,
        repo_name => $repo_name,
        url => $url,
      }
    )
    $exec_repo = "helm repo add ${helm_repo_add_flags}"
    if $repo_config != undef {
      $unless_repo = "helm repo list --repository-config ${repo_config} | awk '{if(NR>1)print \$1}' | grep -w ${repo_name}"
    } else {
      $unless_repo = "helm repo list | awk '{if(NR>1)print \$1}' | grep -w ${repo_name}"
    }
  }

  if $ensure == absent {
    $helm_repo_remove_flags = helm_repo_remove_flags({
        ensure => $ensure,
        home => $home,
        host => $host,
        kube_context => $kube_context,
        reg_config => $reg_config,
        repo_cache => $repo_cache,
        repo_config => $repo_config,
        repo_name => $repo_name,
        tiller_namespace => $tiller_namespace,
      }
    )
    $exec_repo = "helm repo remove ${helm_repo_remove_flags}"
    if $repo_config != undef {
      $unless_repo = "helm repo list --repository-config ${repo_config} | awk '{if (\$1 == \"${repo_name}\") exit 1}'"
    } else {
      $unless_repo = "helm repo list | awk '{if (\$1 == \"${repo_name}\") exit 1}'"
    }
  }

  exec { "helm repo ${repo_name}":
    command     => $exec_repo,
    environment => $env,
    path        => $path,
    user        => $exec_user,
    timeout     => 0,
    unless      => $unless_repo,
    logoutput   => true,
  }
}
