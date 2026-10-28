=```gherkin
Feature: Owner Management REST API

  Background:
    Given the user has role "OWNER_ADMIN"

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
    When the client sends POST /api/owners with valid owner data
    Then the response status should be 201 Created
    And the Location header should contain the URI of the new owner

  Scenario: Update an existing owner
    Given an owner with ID 1 exists
    When the client sends PUT /api/owners/1 with valid updated owner data
    Then the response status should be 204 No Content

  Scenario: Delete an existing owner
    Given an owner with ID 1 exists
    When the client sends DELETE /api/owners/1
    Then the response status should be 204 No Content

  # Validation scenarios
  Scenario: Create owner with missing required fields
    When the client sends POST /api/owners with missing firstName
    Then the response status should be 400 Bad Request
    And the response should contain validation error for firstName

  Scenario: Update owner with empty lastName
    Given an owner with ID 1 exists
    When the client sends PUT /api/owners/1 with empty lastName
    Then the response status should be 400 Bad Request
    And the response should contain validation error for lastName

  # Negative scenarios
  Scenario: Get owner by non-existent ID
    When the client requests GET /api/owners/999999
    Then the response status should be 404 Not Found

  Scenario: Update non-existent owner
    When the client sends PUT /api/owners/999999 with valid owner data
    Then the response status should be 404 Not Found

  Scenario: Delete non-existent owner
    When the client sends DELETE /api/owners/999999
    Then the response status should be 404 Not Found

  # REST API behavior
  Scenario: List owners returns 404 when no owners found
    When the client requests GET /api/owners?lastName=NoSuchLastName
    Then the response status should be 404 Not Found

  Scenario: Create owner returns 500 on unexpected error
    When the client sends POST /api/owners with valid owner data but server error occurs
    Then the response status should be 500 Internal Server Error
    And the response detail should indicate unexpected error

  # Edge cases
  Scenario: Update owner without body ID but with path ID
    Given an owner with ID 1 exists
    When the client sends PUT /api/owners/1 with owner data missing ID field
    Then the response status should be 204 No Content

  Scenario: Update owner with mismatched body ID and path ID
    Given an owner with ID 1 exists
    When the client sends PUT /api/owners/1 with owner data with ID 2
    Then the response status should be 400 Bad Request
    And the response should contain error about ID mismatch


Feature: Pet Management REST API

  Background:
    Given the user has role "OWNER_ADMIN"

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
    When the client sends POST /api/owners/1/pets with valid pet data
    Then the response status should be 201 Created
    And the Location header should contain the URI of the new pet

  Scenario: Update an existing pet
    Given a pet with ID 3 exists
    When the client sends PUT /api/pets/3 with valid updated pet data
    Then the response status should be 204 No Content

  Scenario: Delete an existing pet
    Given a pet with ID 3 exists
    When the client sends DELETE /api/pets/3
    Then the response status should be 204 No Content

  Scenario: Get owner's pet by owner ID and pet ID
    Given an owner with ID 2 exists
    And the owner has a pet with ID 1
    When the client requests GET /api/owners/2/pets/1
    Then the response status should be 200 OK
    And the response should contain pet details with ID 1

  # Validation scenarios
  Scenario: Create pet with missing name
    Given an owner with ID 1 exists
    When the client sends POST /api/owners/1/pets with pet data missing name
    Then the response status should be 400 Bad Request
    And the response should contain validation error for pet name

  Scenario: Create pet with null type
    Given an owner with ID 1 exists
    When the client sends POST /api/owners/1/pets with pet data with null type
    Then the response status should be 400 Bad Request
    And the response should contain validation error for pet type

  Scenario: Create pet with empty type name
    Given an owner with ID 1 exists
    When the client sends POST /api/owners/1/pets with pet data with empty type name
    Then the response status should be 400 Bad Request
    And the response should contain validation error for pet type name

  Scenario: Create pet with null type ID
    Given an owner with ID 1 exists
    When the client sends POST /api/owners/1/pets with pet data with null type ID
    Then the response status should be 400 Bad Request
    And the response should contain validation error for pet type ID

  Scenario: Update pet with null name
    Given a pet with ID 3 exists
    When the client sends PUT /api/pets/3 with pet data with null name
    Then the response status should be 400 Bad Request
    And the response should contain validation error for pet name

  Scenario: Create pet with birth date in the future
    Given an owner with ID 1 exists
    When the client sends POST /api/owners/1/pets with pet birth date in the future
    Then the response status should be 400 Bad Request
    And the response should contain validation error for birth date

  Scenario: Create pet with birth date older than 50 years
    Given an owner with ID 1 exists
    When the client sends POST /api/owners/1/pets with pet birth date older than 50 years
    Then the response status should be 400 Bad Request
    And the response should contain validation error for birth date

  # Negative scenarios
  Scenario: Get pet by non-existent ID
    When the client requests GET /api/pets/999999
    Then the response status should be 404 Not Found

  Scenario: Update non-existent pet
    When the client sends PUT /api/pets/999999 with valid pet data
    Then the response status should be 404 Not Found

  Scenario: Delete non-existent pet
    When the client sends DELETE /api/pets/999999
    Then the response status should be 404 Not Found

  Scenario: Create pet for non-existent owner
    When the client sends POST /api/owners/999999/pets with valid pet data
    Then the response status should be 404 Not Found

  Scenario: Create pet returns 500 on unexpected error
    Given an owner with ID 1 exists
    When the client sends POST /api/owners/1/pets with valid pet data but server error occurs
    Then the response status should be 500 Internal Server Error
    And the response detail should indicate unexpected error

  # REST API behavior
  Scenario: List pets returns 404 when no pets found
    When the client requests GET /api/pets
    And no pets exist
    Then the response status should be 404 Not Found

  # Edge cases
  Scenario: Update owner's pet with non-existent owner
    When the client sends PUT /api/owners/0/pets/3 with valid pet data
    Then the response status should be 404 Not Found

  Scenario: Update owner's pet with non-existent pet
    Given an owner with ID 1 exists
    When the client sends PUT /api/owners/1/pets/0 with valid pet data
    Then the response status should be 404 Not Found


Feature: Visit Management REST API

  Background:
    Given the user has role "OWNER_ADMIN"

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
    When the client sends POST /api/visits with valid visit data
    Then the response status should be 201 Created
    And the Location header should contain the URI of the new visit

  Scenario: Update an existing visit
    Given a visit with ID 2 exists
    When the client sends PUT /api/visits/2 with valid updated visit data
    Then the response status should be 204 No Content

  Scenario: Delete an existing visit
    Given a visit with ID 2 exists
    When the client sends DELETE /api/visits/2
    Then the response status should be 204 No Content

  # Validation scenarios
  Scenario: Create visit with missing description
    When the client sends POST /api/visits with visit data missing description
    Then the response status should be 400 Bad Request
    And the response should contain validation error for description

  Scenario: Update visit with null description
    Given a visit with ID 2 exists
    When the client sends PUT /api/visits/2 with visit data with null description
    Then the response status should be 400 Bad Request
    And the response should contain validation error for description

  # Negative scenarios
  Scenario: Get visit by non-existent ID
    When the client requests GET /api/visits/999999
    Then the response status should be 404 Not Found

  Scenario: Update non-existent visit
    When the client sends PUT /api/visits/999999 with valid visit data
    Then the response status should be 404 Not Found

  Scenario: Delete non-existent visit
    When the client sends DELETE /api/visits/999999
    Then the response status should be 404 Not Found

  # REST API behavior
  Scenario: List visits returns 404 when no visits found
    When the client requests GET /api/visits
    And no visits exist
    Then the response status should be 404 Not Found


Feature: Vet Management REST API

  Background:
    Given the user has role "VET_ADMIN"

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
    When the client sends POST /api/vets with valid vet data including specialties
    Then the response status should be 201 Created
    And the Location header should contain the URI of the new vet

  Scenario: Update an existing vet
    Given a vet with ID 1 exists
    When the client sends PUT /api/vets/1 with valid updated vet data including specialties
    Then the response status should be 204 No Content

  Scenario: Delete an existing vet
    Given a vet with ID 1 exists
    When the client sends DELETE /api/vets/1
    Then the response status should be 204 No Content

  # Validation scenarios
  Scenario: Create vet with missing firstName
    When the client sends POST /api/vets with vet data missing firstName
    Then the response status should be 400 Bad Request
    And the response should contain validation error for firstName

  Scenario: Update vet with null lastName
    Given a vet with ID 1 exists
    When the client sends PUT /api/vets/1 with vet data with null lastName
    Then the response status should be 400 Bad Request
    And the response should contain validation error for lastName

  # Negative scenarios
  Scenario: Get vet by non-existent ID
    When the client requests GET /api/vets/999999
    Then the response status should be 404 Not Found

  Scenario: Update non-existent vet
    When the client sends PUT /api/vets/999999 with valid vet data
    Then the response status should be 404 Not Found

  Scenario: Delete non-existent vet
    When the client sends DELETE /api/vets/999999
    Then the response status should be 404 Not Found

  # REST API behavior
  Scenario: List vets returns 404 when no vets found
    When the client requests GET /api/vets
    And no vets exist
    Then the response status should be 404 Not Found


Feature: PetType Management REST API

  Background:
    Given the user has role "VET_ADMIN" or "OWNER_ADMIN"

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
    When the client sends POST /api/pettypes with valid pet type data
    Then the response status should be 201 Created
    And the Location header should contain the URI of the new pet type

  Scenario: Update an existing pet type
    Given a pet type with ID 1 exists
    When the client sends PUT /api/pettypes/1 with valid updated pet type data
    Then the response status should be 204 No Content

  Scenario: Delete an existing pet type
    Given a pet type with ID 1 exists
    When the client sends DELETE /api/pettypes/1
    Then the response status should be 204 No Content

  # Validation scenarios
  Scenario: Create pet type with missing name
    When the client sends POST /api/pettypes with pet type data missing name
    Then the response status should be 400 Bad Request
    And the response should contain validation error for name

  Scenario: Update pet type with empty name
    Given a pet type with ID 1 exists
    When the client sends PUT /api/pettypes/1 with pet type data with empty name
    Then the response status should be 400 Bad Request
    And the response should contain validation error for name

  # Negative scenarios
  Scenario: Get pet type by non-existent ID
    When the client requests GET /api/pettypes/999999
    Then the response status should be 404 Not Found

  Scenario: Update non-existent pet type
    When the client sends PUT /api/pettypes/999999 with valid pet type data
    Then the response status should be 404 Not Found

  Scenario: Delete non-existent pet type
    When the client sends DELETE /api/pettypes/999999
    Then the response status should be 404 Not Found

  # REST API behavior
  Scenario: List pet types returns 404 when no pet types found
    When the client requests GET /api/pettypes
    And no pet types exist
    Then the response status should be 404 Not Found


Feature: Specialty Management REST API

  Background:
    Given the user has role "VET_ADMIN"

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
    When the client sends POST /api/specialties with valid specialty data
    Then the response status should be 201 Created
    And the Location header should contain the URI of the new specialty

  Scenario: Update an existing specialty
    Given a specialty with ID 1 exists
    When the client sends PUT /api/specialties/1 with valid updated specialty data
    Then the response status should be 204 No Content

  Scenario: Delete an existing specialty
    Given a specialty with ID 1 exists
    When the client sends DELETE /api/specialties/1
    Then the response status should be 204 No Content

  # Validation scenarios
  Scenario: Create specialty with missing name
    When the client sends POST /api/specialties with specialty data missing name
    Then the response status should be 400 Bad Request
    And the response should contain validation error for name

  Scenario: Update specialty with empty name
    Given a specialty with ID 1 exists
    When the client sends PUT /api/specialties/1 with specialty data with empty name
    Then