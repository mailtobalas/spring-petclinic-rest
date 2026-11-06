=Feature: Petclinic REST API - Owners, Pets, and Visits Management

  Background:
    Given the API base URL is configured

  # Owner scenarios

  Scenario Outline: Retrieve an existing owner by ID
    When the client requests GET /owners/<ownerId>
    Then the response status code is 200
    And the response contains owner with id <ownerId>

    Examples:
      | ownerId |
      | 1       |
      | 2       |

  Scenario Outline: Retrieve a non-existent owner by ID
    When the client requests GET /owners/<ownerId>
    Then the response status code is 404
    And the response contains error message "Owner not found"

    Examples:
      | ownerId |
      | 9999    |
      | 0       |

  Scenario Outline: Create a new owner with valid data
    When the client creates an owner with:
      | firstName | lastName | address       | city      | telephone  |
      | <firstName> | <lastName> | <address> | <city> | <telephone> |
    Then the response status code is 201
    And the response contains owner with firstName <firstName> and lastName <lastName>

    Examples:
      | firstName | lastName | address          | city       | telephone  |
      | John      | Doe      | 123 Elm Street   | Springfield| 1234567890 |
      | Jane      | Smith    | 456 Oak Avenue   | Shelbyville| 0987654321 |

  Scenario Outline: Create a new owner with missing mandatory fields
    When the client creates an owner with:
      | firstName | lastName | address | city | telephone |
      | <firstName> | <lastName> | <address> | <city> | <telephone> |
    Then the response status code is 400
    And the response contains validation error for <field>

    Examples:
      | firstName | lastName | address | city | telephone | field     |
      |           | Doe      | 123 Elm Street | Springfield | 1234567890 | firstName |
      | John      |          | 123 Elm Street | Springfield | 1234567890 | lastName  |
      | John      | Doe      |              | Springfield | 1234567890 | address   |
      | John      | Doe      | 123 Elm Street |            | 1234567890 | city      |
      | John      | Doe      | 123 Elm Street | Springfield |           | telephone |

  Scenario Outline: Update an existing owner with valid data
    Given an owner exists with id <ownerId>
    When the client updates owner with id <ownerId> with:
      | firstName | lastName | address       | city      | telephone  |
      | <firstName> | <lastName> | <address> | <city> | <telephone> |
    Then the response status code is 200
    And the response contains owner with firstName <firstName> and lastName <lastName>

    Examples:
      | ownerId | firstName | lastName | address          | city       | telephone  |
      | 1       | Alice     | Johnson  | 789 Pine Road    | CapitalCity| 5551234567 |

  Scenario Outline: Update a non-existent owner
    When the client updates owner with id <ownerId> with:
      | firstName | lastName | address | city | telephone |
      | John      | Doe      | 123 Elm Street | Springfield | 1234567890 |
    Then the response status code is 404
    And the response contains error message "Owner not found"

    Examples:
      | ownerId |
      | 9999    |

  Scenario Outline: Delete an existing owner
    Given an owner exists with id <ownerId>
    When the client deletes owner with id <ownerId>
    Then the response status code is 204

    Examples:
      | ownerId |
      | 1       |

  Scenario Outline: Delete a non-existent owner
    When the client deletes owner with id <ownerId>
    Then the response status code is 404
    And the response contains error message "Owner not found"

    Examples:
      | ownerId |
      | 9999    |

  # Pet scenarios

  Scenario Outline: Retrieve an existing pet by ID
    When the client requests GET /pets/<petId>
    Then the response status code is 200
    And the response contains pet with id <petId>

    Examples:
      | petId |
      | 1     |
      | 2     |

  Scenario Outline: Retrieve a non-existent pet by ID
    When the client requests GET /pets/<petId>
    Then the response status code is 404
    And the response contains error message "Pet not found"

    Examples:
      | petId |
      | 9999  |
      | 0     |

  Scenario Outline: Create a new pet with valid data
    When the client creates a pet with:
      | name    | birthDate  | typeId | ownerId |
      | <name>  | <birthDate>| <typeId>| <ownerId> |
    Then the response status code is 201
    And the response contains pet with id >= 1

    Examples:
      | name    | birthDate  | typeId | ownerId |
      | Buddy   | 2018-06-01 | 1      | 1       |
      | Daisy   | 2020-01-15 | 2      | 2       |

  Scenario Outline: Create a new pet with missing or invalid fields
    When the client creates a pet with:
      | name    | birthDate  | typeId | ownerId |
      | <name>  | <birthDate>| <typeId>| <ownerId> |
    Then the response status code is 400
    And the response contains validation error for <field>

    Examples:
      | name  | birthDate | typeId | ownerId | field     |
      |       | 2018-06-01| 1      | 1       | name      |
      | Buddy |           | 1      | 1       | birthDate |
      | Buddy | 2018-06-01| abc    | 1       | typeId    |
      | Buddy | 2018-06-01| 1      | xyz     | ownerId   |

  Scenario Outline: Update an existing pet with valid data
    Given a pet exists with id <petId>
    When the client updates pet with id <petId> with:
      | name    | birthDate  | typeId | ownerId |
      | <name>  | <birthDate>| <typeId>| <ownerId> |
    Then the response status code is 200
    And the response contains pet with id <petId>

    Examples:
      | petId | name    | birthDate  | typeId | ownerId |
      | 1     | Max     | 2017-05-20 | 1      | 1       |

  Scenario Outline: Update a non-existent pet
    When the client updates pet with id <petId> with:
      | name    | birthDate  | typeId | ownerId |
      | Max     | 2017-05-20 | 1      | 1       |
    Then the response status code is 404
    And the response contains error message "Pet not found"

    Examples:
      | petId |
      | 9999  |

  Scenario Outline: Delete an existing pet
    Given a pet exists with id <petId>
    When the client deletes pet with id <petId>
    Then the response status code is 204

    Examples:
      | petId |
      | 1     |

  Scenario Outline: Delete a non-existent pet
    When the client deletes pet with id <petId>
    Then the response status code is 404
    And the response contains error message "Pet not found"

    Examples:
      | petId |
      | 9999  |

  # Visit scenarios

  Scenario Outline: Retrieve an existing visit by ID
    When the client requests GET /visits/<visitId>
    Then the response status code is 200
    And the response contains visit with id <visitId>

    Examples:
      | visitId |
      | 1       |
      | 2       |

  Scenario Outline: Retrieve a non-existent visit by ID
    When the client requests GET /visits/<visitId>
    Then the response status code is 404
    And the response contains error message "Visit not found"

    Examples:
      | visitId |
      | 9999    |
      | 0       |

  Scenario Outline: Create a new visit with valid data
    When the client creates a visit with:
      | petId | visitDate  | description        |
      | <petId> | <visitDate> | <description>    |
    Then the response status code is 201
    And the response contains visit with id >= 1

    Examples:
      | petId | visitDate  | description           |
      | 1     | 2023-03-15 | Annual checkup        |
      | 2     | 2023-04-20 | Vaccination           |

  Scenario Outline: Create a new visit with missing or invalid fields
    When the client creates a visit with:
      | petId | visitDate  | description        |
      | <petId> | <visitDate> | <description>    |
    Then the response status code is 400
    And the response contains validation error for <field>

    Examples:
      | petId | visitDate | description | field       |
      |       | 2023-03-15| Checkup     | petId       |
      | 1     |           | Checkup     | visitDate   |
      | 1     | 2023-03-15|             | description |

  Scenario Outline: Update an existing visit with valid data
    Given a visit exists with id <visitId>
    When the client updates visit with id <visitId> with:
      | petId | visitDate  | description        |
      | <petId> | <visitDate> | <description>    |
    Then the response status code is 200
    And the response contains visit with id <visitId>

    Examples:
      | visitId | petId | visitDate  | description     |
      | 1       | 1     | 2023-05-10 | Follow-up check |

  Scenario Outline: Update a non-existent visit
    When the client updates visit with id <visitId> with:
      | petId | visitDate  | description        |
      | 1     | 2023-05-10 | Follow-up check    |
    Then the response status code is 404
    And the response contains error message "Visit not found"

    Examples:
      | visitId |
      | 9999    |

  Scenario Outline: Delete an existing visit
    Given a visit exists with id <visitId>
    When the client deletes visit with id <visitId>
    Then the response status code is 204

    Examples:
      | visitId |
      | 1       |

  Scenario Outline: Delete a non-existent visit
    When the client deletes visit with id <visitId>
    Then the response status code is 404
    And the response contains error message "Visit not found"

    Examples:
      | visitId |
      | 9999    |