=Feature: Petclinic REST API - Owners, Pets, and Visits Management

  Background:
    Given the API base URL is configured

  # Owner scenarios
  @owners
  Scenario Outline: Retrieve owner by ID
    When the client requests GET /owners/<ownerId>
    Then the response status code is <statusCode>
    And <responseCheck>

    Examples:
      | ownerId | statusCode | responseCheck                      |
      | 1       | 200        | the response contains owner with id 1 |
      | 9999    | 404        | the response contains error message "Owner not found" |

  @owners
  Scenario Outline: Create a new owner
    When the client creates an owner with:
      | firstName | lastName | address       | city      | telephone   |
      | <firstName> | <lastName> | <address> | <city>    | <telephone> |
    Then the response status code is <statusCode>
    And <responseCheck>

    Examples:
      # Positive case
      | firstName | lastName | address       | city      | telephone  | statusCode | responseCheck                              |
      | John      | Doe      | 123 Elm St    | Metropolis| 1234567890 | 201        | the response contains owner with firstName "John" and lastName "Doe" |
      # Missing mandatory field lastName
      | John      |          | 123 Elm St    | Metropolis| 1234567890 | 400        | the response contains validation error for "lastName" |
      # Invalid telephone (non-numeric)
      | John      | Doe      | 123 Elm St    | Metropolis| abcdef     | 400        | the response contains validation error for "telephone" |

  @owners
  Scenario Outline: Update an existing owner
    Given an owner exists with id <ownerId>
    When the client updates owner with id <ownerId> with:
      | firstName | lastName | address       | city      | telephone   |
      | <firstName> | <lastName> | <address> | <city>    | <telephone> |
    Then the response status code is <statusCode>
    And <responseCheck>

    Examples:
      # Positive update
      | ownerId | firstName | lastName | address       | city      | telephone  | statusCode | responseCheck                              |
      | 1       | Jane      | Smith    | 456 Oak Ave   | Gotham    | 9876543210 | 200        | the response contains owner with firstName "Jane" and lastName "Smith" |
      # Update non-existent owner
      | 9999    | Jane      | Smith    | 456 Oak Ave   | Gotham    | 9876543210 | 404        | the response contains error message "Owner not found" |
      # Invalid telephone
      | 1       | Jane      | Smith    | 456 Oak Ave   | Gotham    | invalid    | 400        | the response contains validation error for "telephone" |

  @owners
  Scenario Outline: Delete an owner
    Given an owner exists with id <ownerId>
    When the client deletes owner with id <ownerId>
    Then the response status code is <statusCode>

    Examples:
      | ownerId | statusCode |
      | 1       | 204        |
      | 9999    | 404        |

  # Pet scenarios
  @pets
  Scenario Outline: Retrieve pet by ID
    When the client requests GET /pets/<petId>
    Then the response status code is <statusCode>
    And <responseCheck>

    Examples:
      | petId | statusCode | responseCheck                  |
      | 1     | 200        | the response contains pet with id 1 |
      | 9999  | 404        | the response contains error message "Pet not found" |

  @pets
  Scenario Outline: Create a new pet
    When the client creates a pet with:
      | name   | birthDate  | typeId | ownerId |
      | <name> | <birthDate> | <typeId> | <ownerId> |
    Then the response status code is <statusCode>
    And <responseCheck>

    Examples:
      # Positive case
      | name    | birthDate  | typeId | ownerId | statusCode | responseCheck                  |
      | Buddy   | 2018-01-01 | 1      | 1       | 201        | the response contains pet with id  |
      # Missing name
      |         | 2018-01-01 | 1      | 1       | 400        | the response contains validation error for "name" |
      # Invalid birthDate format
      | Buddy   | 01-01-2018 | 1      | 1       | 400        | the response contains validation error for "birthDate" |
      # Nonexistent ownerId
      | Buddy   | 2018-01-01 | 1      | 9999    | 400        | the response contains error message "Owner not found" |

  @pets
  Scenario Outline: Update an existing pet
    Given a pet exists with id <petId>
    When the client updates pet with id <petId> with:
      | name   | birthDate  | typeId | ownerId |
      | <name> | <birthDate> | <typeId> | <ownerId> |
    Then the response status code is <statusCode>
    And <responseCheck>

    Examples:
      # Positive update
      | petId | name    | birthDate  | typeId | ownerId | statusCode | responseCheck                  |
      | 1     | Max     | 2019-05-05 | 2      | 1       | 200        | the response contains pet with id 1 |
      # Update non-existent pet
      | 9999  | Max     | 2019-05-05 | 2      | 1       | 404        | the response contains error message "Pet not found" |
      # Invalid birthDate
      | 1     | Max     | invalid    | 2      | 1       | 400        | the response contains validation error for "birthDate" |

  @pets
  Scenario Outline: Delete a pet
    Given a pet exists with id <petId>
    When the client deletes pet with id <petId>
    Then the response status code is <statusCode>

    Examples:
      | petId | statusCode |
      | 1     | 204        |
      | 9999  | 404        |

  # Visit scenarios
  @visits
  Scenario Outline: Retrieve visit by ID
    When the client requests GET /visits/<visitId>
    Then the response status code is <statusCode>
    And <responseCheck>

    Examples:
      | visitId | statusCode | responseCheck                    |
      | 1       | 200        | the response contains visit with id 1 |
      | 9999    | 404        | the response contains error message "Visit not found" |

  @visits
  Scenario Outline: Create a new visit
    When the client creates a visit with:
      | petId | visitDate  | description          |
      | <petId> | <visitDate> | <description>       |
    Then the response status code is <statusCode>
    And <responseCheck>

    Examples:
      # Positive case
      | petId | visitDate  | description       | statusCode | responseCheck                    |
      | 1     | 2023-01-01 | Annual checkup    | 201        | the response contains visit with id  |
      # Missing description
      | 1     | 2023-01-01 |                  | 400        | the response contains validation error for "description" |
      # Invalid visitDate format
      | 1     | 01-01-2023 | Annual checkup    | 400        | the response contains validation error for "visitDate" |
      # Nonexistent petId
      | 9999  | 2023-01-01 | Annual checkup    | 400        | the response contains error message "Pet not found" |

  @visits
  Scenario Outline: Update an existing visit
    Given a visit exists with id <visitId>
    When the client updates visit with id <visitId> with:
      | petId | visitDate  | description          |
      | <petId> | <visitDate> | <description>       |
    Then the response status code is <statusCode>
    And <responseCheck>

    Examples:
      # Positive update
      | visitId | petId | visitDate  | description      | statusCode | responseCheck                    |
      | 1       | 1     | 2023-06-01 | Follow-up visit  | 200        | the response contains visit with id 1 |
      # Update non-existent visit
      | 9999    | 1     | 2023-06-01 | Follow-up visit  | 404        | the response contains error message "Visit not found" |
      # Invalid visitDate
      | 1       | 1     | invalid    | Follow-up visit  | 400        | the response contains validation error for "visitDate" |

  @visits
  Scenario Outline: Delete a visit
    Given a visit exists with id <visitId>
    When the client deletes visit with id <visitId>
    Then the response status code is <statusCode>

    Examples:
      | visitId | statusCode |
      | 1       | 204        |
      | 9999    | 404        |