=Feature: Petclinic REST API - Owners, Pets, and Visits Management

  Background:
    Given the API base URL is configured

  # Owner endpoints
  @owner
  Scenario Outline: Retrieve owner by ID
    When I send a GET request to "/owners/<ownerId>"
    Then the response status code should be <status>
    And the response JSON should contain owner with id <ownerId> and lastName "<lastName>"

    Examples:
      | ownerId | lastName  | status |
      | 1       | Davis     | 200    |
      | 9999    |           | 404    |

  @owner
  Scenario Outline: Create a new owner with valid and invalid data
    Given the following owner data:
      | <field> | <value> |
    When I send a POST request to "/owners" with the owner data
    Then the response status code should be <status>
    And if <status> = 201 then the response JSON should contain owner with lastName "<lastName>"

    Examples:
      | field       | value          | status | lastName  |
      | firstName   | John           | 201    | John     |
      | lastName    | Doe            | 201    | Doe      |
      | address    | 123 Main St     | 201    | Doe      |
      | city       | Springfield     | 201    | Doe      |
      | telephone  | 1234567890      | 201    | Doe      |

  @owner
  Scenario: Create owner with missing mandatory fields
    Given the following owner data:
      | firstName | John |
    When I send a POST request to "/owners" with the owner data
    Then the response status code should be 400

  @owner
  Scenario Outline: Update existing owner with valid and invalid data
    Given the following owner data:
      | lastName | <lastName> |
    When I send a PUT request to "/owners/<ownerId>" with the owner data
    Then the response status code should be <status>
    And if <status> = 204 then I send a GET request to "/owners/<ownerId>"
    And if <status> = 204 then the response JSON should contain owner with lastName "<lastName>"

    Examples:
      | ownerId | lastName  | status |
      | 1       | Smith     | 204    |
      | 9999    | Unknown   | 404    |

  @owner
  Scenario Outline: Delete owner by ID
    When I send a DELETE request to "/owners/<ownerId>"
    Then the response status code should be <status>
    When I send a GET request to "/owners/<ownerId>"
    Then the response status code should be <getStatus>

    Examples:
      | ownerId | status | getStatus |
      | 1       | 204    | 404       |
      | 9999    | 404    | 404       |

  # Pet endpoints
  @pet
  Scenario Outline: Retrieve pet by ID
    When I send a GET request to "/pets/<petId>"
    Then the response status code should be <status>
    And the response JSON should contain pet with id <petId> and name "<name>"

    Examples:
      | petId | name    | status |
      | 1     | Leo     | 200    |
      | 9999  |         | 404    |

  @pet
  Scenario Outline: Create a new pet with valid and invalid data
    Given the following pet data:
      | <field> | <value> |
    When I send a POST request to "/pets" with the pet data
    Then the response status code should be <status>
    And if <status> = 201 then the response JSON should contain pet with name "<name>"

    Examples:
      | field    | value     | status | name    |
      | name     | Buddy     | 201    | Buddy   |
      | birthDate| 2015-03-15| 201    | Buddy   |
      | type     | Dog       | 201    | Buddy   |

  @pet
  Scenario: Create pet with missing mandatory fields
    Given the following pet data:
      | name |       |
    When I send a POST request to "/pets" with the pet data
    Then the response status code should be 400

  @pet
  Scenario Outline: Update existing pet with valid and invalid data
    Given the following pet data:
      | name | <name> |
    When I send a PUT request to "/pets/<petId>" with the pet data
    Then the response status code should be <status>
    And if <status> = 204 then I send a GET request to "/pets/<petId>"
    And if <status> = 204 then the response JSON should contain pet with name "<name>"

    Examples:
      | petId | name    | status |
      | 1     | Max     | 204    |
      | 9999  | Unknown | 404    |

  @pet
  Scenario Outline: Delete pet by ID
    When I send a DELETE request to "/pets/<petId>"
    Then the response status code should be <status>
    When I send a GET request to "/pets/<petId>"
    Then the response status code should be <getStatus>

    Examples:
      | petId | status | getStatus |
      | 1     | 204    | 404       |
      | 9999  | 404    | 404       |

  # Visit endpoints
  @visit
  Scenario Outline: Retrieve visit by ID
    When I send a GET request to "/visits/<visitId>"
    Then the response status code should be <status>
    And the response JSON should contain visit with id <visitId> and description "<description>"

    Examples:
      | visitId | description           | status |
      | 1       | Annual checkup        | 200    |
      | 9999    |                       | 404    |

  @visit
  Scenario Outline: Create a new visit with valid and invalid data
    Given the following visit data:
      | <field> | <value> |
    When I send a POST request to "/visits" with the visit data
    Then the response status code should be <status>
    And if <status> = 201 then the response JSON should contain visit with description "<description>"

    Examples:
      | field       | value            | status | description       |
      | date        | 2023-04-01       | 201    | Annual checkup    |
      | description | Regular checkup  | 201    | Regular checkup   |

  @visit
  Scenario: Create visit with missing mandatory fields
    Given the following visit data:
      | description |       |
    When I send a POST request to "/visits" with the visit data
    Then the response status code should be 400

  @visit
  Scenario Outline: Update existing visit with valid and invalid data
    Given the following visit data:
      | description | <description> |
    When I send a PUT request to "/visits/<visitId>" with the visit data
    Then the response status code should be <status>
    And if <status> = 204 then I send a GET request to "/visits/<visitId>"
    And if <status> = 204 then the response JSON should contain visit with description "<description>"

    Examples:
      | visitId | description       | status |
      | 1       | Updated visit     | 204    |
      | 9999    | Unknown visit     | 404    |

  @visit
  Scenario Outline: Delete visit by ID
    When I send a DELETE request to "/visits/<visitId>"
    Then the response status code should be <status>
    When I send a GET request to "/visits/<visitId>"
    Then the response status code should be <getStatus>

    Examples:
      | visitId | status | getStatus |
      | 1       | 204    | 404       |
      | 9999    | 404    | 404       |

  # Validation and error scenarios
  @validation
  Scenario Outline: Send malformed JSON in POST request to <endpoint>
    Given the following raw JSON body:
      """
      <rawJson>
      """
    When I send a POST request to "<endpoint>" with raw body
    Then the response status code should be 400

    Examples:
      | endpoint  | rawJson                          |
      | /owners   | { "firstName": "John",          |
      | /pets     | { "name": "Buddy", "birthDate": |
      | /visits   | { "date": "2023-04-01"          |

  @validation
  Scenario Outline: Send malformed JSON in PUT request to <endpoint>/<id>
    Given the following raw JSON body:
      """
      <rawJson>
      """
    When I send a PUT request to "<endpoint>/<id>" with raw body
    Then the response status code should be 400

    Examples:
      | endpoint | id  | rawJson                         |
      | /owners  | 1   | { "lastName": "Smith"           |
      | /pets    | 1   | { "name": "Max"                 |
      | /visits  | 1   | { "description": "Checkup"      |

  @validation
  Scenario Outline: Send GET request to invalid endpoint <endpoint>
    When I send a GET request to "<endpoint>"
    Then the response status code should be 404

    Examples:
      | endpoint          |
      | /owners/abc       |
      | /pets/abc         |
      | /visits/abc       |
      | /unknown          |