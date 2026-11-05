=Feature: Petclinic REST API - Owners, Pets, and Visits Management

  Background:
    Given the API base URL is configured

  # Owner endpoints
  @Owner
  Scenario Outline: Retrieve owner by ID
    When I send a GET request to "/owners/<ownerId>"
    Then the response status code should be <status>
    And the response JSON should contain owner with id <ownerId> and lastName "<lastName>"

    Examples:
      | ownerId | lastName  | status |
      | 1       | Davis     | 200    |
      | 9999    |           | 404    |

  Scenario Outline: Create a new owner with valid data
    Given the following owner data:
      | firstName | <firstName> |
      | lastName  | <lastName>  |
      | address   | <address>   |
      | city      | <city>      |
      | telephone | <telephone> |
    When I send a POST request to "/owners" with the owner data
    Then the response status code should be 201
    And the response JSON should contain owner with lastName "<lastName>"

    Examples:
      | firstName | lastName | address          | city       | telephone  |
      | John      | Doe      | 123 Elm Street   | Springfield| 1234567890 |

  Scenario Outline: Create a new owner with missing required fields
    Given the following owner data:
      | firstName | <firstName> |
      | lastName  | <lastName>  |
      | address   | <address>   |
      | city      | <city>      |
      | telephone | <telephone> |
    When I send a POST request to "/owners" with the owner data
    Then the response status code should be 400

    Examples:
      # Missing lastName
      | firstName | lastName | address        | city     | telephone  |
      | Jane      |          | 456 Oak Street | Metropolis| 9876543210 |
      # Invalid telephone (non-numeric)
      | firstName | lastName | address        | city     | telephone  |
      | Jane      | Smith    | 456 Oak Street | Metropolis| abcdefg    |

  Scenario Outline: Update an existing owner with valid data
    Given the following owner data:
      | firstName | <firstName> |
      | lastName  | <lastName>  |
      | address   | <address>   |
      | city      | <city>      |
      | telephone | <telephone> |
    When I send a PUT request to "/owners/<ownerId>" with the owner data
    Then the response status code should be <status>
    And the response JSON should contain owner with lastName "<lastName>"

    Examples:
      | ownerId | firstName | lastName | address          | city       | telephone  | status |
      | 1       | John      | Updated  | 789 Pine Street  | Gotham     | 1112223333 | 200    |
      | 9999    | John      | Updated  | 789 Pine Street  | Gotham     | 1112223333 | 404    |

  Scenario Outline: Delete an owner by ID
    When I send a DELETE request to "/owners/<ownerId>"
    Then the response status code should be <status>

    Examples:
      | ownerId | status |
      | 1       | 204    |
      | 9999    | 404    |

  # Pet endpoints
  @Pet
  Scenario Outline: Retrieve pet by ID
    When I send a GET request to "/pets/<petId>"
    Then the response status code should be <status>
    And the response JSON should contain pet with id <petId> and name "<name>"

    Examples:
      | petId | name    | status |
      | 1     | Leo     | 200    |
      | 9999  |         | 404    |

  Scenario Outline: Create a new pet with valid data
    Given the following pet data:
      | name  | <name>  |
      | birthDate | <birthDate> |
      | type  | <type>  |
      | ownerId | <ownerId> |
    When I send a POST request to "/pets" with the pet data
    Then the response status code should be 201
    And the response JSON should contain pet with name "<name>"

    Examples:
      | name   | birthDate  | type    | ownerId |
      | Buddy  | 2018-05-20 | dog     | 1       |

  Scenario Outline: Create a new pet with missing or invalid fields
    Given the following pet data:
      | name  | <name>  |
      | birthDate | <birthDate> |
      | type  | <type>  |
      | ownerId | <ownerId> |
    When I send a POST request to "/pets" with the pet data
    Then the response status code should be 400

    Examples:
      # Missing name
      | name | birthDate  | type    | ownerId |
      |      | 2018-05-20 | dog     | 1       |
      # Invalid birthDate format
      | name  | birthDate | type    | ownerId |
      | Max   | 20-05-2018| dog     | 1       |
      # Missing ownerId
      | name  | birthDate  | type    | ownerId |
      | Max   | 2018-05-20 | dog     |         |

  Scenario Outline: Update an existing pet with valid data
    Given the following pet data:
      | name  | <name>  |
      | birthDate | <birthDate> |
      | type  | <type>  |
      | ownerId | <ownerId> |
    When I send a PUT request to "/pets/<petId>" with the pet data
    Then the response status code should be <status>
    And the response JSON should contain pet with name "<name>"

    Examples:
      | petId | name   | birthDate  | type    | ownerId | status |
      | 1     | Max    | 2017-01-01 | cat     | 1       | 200    |
      | 9999  | Max    | 2017-01-01 | cat     | 1       | 404    |

  Scenario Outline: Delete a pet by ID
    When I send a DELETE request to "/pets/<petId>"
    Then the response status code should be <status>

    Examples:
      | petId | status |
      | 1     | 204    |
      | 9999  | 404    |

  # Visit endpoints
  @Visit
  Scenario Outline: Retrieve visit by ID
    When I send a GET request to "/visits/<visitId>"
    Then the response status code should be <status>
    And the response JSON should contain visit with id <visitId> and description "<description>"

    Examples:
      | visitId | description          | status |
      | 1       | Annual check-up      | 200    |
      | 9999    |                      | 404    |

  Scenario Outline: Create a new visit with valid data
    Given the following visit data:
      | date        | <date>        |
      | description | <description> |
      | petId       | <petId>       |
    When I send a POST request to "/visits" with the visit data
    Then the response status code should be 201
    And the response JSON should contain visit with description "<description>"

    Examples:
      | date       | description       | petId |
      | 2023-01-15 | Vaccination       | 1     |

  Scenario Outline: Create a new visit with missing or invalid fields
    Given the following visit data:
      | date        | <date>        |
      | description | <description> |
      | petId       | <petId>       |
    When I send a POST request to "/visits" with the visit data
    Then the response status code should be 400

    Examples:
      # Missing description
      | date       | description | petId |
      | 2023-01-15 |             | 1     |
      # Invalid date format
      | date       | description | petId |
      | 15-01-2023 | Check-up    | 1     |
      # Missing petId
      | date       | description | petId |
      | 2023-01-15 | Check-up    |       |

  Scenario Outline: Update an existing visit with valid data
    Given the following visit data:
      | date        | <date>        |
      | description | <description> |
      | petId       | <petId>       |
    When I send a PUT request to "/visits/<visitId>" with the visit data
    Then the response status code should be <status>
    And the response JSON should contain visit with description "<description>"

    Examples:
      | visitId | date       | description     | petId | status |
      | 1       | 2023-02-01 | Dental cleaning | 1     | 200    |
      | 9999    | 2023-02-01 | Dental cleaning | 1     | 404    |

  Scenario Outline: Delete a visit by ID
    When I send a DELETE request to "/visits/<visitId>"
    Then the response status code should be <status>

    Examples:
      | visitId | status |
      | 1       | 204    |
      | 9999    | 404    |

  # Negative and boundary tests for invalid endpoints and methods
  @Negative
  Scenario Outline: Access invalid endpoint or method
    When I send a <method> request to "<endpoint>"
    Then the response status code should be <status>

    Examples:
      | method | endpoint           | status |
      | GET    | /invalidEndpoint   | 404    |
      | POST   | /owners/1          | 405    |
      | PATCH  | /owners/1          | 405    |
      | PATCH  | /pets/1            | 405    |
      | PATCH  | /visits/1          | 405    |