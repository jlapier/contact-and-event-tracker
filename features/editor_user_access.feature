Feature: Editor user access
  In order to allow trusted users to manage some content
  I want to allow editor users to create and update events, contacts, contact groups and file attachments

  Background:
    Given I am logged in as a "editor" user
  
  Scenario Outline: editor users cannot create or update users
    When I go to <page>
    Then I should see "Sorry your account is not authorized to do that."
    And I should be on the home page
    Examples:
    | page                                  |
    | the users page                        |
    | the new users page                    |
    | edit the user "general.user@test.com" |

  Scenario Outline: editor users can view events, contacts, contact groups and download file attachments
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

  Scenario Outline: editor users can update events, contacts, contact groups
    When I go to <page>
    And I press "<button>"
    Then I should be on <next_page>
    And I should not see "Sorry your account is not authorized to do that."
    Examples:
    | page                            | button         | next_page                           |
    | the new event page              | Create Event   | the events page                     |
    | edit the event "Some Event"     | Update Event   | the event page for "Some Event"     |
    | edit the contact "General User" | Update Contact | the contact page for "General User" |
  
  @javascript
  Scenario: editor users can upload file attachments
    When I go to the event page for "Some Event"
    And I follow "Upload Files"
    And I follow "One at a time"
    And I press "Create File attachment"
    Then I should be on the event page for "Some Event"
    And I should see "No files were selected for upload."


  @javascript
  Scenario: editor users can view contact email addresses
    When I go to the contacts page
    Then I should not see "login to view emails"
    And I should see "Body, Some"
    And I should see "some.body@test.com"
