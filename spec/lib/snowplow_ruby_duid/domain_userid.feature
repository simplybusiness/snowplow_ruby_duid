Feature: Creating a domain userid

  Background:
    Given a request environment
      And the time is '2015-01-22 15:26:31 +0000'

  Scenario: The domain userid is 16 characters long
    When I create a domain userid
    Then the domain userid has a length of '16'

  Scenario Outline: The time is a component of the domain userid fingerprint
    Given the time is '<time>'
     When I create a domain userid
     Then the domain userid is '<domain_userid>'

    Examples:
      | time                        | domain_userid    |
      | 2015-01-22 15:26:31.0 +0000 | 1111111111111111 |
      | 2015-01-22 15:26:31.1 +0000 | 1111111111111111 |
      | 2016-01-22 15:26:32.0 +0000 | 1111111111111111 |

  Scenario Outline: The HTTP parameters are a component of the domain userid fingerprint
    Given the request environment parameter '<parameter name>' is set to 'a different value'
     When I create a domain userid
     Then the domain userid is '<domain_userid>'

    Examples:
      | parameter name       | domain_userid    |
      | HTTP_ACCEPT          | 1111111111111111 |
      | HTTP_USER_AGENT      | 1111111111111111 |
      | HTTP_ACCEPT_ENCODING | 1111111111111111 |
      | HTTP_ACCEPT_LANGUAGE | 1111111111111111 |
