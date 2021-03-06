module Sensu
  module Settings
    module Validators
      module API
        # Validate API authentication.
        # Validates: user, password
        #
        # @param api [Hash] sensu api definition.
        def validate_api_authentication(api)
          if either_are_set?(api[:user], api[:password])
            must_be_a_string(api[:user]) ||
              invalid(api, "api user must be a string")
            must_be_a_string(api[:password]) ||
              invalid(api, "api password must be a string")
          end
        end

        # Validate a Sensu API definition.
        # Validates: port, bind
        #
        # @param api [Hash] sensu api definition.
        def validate_api(api)
          must_be_a_hash_if_set(api) ||
            invalid(api, "api must be a hash")
          if is_a_hash?(api)
            must_be_an_integer_if_set(api[:port]) ||
              invalid(api, "api port must be an integer")
            must_be_a_string_if_set(api[:bind]) ||
              invalid(api, "api bind must be a string")
            validate_api_authentication(api)
          end
        end
      end
    end
  end
end
