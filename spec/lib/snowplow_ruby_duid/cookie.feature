Feature: Creating a Snowplow cookie

  Background:
    Given the host is 'www.simplybusiness.co.uk'
      And the domain_userid is 'domain_user_id'
      And the time is '2015-01-22 15:26:31 +0000'

  Scenario: The cookie should apply to the root path (/)
    When I create a Snowplow cookie
    Then the cookie has the path '/'

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
      | 127.0.0.1                      | _sp_id.1fff |
      | 192.168.2.40                   | _sp_id.1fff |
      | www.simplybusiness.co.uk       | _sp_id.1fff |
      | www.quote.simplybusiness.co.uk | _sp_id.1fff |
      | simplybusiness.co.uk           | _sp_id.1fff |
      | www.simplybusiness.com         | _sp_id.1fff |

  Scenario: The cookie should expire after 2 years
    When I create a Snowplow cookie
    Then the cookie expires at '2017-01-22 15:26:31 +0000'

  Scenario: The cookie's value should be in the following format: domain_userid.createTs.visitCount.nowTs.lastVisitTs
    When I create a Snowplow cookie
    Then the cookie value is 'domain_user_id.1111111111.0.1111111111.1111111111'
     And the cookie value for 'domain_userid' is 'domain_user_id'
     And the cookie value for 'createTs' is '1111111111'
     And the cookie value for 'visitCount' is '0'
     And the cookie value for 'nowTs' is '1111111111'
     And the cookie value for 'lastVisitTs' is '1111111111'
