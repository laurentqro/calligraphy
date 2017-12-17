require 'calligraphy/rails/mapper'
require 'calligraphy/rails/web_dav_requests_controller'

require 'calligraphy/xml/builder'
require 'calligraphy/xml/namespace'
require 'calligraphy/xml/node'
require 'calligraphy/xml/utils'

require 'calligraphy/utils'
require 'calligraphy/resource/resource'
require 'calligraphy/resource/file_resource'

require 'calligraphy/web_dav_request'
require 'calligraphy/copy'
require 'calligraphy/delete'
require 'calligraphy/get'
require 'calligraphy/lock'
require 'calligraphy/mkcol'
require 'calligraphy/move'
require 'calligraphy/propfind'
require 'calligraphy/proppatch'
require 'calligraphy/put'
require 'calligraphy/unlock'

module Calligraphy
  # Constants used throughout Calligraphy.
  DAV_NS = 'DAV:'
  DAV_NO_LOCK_REGEX = /DAV:no-lock/i
  DAV_NOT_NO_LOCK_REGEX = /Not\s+<DAV:no-lock>/i
  ETAG_IF_REGEX = /\[(.+?)\]/
  INFINITY = 1.0 / 0.0 unless defined? INFINITY
  LOCK_TOKEN_ANGLE_REGEX = /[<>]/
  LOCK_TOKEN_REGEX = /<(urn:uuid:.+?)>/
  RESOURCE_REGEX = /^<+(.+?)>\s/
  TAGGED_LIST_REGEX = /\)\s</
  UNTAGGAGED_LIST_REGEX = /\)\s\(/

  # HTTP methods allowed by the WebDavRequestsController.
  mattr_accessor :allowed_http_methods
  @@allowed_http_methods = %w(
    options head get put delete copy
    move mkcol propfind proppatch lock unlock
  )

  # Proc responsible for returning the user's password, API key,
  # or HA1 digest hash so that Rails can check user credentials.
  # Should be overridden to handle your particular application's
  # user and/or authentication setup.
  mattr_accessor :digest_password_procedure
  @@digest_password_procedure = Proc.new { |username| 'changeme!' }

  # If Digest Authentication is enabled by default.
  mattr_accessor :enable_digest_authentication
  @@enable_digest_authentication = false

  # The realm used in HTTP Basic Authentication.
  mattr_accessor :http_authentication_realm
  @@http_authentication_realm = 'Application'

  # Maximum lock lifetime in seconds.
  mattr_accessor :lock_timeout_period
  @@lock_timeout_period = 24 * 60 * 60

  # The HTTP actions Calligraphy is responsible for handling.
  mattr_accessor :web_dav_actions
  @@web_dav_actions = %i(
    options get put delete copy move
    mkcol propfind proppatch lock unlock
  )

  # Default way to set up Calligraphy.
  # Run `rails generate calligraphy_install` to generate a
  # fresh initializer with all configuration values.
  def self.configure
    yield self
  end
end
