Feature: General user access
  In order to prevent accidents and protect valuable data
  I want to allow general users read-only access to include contact emails

  Background:
    Given I am logged in as a "general" user
  
  Scenario Outline: general users cannot create or update events or users
    When I go to <page>
    Then I should see "Sorry your account is not authorized to do that."
    And I should be on the home page
    Examples:
    | page                                     |
    | the new events page                      |
    | edit the event "Some Event"              |
    | the users page                           |
    | the new users page                       |
    | edit the user "editor.at-large@test.com" |

  Scenario Outline: general users can view events, contacts, contact groups and download file attachments
    When I go to <page>
    Then I should see "<content>"
    And I should be on <page>
    Examples:
    | page                                        | content                                                            |
    | the events page                             | mouse over an event to preview; click on an event for full details |
    | the event page for "Some Event"             | Some really good stuff could happen here.                          |
    | the home page                               | mouse over an event to preview; click on an event for full details |
    | the contacts page                           | At-Large, Editor                                                   |
    | the contact page for "Editor At-Large"      | First name: Editor                                                 |
    | the contact groups page                     | Regional Group                                                     |
    | the contact group page for "Regional Group" | Body, Some                                                         |

  @javascript
  Scenario: general users can view contact email addresses
    When I go to the contacts page
    Then I should not see "login to view emails"
    And I should see "Body, Some"
    And I should see "some.body@test.com"