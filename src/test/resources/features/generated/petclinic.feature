=Feature: Petclinic REST API - Owners, Pets, and Visits Management

  Background:
    Given the API base URL is configured

  # Owner scenarios
  Scenario Outline: Retrieve existing owner by ID
    When the client requests GET /owners/<ownerId>
    Then the response status code is 200
    And the response contains owner with id <ownerId>

    Examples:
      | ownerId |
      | 1       |
      | 2       |

  Scenario Outline: Retrieve non-existing owner by ID
    When the client requests GET /owners/<ownerId>
    Then the response status code is 404
    And the response contains error message "Owner not found"

    Examples:
      | ownerId |
      | 9999    |
      | 0       |

  Scenario Outline: Create owner with valid data
    When the client creates an owner with:
      | firstName | lastName | address      | city      | telephone  |
      | <firstName> | <lastName> | <address> | <city> | <telephone> |
    Then the response status code is 201
    And the response contains owner with firstName <firstName> and lastName <lastName>

    Examples:
      | firstName | lastName | address          | city       | telephone  |
      | John      | Doe      | 123 Elm Street   | Springfield| 1234567890 |
      | Jane      | Smith    | 456 Oak Avenue   | Shelbyville| 0987654321 |

  Scenario Outline: Create owner with missing mandatory fields
    When the client creates an owner with:
      | firstName | lastName | address | city | telephone |
      | <firstName> | <lastName> | <address> | <city> | <telephone> |
    Then the response status code is 400
    And the response contains validation error for <field>

    Examples:
      | firstName | lastName | address | city | telephone | field      |
      |           | Doe      | 123 Elm Street | Springfield | 1234567890 | firstName  |
      | John      |          | 123 Elm Street | Springfield | 1234567890 | lastName   |
      | John      | Doe      |              | Springfield | 1234567890 | address    |
      | John      | Doe      | 123 Elm Street |            | 1234567890 | city       |
      | John      | Doe      | 123 Elm Street | Springfield |            | telephone  |

  Scenario Outline: Update existing owner with valid data
    Given an owner exists with id <ownerId>
    When the client updates owner with id <ownerId> with:
      | firstName | lastName | address      | city      | telephone  |
      | <firstName> | <lastName> | <address> | <city> | <telephone> |
    Then the response status code is 200
    And the response contains owner with firstName <firstName> and lastName <lastName>

    Examples:
      | ownerId | firstName | lastName | address          | city       | telephone  |
      | 1       | Alice     | Johnson  | 789 Pine Road    | CapitalCity| 1112223333 |

  Scenario Outline: Update non-existing owner
    When the client updates owner with id <ownerId> with:
      | firstName | lastName | address | city | telephone |
      | John      | Doe      | 123 Elm Street | Springfield | 1234567890 |
    Then the response status code is 404
    And the response contains error message "Owner not found"

    Examples:
      | ownerId |
      | 9999    |

  Scenario Outline: Delete existing owner
    Given an owner exists with id <ownerId>
    When the client deletes owner with id <ownerId>
    Then the response status code is 204

    Examples:
      | ownerId |
      | 1       |

  Scenario Outline: Delete non-existing owner
    When the client deletes owner with id <ownerId>
    Then the response status code is 404
    And the response contains error message "Owner not found"

    Examples:
      | ownerId |
      | 9999    |

  # Pet scenarios
  Scenario Outline: Retrieve existing pet by ID
    When the client requests GET /pets/<petId>
    Then the response status code is 200
    And the response contains pet with id <petId>

    Examples:
      | petId |
      | 1     |
      | 2     |

  Scenario Outline: Retrieve non-existing pet by ID
    When the client requests GET /pets/<petId>
    Then the response status code is 404
    And the response contains error message "Pet not found"

    Examples:
      | petId |
      | 9999  |
      | 0     |

  Scenario Outline: Create pet with valid data
    When the client creates a pet with:
      | name   | birthDate  | typeId | ownerId |
      | <name> | <birthDate>| <typeId>| <ownerId> |
    Then the response status code is 201
    And the response contains pet with id >= 1

    Examples:
      | name    | birthDate  | typeId | ownerId |
      | Buddy   | 2018-05-01 | 1      | 1       |
      | Daisy   | 2020-10-12 | 2      | 2       |

  Scenario Outline: Create pet with missing mandatory fields
    When the client creates a pet with:
      | name   | birthDate  | typeId | ownerId |
      | <name> | <birthDate>| <typeId>| <ownerId> |
    Then the response status code is 400
    And the response contains validation error for <field>

    Examples:
      | name  | birthDate | typeId | ownerId | field     |
      |       | 2018-05-01| 1      | 1       | name      |
      | Buddy |           | 1      | 1       | birthDate |

  Scenario Outline: Update existing pet with valid data
    Given a pet exists with id <petId>
    When the client updates pet with id <petId> with:
      | name   | birthDate  | typeId | ownerId |
      | <name> | <birthDate>| <typeId>| <ownerId> |
    Then the response status code is 200
    And the response contains pet with id <petId>

    Examples:
      | petId | name    | birthDate  | typeId | ownerId |
      | 1     | Max     | 2017-03-15 | 1      | 1       |

  Scenario Outline: Update non-existing pet
    When the client updates pet with id <petId> with:
      | name   | birthDate  | typeId | ownerId |
      | Max    | 2017-03-15 | 1      | 1       |
    Then the response status code is 404
    And the response contains error message "Pet not found"

    Examples:
      | petId |
      | 9999  |

  Scenario Outline: Delete existing pet
    Given a pet exists with id <petId>
    When the client deletes pet with id <petId>
    Then the response status code is 204

    Examples:
      | petId |
      | 1     |

  Scenario Outline: Delete non-existing pet
    When the client deletes pet with id <petId>
    Then the response status code is 404
    And the response contains error message "Pet not found"

    Examples:
      | petId |
      | 9999  |

  # Visit scenarios
  Scenario Outline: Retrieve existing visit by ID
    When the client requests GET /visits/<visitId>
    Then the response status code is 200
    And the response contains visit with id <visitId>

    Examples:
      | visitId |
      | 1       |
      | 2       |

  Scenario Outline: Retrieve non-existing visit by ID
    When the client requests GET /visits/<visitId>
    Then the response status code is 404
    And the response contains error message "Visit not found"

    Examples:
      | visitId |
      | 9999    |
      | 0       |

  Scenario Outline: Create visit with valid data
    When the client creates a visit with:
      | petId | visitDate  | description          |
      | <petId> | <visitDate> | <description>      |
    Then the response status code is 201
    And the response contains visit with id >= 1

    Examples:
      | petId | visitDate  | description          |
      | 1     | 2023-01-01 | Annual checkup       |
      | 2     | 2023-06-15 | Vaccination          |

  Scenario Outline: Create visit with missing mandatory fields
    When the client creates a visit with:
      | petId | visitDate  | description          |
      | <petId> | <visitDate> | <description>      |
    Then the response status code is 400
    And the response contains validation error for <field>

    Examples:
      | petId | visitDate | description | field      |
      |       | 2023-01-01| Annual checkup | petId    |
      | 1     |           | Annual checkup | visitDate|
      | 1     | 2023-01-01|               | description|

  Scenario Outline: Update existing visit with valid data
    Given a visit exists with id <visitId>
    When the client updates visit with id <visitId> with:
      | petId | visitDate  | description          |
      | <petId> | <visitDate> | <description>      |
    Then the response status code is 200
    And the response contains visit with id <visitId>

    Examples:
      | visitId | petId | visitDate  | description    |
      | 1       | 1     | 2023-02-01 | Follow-up visit|

  Scenario Outline: Update non-existing visit
    When the client updates visit with id <visitId> with:
      | petId | visitDate  | description          |
      | 1     | 2023-02-01 | Follow-up visit      |
    Then the response status code is 404
    And the response contains error message "Visit not found"

    Examples:
      | visitId |
      | 9999    |

  Scenario Outline: Delete existing visit
    Given a visit exists with id <visitId>
    When the client deletes visit with id <visitId>
    Then the response status code is 204

    Examples:
      | visitId |
      | 1       |

  Scenario Outline: Delete non-existing visit
    When the client deletes visit with id <visitId>
    Then the response status code is 404
    And the response contains error message "Visit not found"

    Examples:
      | visitId |
      | 9999    |