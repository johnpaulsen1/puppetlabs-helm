# frozen_string_literal: true

require 'shellwords'
#
# helm_repo_remove_flags.rb
#
module Puppet::Parser::Functions
  # Transforms a hash into a string of helm repo remove flags
  newfunction(:helm_repo_remove_flags, :type => :rvalue) do |args|
    opts = args[0] || {}
    flags = []
    flags << "'#{opts['repo_name']}'" if opts['repo_name'] && opts['repo_name'].to_s != 'undef'
    flags << "--home '#{opts['home']}'" if opts['home'] && opts['home'].to_s != 'undef'
    flags << "--host '#{opts['host']}'" if opts['host'] && opts['host'].to_s != 'undef'
    flags << "--kube-context '#{opts['kube_context']}'" if opts['kube_context'] && opts['kube_context'].to_s != 'undef'
    flags << "--tiller-namespace '#{opts['tiller_namespace']}'" if opts['tiller_namespace'] && opts['tiller_namespace'].to_s != 'undef'
    flags << "--registry-config '#{opts['reg_config']}'" if opts['reg_config'] && opts['reg_config'].to_s != 'undef'
    flags << "--repository-cache '#{opts['repo_cache']}'" if opts['repo_cache'] && opts['repo_cache'].to_s != 'undef'
    flags << "--repository-config '#{opts['repo_config']}'" if opts['repo_config'] && opts['repo_config'].to_s != 'undef'
    flags.flatten.join(' ')
  end
end
