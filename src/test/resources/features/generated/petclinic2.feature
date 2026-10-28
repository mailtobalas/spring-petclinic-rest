=```gherkin
Feature: Owner Management REST API

  Background:
    Given the user has OWNER_ADMIN role

  # Happy path scenarios
  Scenario: List all owners
    When the client requests GET /api/owners
    Then the response status should be 200 OK
    And the response should contain a list of owners

  Scenario: List owners by last name
    When the client requests GET /api/owners?lastName=Davis
    Then the response status should be 200 OK
    And the response should contain owners with last name starting with "Davis"

  Scenario: Get owner by ID
    Given an owner with ID 1 exists
    When the client requests GET /api/owners/1
    Then the response status should be 200 OK
    And the response should contain owner details with ID 1

  Scenario: Create a new owner
    Given a valid owner payload without ID
    When the client requests POST /api/owners with the payload
    Then the response status should be 201 Created
    And the Location header should contain the URI of the new owner

  Scenario: Update an existing owner
    Given an owner with ID 1 exists
    And a valid owner update payload
    When the client requests PUT /api/owners/1 with the payload
    Then the response status should be 204 No Content

  Scenario: Delete an existing owner
    Given an owner with ID 1 exists
    When the client requests DELETE /api/owners/1
    Then the response status should be 204 No Content

  # Validation scenarios
  Scenario Outline: Create owner with invalid data
    Given an owner payload with invalid "<field>" as "<value>"
    When the client requests POST /api/owners with the payload
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "<field>"

    Examples:
      | field      | value        |
      | firstName  | ""           |
      | lastName   | ""           |
      | address    | ""           |
      | city       | ""           |
      | telephone  | "123"        |
      | telephone  | "abcdefghij" |

  Scenario Outline: Update owner with invalid data
    Given an owner with ID 1 exists
    And an owner update payload with invalid "<field>" as "<value>"
    When the client requests PUT /api/owners/1 with the payload
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "<field>"

    Examples:
      | field      | value        |
      | firstName  | ""           |
      | lastName   | ""           |
      | address    | ""           |
      | city       | ""           |
      | telephone  | "123"        |
      | telephone  | "abcdefghij" |

  # Negative scenarios
  Scenario: Get owner by non-existing ID
    When the client requests GET /api/owners/999999
    Then the response status should be 404 Not Found

  Scenario: Update owner with non-existing ID
    Given a valid owner update payload
    When the client requests PUT /api/owners/999999 with the payload
    Then the response status should be 404 Not Found

  Scenario: Delete owner with non-existing ID
    When the client requests DELETE /api/owners/999999
    Then the response status should be 404 Not Found

  # Edge cases
  Scenario: List owners by last name with no matches
    When the client requests GET /api/owners?lastName=NoSuchLastName
    Then the response status should be 404 Not Found

  Scenario: Create owner with ID specified in payload
    Given an owner payload with ID specified
    When the client requests POST /api/owners with the payload
    Then the response status should be 201 Created
    And the Location header should contain the URI of the new owner

  Scenario: Update owner with mismatched path ID and payload ID
    Given an owner with ID 1 exists
    And an owner update payload with ID 2
    When the client requests PUT /api/owners/1 with the payload
    Then the response status should be 400 Bad Request
    And the response should contain an error about ID mismatch

Feature: Pet Management REST API

  Background:
    Given the user has OWNER_ADMIN role

  # Happy path scenarios
  Scenario: List all pets
    When the client requests GET /api/pets
    Then the response status should be 200 OK
    And the response should contain a list of pets

  Scenario: Get pet by ID
    Given a pet with ID 3 exists
    When the client requests GET /api/pets/3
    Then the response status should be 200 OK
    And the response should contain pet details with ID 3

  Scenario: Create a new pet for an owner
    Given an owner with ID 1 exists
    And a valid pet payload without ID
    When the client requests POST /api/owners/1/pets with the payload
    Then the response status should be 201 Created
    And the Location header should contain the URI of the new pet

  Scenario: Update an existing pet
    Given a pet with ID 3 exists
    And a valid pet update payload
    When the client requests PUT /api/pets/3 with the payload
    Then the response status should be 204 No Content

  Scenario: Delete an existing pet
    Given a pet with ID 3 exists
    When the client requests DELETE /api/pets/3
    Then the response status should be 204 No Content

  # Validation scenarios
  Scenario Outline: Create pet with invalid data
    Given an owner with ID 1 exists
    And a pet payload with invalid "<field>" as "<value>"
    When the client requests POST /api/owners/1/pets with the payload
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "<field>"

    Examples:
      | field    | value           |
      | name     | ""              |
      | type     | null            |
      | type.name| ""              |
      | type.id  | null            |
      | birthDate| a future date   |

  Scenario Outline: Update pet with invalid data
    Given a pet with ID 3 exists
    And a pet update payload with invalid "<field>" as "<value>"
    When the client requests PUT /api/pets/3 with the payload
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "<field>"

    Examples:
      | field    | value           |
      | name     | ""              |
      | type     | null            |
      | birthDate| a future date   |

  # Negative scenarios
  Scenario: Get pet by non-existing ID
    When the client requests GET /api/pets/999999
    Then the response status should be 404 Not Found

  Scenario: Create pet for non-existing owner
    Given no owner with ID 999999 exists
    And a valid pet payload
    When the client requests POST /api/owners/999999/pets with the payload
    Then the response status should be 404 Not Found

  Scenario: Update pet with non-existing ID
    Given a valid pet update payload
    When the client requests PUT /api/pets/999999 with the payload
    Then the response status should be 404 Not Found

  Scenario: Delete pet with non-existing ID
    When the client requests DELETE /api/pets/999999
    Then the response status should be 404 Not Found

  # Edge cases
  Scenario: Create pet with null type
    Given an owner with ID 1 exists
    And a pet payload with null type
    When the client requests POST /api/owners/1/pets with the payload
    Then the response status should be 400 Bad Request
    And the response should contain validation error about type

Feature: Visit Management REST API

  Background:
    Given the user has OWNER_ADMIN role

  # Happy path scenarios
  Scenario: List all visits
    When the client requests GET /api/visits
    Then the response status should be 200 OK
    And the response should contain a list of visits

  Scenario: Get visit by ID
    Given a visit with ID 2 exists
    When the client requests GET /api/visits/2
    Then the response status should be 200 OK
    And the response should contain visit details with ID 2

  Scenario: Create a new visit
    Given a valid visit payload without ID
    When the client requests POST /api/visits with the payload
    Then the response status should be 201 Created
    And the Location header should contain the URI of the new visit

  Scenario: Create a new visit for a pet of an owner
    Given an owner with ID 1 exists
    And a pet with ID 1 exists for owner 1
    And a valid visit payload without ID
    When the client requests POST /api/owners/1/pets/1/visits with the payload
    Then the response status should be 201 Created
    And the Location header should contain the URI of the new visit

  Scenario: Update an existing visit
    Given a visit with ID 2 exists
    And a valid visit update payload
    When the client requests PUT /api/visits/2 with the payload
    Then the response status should be 204 No Content

  Scenario: Delete an existing visit
    Given a visit with ID 2 exists
    When the client requests DELETE /api/visits/2
    Then the response status should be 204 No Content

  # Validation scenarios
  Scenario Outline: Create visit with invalid data
    Given a visit payload with invalid "<field>" as "<value>"
    When the client requests POST /api/visits with the payload
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "<field>"

    Examples:
      | field       | value  |
      | description | ""     |

  Scenario Outline: Update visit with invalid data
    Given a visit with ID 2 exists
    And a visit update payload with invalid "<field>" as "<value>"
    When the client requests PUT /api/visits/2 with the payload
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "<field>"

    Examples:
      | field       | value  |
      | description | ""     |

  # Negative scenarios
  Scenario: Get visit by non-existing ID
    When the client requests GET /api/visits/999999
    Then the response status should be 404 Not Found

  Scenario: Update visit with non-existing ID
    Given a valid visit update payload
    When the client requests PUT /api/visits/999999 with the payload
    Then the response status should be 404 Not Found

  Scenario: Delete visit with non-existing ID
    When the client requests DELETE /api/visits/999999
    Then the response status should be 404 Not Found

Feature: Vet Management REST API

  Background:
    Given the user has VET_ADMIN role

  # Happy path scenarios
  Scenario: List all vets
    When the client requests GET /api/vets
    Then the response status should be 200 OK
    And the response should contain a list of vets

  Scenario: Get vet by ID
    Given a vet with ID 1 exists
    When the client requests GET /api/vets/1
    Then the response status should be 200 OK
    And the response should contain vet details with ID 1

  Scenario: Create a new vet
    Given a valid vet payload without ID
    When the client requests POST /api/vets with the payload
    Then the response status should be 201 Created
    And the Location header should contain the URI of the new vet

  Scenario: Update an existing vet
    Given a vet with ID 1 exists
    And a valid vet update payload
    When the client requests PUT /api/vets/1 with the payload
    Then the response status should be 204 No Content

  Scenario: Delete an existing vet
    Given a vet with ID 1 exists
    When the client requests DELETE /api/vets/1
    Then the response status should be 204 No Content

  # Validation scenarios
  Scenario Outline: Create vet with invalid data
    Given a vet payload with invalid "<field>" as "<value>"
    When the client requests POST /api/vets with the payload
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "<field>"

    Examples:
      | field     | value  |
      | firstName | ""     |
      | lastName  | ""     |

  Scenario Outline: Update vet with invalid data
    Given a vet with ID 1 exists
    And a vet update payload with invalid "<field>" as "<value>"
    When the client requests PUT /api/vets/1 with the payload
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "<field>"

    Examples:
      | field     | value  |
      | firstName | ""     |
      | lastName  | ""     |

  # Negative scenarios
  Scenario: Get vet by non-existing ID
    When the client requests GET /api/vets/999999
    Then the response status should be 404 Not Found

  Scenario: Update vet with non-existing ID
    Given a valid vet update payload
    When the client requests PUT /api/vets/999999 with the payload
    Then the response status should be 404 Not Found

  Scenario: Delete vet with non-existing ID
    When the client requests DELETE /api/vets/999999
    Then the response status should be 404 Not Found

Feature: Specialty Management REST API

  Background:
    Given the user has VET_ADMIN role

  # Happy path scenarios
  Scenario: List all specialties
    When the client requests GET /api/specialties
    Then the response status should be 200 OK
    And the response should contain a list of specialties

  Scenario: Get specialty by ID
    Given a specialty with ID 1 exists
    When the client requests GET /api/specialties/1
    Then the response status should be 200 OK
    And the response should contain specialty details with ID 1

  Scenario: Create a new specialty
    Given a valid specialty payload without ID
    When the client requests POST /api/specialties with the payload
    Then the response status should be 201 Created
    And the Location header should contain the URI of the new specialty

  Scenario: Update an existing specialty
    Given a specialty with ID 1 exists
    And a valid specialty update payload
    When the client requests PUT /api/specialties/1 with the payload
    Then the response status should be 204 No Content

  Scenario: Delete an existing specialty
    Given a specialty with ID 1 exists
    When the client requests DELETE /api/specialties/1
    Then the response status should be 204 No Content

  # Validation scenarios
  Scenario Outline: Create specialty with invalid data
    Given a specialty payload with invalid "<field>" as "<value>"
    When the client requests POST /api/specialties with the payload
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "<field>"

    Examples:
      | field | value |
      | name  | ""    |

  Scenario Outline: Update specialty with invalid data
    Given a specialty with ID 1 exists
    And a specialty update payload with invalid "<field>" as "<value>"
    When the client requests PUT /api/specialties/1 with the payload
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "<field>"

    Examples:
      | field | value |
      | name  | ""    |

  # Negative scenarios
  Scenario: Get specialty by non-existing ID
    When the client requests GET /api/specialties/999999
    Then the response status should be 404 Not Found

  Scenario: Update specialty with non-existing ID
    Given a valid specialty update payload
    When the client requests PUT /api/specialties/999999 with the payload
    Then the response status should be 404 Not Found

  Scenario: Delete specialty with non-existing ID
    When the client requests DELETE /api/specialties/999999
    Then the response status should be 404 Not Found

Feature: PetType Management REST API

  Background:
    Given the user has VET_ADMIN or OWNER_ADMIN role

  # Happy path scenarios
  Scenario: List all pet types
    When the client requests GET /api/pettypes
    Then the response status should be 200 OK
    And the response should contain a list of pet types

  Scenario: Get pet type by ID
    Given a pet type with ID 1 exists
    When the client requests GET /api/pettypes/1
    Then the response status should be 200 OK
    And the response should contain pet type details with ID 1

  Scenario: Create a new pet type
    Given a valid pet type payload without ID
    When the client requests POST /api/pettypes with the payload
    Then the response status should be 201 Created
    And the Location header should contain the URI of the new pet type

  Scenario: Update an existing pet type
    Given a pet type with ID 1 exists
    And a valid pet type update payload
    When the client requests PUT /api/pettypes/1 with the payload
    Then the response status should be 204 No Content

  Scenario: Delete an existing pet type
    Given a pet type with ID 1 exists
    When the client requests DELETE /api/pettypes/1
    Then the response status should be 204 No Content

  # Validation scenarios
  Scenario Outline: Create pet type with invalid data
    Given a pet type payload with invalid "<field>" as "<value>"
    When the client requests POST /api/pettypes with the payload
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "<field>"

    Examples:
      | field | value |
      | name  | ""    |

  Scenario Outline: Update pet type with invalid data
    Given a pet type with ID 1 exists
    And a pet type update payload with invalid "<field>" as "<value>"
    When the client requests PUT /