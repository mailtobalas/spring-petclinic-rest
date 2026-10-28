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
    And the response body should contain the created owner data

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
    And the response should contain validation error for "firstName"

  Scenario: Update owner with empty firstName
    Given an owner with ID 1 exists
    When the client sends PUT /api/owners/1 with empty firstName
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "firstName"

  Scenario: Create owner with invalid telephone number
    When the client sends POST /api/owners with telephone "123"
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "telephone"

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

  Scenario: Create owner with unexpected server error
    When the client sends POST /api/owners with valid owner data but server fails
    Then the response status should be 500 Internal Server Error
    And the response detail should indicate unexpected error

  # REST API behavior

  Scenario: List owners returns 404 when no owners found
    Given no owners exist with last name "NoSuchName"
    When the client requests GET /api/owners?lastName=NoSuchName
    Then the response status should be 404 Not Found

  Scenario: List owners returns 404 when no owners exist
    Given no owners exist
    When the client requests GET /api/owners
    Then the response status should be 404 Not Found

  Scenario: Update owner returns 204 No Content on success
    Given an owner with ID 1 exists
    When the client sends PUT /api/owners/1 with valid owner data
    Then the response status should be 204 No Content

  Scenario: Delete owner returns 204 No Content on success
    Given an owner with ID 1 exists
    When the client sends DELETE /api/owners/1
    Then the response status should be 204 No Content

  # Edge cases

  Scenario: Update owner with no ID in body but valid path ID
    Given an owner with ID 1 exists
    When the client sends PUT /api/owners/1 with owner data missing ID field
    Then the response status should be 204 No Content

  Scenario: Update owner with mismatched body ID and path ID
    Given an owner with ID 1 exists
    When the client sends PUT /api/owners/1 with owner data ID 2
    Then the response status should be 400 Bad Request
    And the response should contain validation error about ID mismatch

---

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
    And the response body should contain the created pet data

  Scenario: Update an existing pet
    Given an owner with ID 1 exists
    And a pet with ID 3 exists
    When the client sends PUT /api/owners/1/pets/3 with valid updated pet data
    Then the response status should be 204 No Content

  Scenario: Delete an existing pet
    Given a pet with ID 3 exists
    When the client sends DELETE /api/pets/3
    Then the response status should be 204 No Content

  # Validation scenarios

  Scenario: Create pet with missing required fields
    Given an owner with ID 1 exists
    When the client sends POST /api/owners/1/pets with missing name
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "name"

  Scenario: Create pet with invalid birthDate in the future
    Given an owner with ID 1 exists
    When the client sends POST /api/owners/1/pets with birthDate in the future
    Then the response status should be 400 Bad Request
    And the response should contain validation error about birthDate

  Scenario: Create pet with birthDate older than 50 years
    Given an owner with ID 1 exists
    When the client sends POST /api/owners/1/pets with birthDate older than 50 years
    Then the response status should be 400 Bad Request
    And the response should contain validation error about birthDate

  Scenario: Create pet with null or empty pet type
    Given an owner with ID 1 exists
    When the client sends POST /api/owners/1/pets with null pet type
    Then the response status should be 400 Bad Request
    And the response should contain validation error for pet type

  # Negative scenarios

  Scenario: Create pet for non-existent owner
    When the client sends POST /api/owners/999999/pets with valid pet data
    Then the response status should be 404 Not Found

  Scenario: Get pet by non-existent ID
    When the client requests GET /api/pets/999999
    Then the response status should be 404 Not Found

  Scenario: Update pet for non-existent owner
    When the client sends PUT /api/owners/999999/pets/3 with valid pet data
    Then the response status should be 404 Not Found

  Scenario: Update pet with non-existent pet ID
    Given an owner with ID 1 exists
    When the client sends PUT /api/owners/1/pets/999999 with valid pet data
    Then the response status should be 404 Not Found

  Scenario: Delete pet with non-existent ID
    When the client sends DELETE /api/pets/999999
    Then the response status should be 404 Not Found

  Scenario: Create pet with unexpected server error
    Given an owner with ID 1 exists
    When the client sends POST /api/owners/1/pets with valid pet data but server fails
    Then the response status should be 500 Internal Server Error
    And the response detail should indicate unexpected error

  # REST API behavior

  Scenario: List pets returns 404 when no pets exist
    Given no pets exist
    When the client requests GET /api/pets
    Then the response status should be 404 Not Found

  Scenario: Update pet returns 204 No Content on success
    Given a pet with ID 3 exists
    When the client sends PUT /api/pets/3 with valid pet data
    Then the response status should be 204 No Content

  Scenario: Delete pet returns 204 No Content on success
    Given a pet with ID 3 exists
    When the client sends DELETE /api/pets/3
    Then the response status should be 204 No Content

  # Edge cases

  Scenario: Create pet with pet type name set to empty string
    Given an owner with ID 1 exists
    When the client sends POST /api/owners/1/pets with pet type name as empty string
    Then the response status should be 400 Bad Request
    And the response should contain validation error for pet type name

  Scenario: Create pet with pet type ID null
    Given an owner with ID 1 exists
    When the client sends POST /api/owners/1/pets with pet type ID null
    Then the response status should be 400 Bad Request
    And the response should contain validation error for pet type ID

---

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
    And the response body should contain the created visit data

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
    When the client sends POST /api/visits with missing description
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "description"

  Scenario: Update visit with null description
    Given a visit with ID 2 exists
    When the client sends PUT /api/visits/2 with null description
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "description"

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

  Scenario: Create visit with unexpected server error
    When the client sends POST /api/visits with valid visit data but server fails
    Then the response status should be 500 Internal Server Error
    And the response detail should indicate unexpected error

  # REST API behavior

  Scenario: List visits returns 404 when no visits exist
    Given no visits exist
    When the client requests GET /api/visits
    Then the response status should be 404 Not Found

  Scenario: Update visit returns 204 No Content on success
    Given a visit with ID 2 exists
    When the client sends PUT /api/visits/2 with valid visit data
    Then the response status should be 204 No Content

  Scenario: Delete visit returns 204 No Content on success
    Given a visit with ID 2 exists
    When the client sends DELETE /api/visits/2
    Then the response status should be 204 No Content

---

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
    And the response body should contain the created vet data

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
    When the client sends POST /api/vets with missing firstName
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "firstName"

  Scenario: Update vet with null lastName
    Given a vet with ID 1 exists
    When the client sends PUT /api/vets/1 with null lastName
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "lastName"

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

  Scenario: Create vet with unexpected server error
    When the client sends POST /api/vets with valid vet data but server fails
    Then the response status should be 500 Internal Server Error
    And the response detail should indicate unexpected error

  # REST API behavior

  Scenario: List vets returns 404 when no vets exist
    Given no vets exist
    When the client requests GET /api/vets
    Then the response status should be 404 Not Found

  Scenario: Update vet returns 204 No Content on success
    Given a vet with ID 1 exists
    When the client sends PUT /api/vets/1 with valid vet data
    Then the response status should be 204 No Content

  Scenario: Delete vet returns 204 No Content on success
    Given a vet with ID 1 exists
    When the client sends DELETE /api/vets/1
    Then the response status should be 204 No Content

---

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
    And the response body should contain the created specialty data

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
    When the client sends POST /api/specialties with missing name
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "name"

  Scenario: Update specialty with empty name
    Given a specialty with ID 1 exists
    When the client sends PUT /api/specialties/1 with empty name
    Then the response status should be 400 Bad Request
    And the response should contain validation error for "name"

  # Negative scenarios

  Scenario: Get specialty by non-existent ID
    When the client requests GET /api/specialties/999999
    Then the response status should be 404 Not Found

  Scenario: Update non-existent specialty
    When the