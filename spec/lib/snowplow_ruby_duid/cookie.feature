Feature: Creating a Snowplow cookie

  Background:
    Given the host is 'www.simplybusiness.co.uk'
      And the domain_userid is 'domain_user_id'
      And the time is '2015-01-22 15:26:31 +0000'

  Scenario: The cookie should apply to the root path (/)
    When I create a Snowplow cookie
    Then the cookie has the path '/'

  Scenario: The cookie should set same_site to none
    When I create a Snowplow cookie
    Then the cookie has the SameSite attribute set to none

  Scenario: The cookie should set secure if http
    When I create a Snowplow cookie
    And the request scheme is https
    Then the cookie has the secure attribute

  Scenario Outline: The cookie should apply for all domains under the top-level domain (no domain for localhost or IP addresses, however)
    Given the host is '<host>'
     When I create a Snowplow cookie
     Then the cookie has the domain '<cookie domain>'

    Examples:
      | host                           | cookie domain         |
      | localhost                      |                       |
      | 127.0.0.1                      |                       |
      | 192.168.2.40                   |                       |
      | www.simplybusiness.co.uk       | .simplybusiness.co.uk |
      | www.quote.simplybusiness.co.uk | .simplybusiness.co.uk |
      | simplybusiness.co.uk           | .simplybusiness.co.uk |
      | www.simplybusiness.com         | .simplybusiness.com   |

  Scenario Outline: The cookie should be named using the _sp_id prefix, followed by a 4 character hash generated from the top-level domain and root path
    Given the host is '<host>'
     When I create a Snowplow cookie
     Then the cookie has the name '<cookie name>'

    Examples:
      | host                           | cookie name |
      | localhost                      | _sp_id.1fff |
      | 127.0.0.1                      | _sp_id.dc78 |
      | 192.168.2.40                   | _sp_id.f0ae |
      | www.simplybusiness.co.uk       | _sp_id.8fb9 |
      | www.quote.simplybusiness.co.uk | _sp_id.8fb9 |
      | simplybusiness.co.uk           | _sp_id.8fb9 |
      | www.simplybusiness.com         | _sp_id.bdbc |

  Scenario: The cookie should expire after 2 years
    When I create a Snowplow cookie
    Then the cookie expires at '2017-01-22 15:26:31 +0000'

  Scenario: The cookie's value should be in the following format: domain_userid.createTs.visitCount.nowTs.lastVisitTs
    When I create a Snowplow cookie
    Then the cookie value is 'domain_user_id.1421940391.0.1421940391.'
     And the cookie value for 'domain_userid' is 'domain_user_id'
     And the cookie value for 'createTs' is '1421940391'
     And the cookie value for 'visitCount' is '0'
     And the cookie value for 'nowTs' is '1421940391'
     And the cookie value for 'lastVisitTs' is ''
