Feature: Helper method for accessing and saving a Snowplow domain userid

  Scenario Outline: The helper will return the Snowplow domain userid from the cookie, if it is available. If it is not available, it will generate a domain userid and set it in the cookie.
    Given I set a Snowplow domain userid of '<original domain userid in cookie>' in my cookie
     When I request the Snowplow domain userid
     Then I receive the Snowplow domain userid '<domain userid>'
      And I have the Snowplow domain userid '<current domain userid in cookie>' in my cookie

    Examples:
      | original domain userid in cookie | domain userid    | current domain userid in cookie |
      | 1111111111111111                 | 1111111111111111 | 1111111111111111                |
      |                                  | 0915770cf6e21be4 | 0915770cf6e21be4                |
