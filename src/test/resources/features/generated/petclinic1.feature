=```gherkin
Feature: Owner Management REST API

  Background:
    Given the user has role "OWNER_ADMIN"

  # Happy path scenarios
  Scenario: Retrieve an existing owner by ID
    Given an owner with ID 1 exists
    When the client requests GET /api/owners/1
    Then the response status should be 200 OK
    And the response body should contain owner details with ID 1

  Scenario: List owners filtered by last name
    Given owners with last name starting with "Davis" exist
    When the client requests GET /api/owners?lastName=Davis
    Then the response status should be 200 OK
    And the response body should contain a list of owners with last name starting with "Davis"

  Scenario: List all owners
    Given owners exist in the system
    When the client requests GET /api/owners
    Then the response status should be 200 OK
    And the response body should contain a list of all owners

  Scenario: Create a new owner with valid data
    Given a valid owner payload without ID
    When the client requests POST /api/owners with the payload
    Then the response status should be 201 Created
    And the response Location header should point to the new owner resource
    And the response body should contain the created owner details

  Scenario: Update an existing owner with valid data
    Given an owner with ID 1 exists
    And a valid owner update payload
    When the client requests PUT /api/owners/1 with the payload
    Then the response status should be 204 No Content
    And the owner data is updated accordingly

  Scenario: Delete an existing owner
    Given an owner with ID 1 exists
    When the client requests DELETE /api/owners/1
    Then the response status should be 204 No Content
    And the owner is removed from the system

  Scenario: Add a new pet to an existing owner
    Given an owner with ID 1 exists
    And a valid pet payload without ID
    When the client requests POST /api/owners/1/pets with the payload
    Then the response status should be 201 Created
    And the response Location header should point to the new pet resource
    And the response body should contain the created pet details

  Scenario: Update an existing pet of an owner
    Given an owner with ID 1 exists
    And a pet with ID 2 exists for owner 1
    And a valid pet update payload
    When the client requests PUT /api/owners/1/pets/2 with the payload
    Then the response status should be 204 No Content
    And the pet data is updated accordingly

  Scenario: Add a visit to an owner's pet
    Given an owner with ID 1 exists
    And a pet with ID 2 exists for owner 1
    And a valid visit payload without ID
    When the client requests POST /api/owners/1/pets/2/visits with the payload
    Then the response status should be 201 Created
    And the response Location header should point to the new visit resource
    And the response body should contain the created visit details

  Scenario: Retrieve an owner's pet by IDs
    Given an owner with ID 1 exists
    And a pet with ID 2 exists for owner 1
    When the client requests GET /api/owners/1/pets/2
    Then the response status should be 200 OK
    And the response body should contain the pet details

  # Validation scenarios
  Scenario Outline: Create owner with invalid data
    Given an owner payload with invalid "<field>" as "<value>"
    When the client requests POST /api/owners with the payload
    Then the response status should be 400 Bad Request
    And the response body should contain validation error for "<field>"

    Examples:
      | field      | value      |
      | firstName  | ""         |
      | lastName   | ""         |
      | address    | ""         |
      | city       | ""         |
      | telephone  | "abc"      |
      | telephone  | "123"      |
      | telephone  | "123456789012" |

  Scenario Outline: Create pet with invalid data
    Given an owner with ID 1 exists
    And a pet payload with invalid "<field>" as "<value>"
    When the client requests POST /api/owners/1/pets with the payload
    Then the response status should be 400 Bad Request
    And the response body should contain validation error for "<field>"

    Examples:
      | field     | value           |
      | name      | ""              |
      | type      | null            |
      | type.id   | null            |
      | birthDate | future date     |
      | birthDate | older than 50y  |

  Scenario Outline: Create visit with invalid data
    Given a visit payload with invalid "<field>" as "<value>"
    When the client requests POST /api/visits with the payload
    Then the response status should be 400 Bad Request
    And the response body should contain validation error for "<field>"

    Examples:
      | field       | value  |
      | description | ""     |

  Scenario Outline: Create vet with invalid data
    Given a vet payload with invalid "<field>" as "<value>"
    When the client requests POST /api/vets with the payload
    Then the response status should be 400 Bad Request
    And the response body should contain validation error for "<field>"

    Examples:
      | field     | value |
      | firstName | ""    |
      | lastName  | ""    |

  Scenario Outline: Create specialty with invalid data
    Given a specialty payload with invalid "<field>" as "<value>"
    When the client requests POST /api/specialties with the payload
    Then the response status should be 400 Bad Request
    And the response body should contain validation error for "<field>"

    Examples:
      | field | value |
      | name  | ""    |

  Scenario Outline: Create pet type with invalid data
    Given a pet type payload with invalid "<field>" as "<value>"
    When the client requests POST /api/pettypes with the payload
    Then the response status should be 400 Bad Request
    And the response body should contain validation error for "<field>"

    Examples:
      | field | value |
      | name  | ""    |

  Scenario Outline: Create user with invalid data
    Given a user payload with invalid "<field>" as "<value>"
    When the client requests POST /api/users with the payload
    Then the response status should be 400 Bad Request
    And the response body should contain validation error for "<field>"

    Examples:
      | field    | value |
      | username | ""    |
      | password | ""    |
      | roles    | empty |

  # Negative scenarios
  Scenario: Retrieve non-existing owner by ID
    Given no owner exists with ID 9999
    When the client requests GET /api/owners/9999
    Then the response status should be 404 Not Found

  Scenario: Update non-existing owner
    Given no owner exists with ID 9999
    When the client requests PUT /api/owners/9999 with valid payload
    Then the response status should be 404 Not Found

  Scenario: Delete non-existing owner
    Given no owner exists with ID 9999
    When the client requests DELETE /api/owners/9999
    Then the response status should be 404 Not Found

  Scenario: Add pet to non-existing owner
    Given no owner exists with ID 9999
    When the client requests POST /api/owners/9999/pets with valid payload
    Then the response status should be 404 Not Found

  Scenario: Update non-existing pet for existing owner
    Given an owner with ID 1 exists
    And no pet exists with ID 9999
    When the client requests PUT /api/owners/1/pets/9999 with valid payload
    Then the response status should be 404 Not Found

  Scenario: Retrieve non-existing pet for existing owner
    Given an owner with ID 1 exists
    And no pet exists with ID 9999 for owner 1
    When the client requests GET /api/owners/1/pets/9999
    Then the response status should be 404 Not Found

  Scenario: Retrieve non-existing pet type
    Given no pet type exists with ID 9999
    When the client requests GET /api/pettypes/9999
    Then the response status should be 404 Not Found

  Scenario: Retrieve non-existing specialty
    Given no specialty exists with ID 9999
    When the client requests GET /api/specialties/9999
    Then the response status should be 404 Not Found

  Scenario: Retrieve non-existing vet
    Given no vet exists with ID 9999
    When the client requests GET /api/vets/9999
    Then the response status should be 404 Not Found

  Scenario: Retrieve non-existing visit
    Given no visit exists with ID 9999
    When the client requests GET /api/visits/9999
    Then the response status should be 404 Not Found

  Scenario: Delete non-existing pet
    Given no pet exists with ID 9999
    When the client requests DELETE /api/pets/9999
    Then the response status should be 404 Not Found

  Scenario: Delete non-existing visit
    Given no visit exists with ID 9999
    When the client requests DELETE /api/visits/9999
    Then the response status should be 404 Not Found

  Scenario: Create pet with unknown owner (foreign key violation)
    Given no owner exists with ID 9999
    When the client requests POST /api/owners/9999/pets with valid pet payload
    Then the response status should be 404 Not Found
    And the response body should contain a data constraint violation message

  Scenario: Unexpected server error during owner creation
    Given a valid owner payload
    When the client requests POST /api/owners with the payload
    And the server throws an unexpected exception
    Then the response status should be 500 Internal Server Error
    And the response body should contain a generic error message

  Scenario: Unexpected server error during pet creation
    Given an owner with ID 1 exists
    And a valid pet payload
    When the client requests POST /api/owners/1/pets with the payload
    And the server throws an unexpected exception
    Then the response status should be 500 Internal Server Error
    And the response body should contain a generic error message

  # REST API behavior
  Scenario: List owners returns 404 when no owners found
    Given no owners exist with last name "Nonexistent"
    When the client requests GET /api/owners?lastName=Nonexistent
    Then the response status should be 404 Not Found

  Scenario: List pets returns 404 when no pets exist
    Given no pets exist in the system
    When the client requests GET /api/pets
    Then the response status should be 404 Not Found

  Scenario: List visits returns 404 when no visits exist
    Given no visits exist in the system
    When the client requests GET /api/visits
    Then the response status should be 404 Not Found

  Scenario: List vets returns 404 when no vets exist
    Given no vets exist in the system
    When the client requests GET /api/vets
    Then the response status should be 404 Not Found

  Scenario: List specialties returns 404 when no specialties exist
    Given no specialties exist in the system
    When the client requests GET /api/specialties
    Then the response status should be 404 Not Found

  Scenario: List pet types returns 404 when no pet types exist
    Given no pet types exist in the system
    When the client requests GET /api/pettypes
    Then the response status should be 404 Not Found

  Scenario: Create user without roles returns 400 Bad Request
    Given a user payload without roles
    When the client requests POST /api/users with the payload
    Then the response status should be 400 Bad Request

  # Edge cases
  Scenario: Create owner with ID specified in payload (should ignore ID)
    Given a valid owner payload with ID 999
    When the client requests POST /api/owners with the payload
    Then the response status should be 201 Created
    And the created owner ID should be different from 999

  Scenario: Update owner with mismatched path ID and body ID
    Given an owner with ID 1 exists
    And an owner update payload with ID 2
    When the client requests PUT /api/owners/1 with the payload
    Then the response status should be 204 No Content
    And the owner with ID 1 is updated (body ID ignored or validated)

  Scenario: Create pet with birth date exactly 50 years ago (valid)
    Given an owner with ID 1 exists
    And a pet payload with birth date exactly 50 years ago
    When the client requests POST /api/owners/1/pets with the payload
    Then the response status should be 201 Created

  Scenario: Create pet with birth date null (valid)
    Given an owner with ID 1 exists
    And a pet payload with null birth date
    When the client requests POST /api/owners/1/pets with the payload
    Then the response status should be 201 Created

  Scenario: Update pet with null type (invalid)
    Given an owner with ID 1 exists
    And a pet with ID 2 exists for owner 1
    And a pet update payload with null type
    When the client requests PUT /api/owners/1/pets/2 with the payload
    Then the response status should be 400 Bad Request

  Scenario: Create specialty with duplicate name (data integrity violation)
    Given a specialty payload with name "radiology" already exists
    When the client requests POST /api/specialties with the payload
    Then the response status should be 404 Not Found
    And the response body should contain a data constraint violation message

  Scenario: Create pet type with duplicate name (data integrity violation)
    Given a pet type payload with name "dog" already exists
    When the client requests POST /api/pettypes with the payload
    Then the response status should be 404 Not Found
    And the response body should contain a data constraint violation message
```