=Feature: Spring Petclinic REST API

  Background:
    Given the API base URL is configured

  # Owners API
  Scenario Outline: Retrieve owner by ID successfully
    When the client requests GET /owners/<ownerId>
    Then the response status code is 200
    And the response contains owner with id <ownerId>
    Examples:
      | ownerId |
      | 1       |
      | 2       |

  Scenario Outline: Retrieve owner by ID - owner not found
    When the client requests GET /owners/<ownerId>
    Then the response status code is 404
    And the response contains error message "Owner not found"
    Examples:
      | ownerId |
      | 9999    |
      | 0       |

  Scenario Outline: Create a new owner successfully
    When the client creates an owner with:
      | firstName | lastName | address       | city       | telephone   |
      | <firstName> | <lastName> | <address> | <city> | <telephone> |
    Then the response status code is 201
    And the response contains owner with firstName <firstName> and lastName <lastName>
    Examples:
      | firstName | lastName | address         | city       | telephone   |
      | John      | Doe      | 123 Elm Street  | Metropolis | 1234567890  |
      | Jane      | Smith    | 456 Oak Avenue  | Gotham     | 0987654321  |

  Scenario Outline: Create a new owner with missing required fields
    When the client creates an owner with:
      | firstName | lastName | address | city | telephone |
      | <firstName> | <lastName> | <address> | <city> | <telephone> |
    Then the response status code is 400
    And the response contains validation error for <field>
    Examples:
      | firstName | lastName | address | city | telephone | field     |
      |           | Doe      | 123 Elm Street | Metropolis | 1234567890 | firstName |
      | John      |          | 123 Elm Street | Metropolis | 1234567890 | lastName  |
      | John      | Doe      |               | Metropolis | 1234567890 | address   |
      | John      | Doe      | 123 Elm Street |           | 1234567890 | city      |
      | John      | Doe      | 123 Elm Street | Metropolis |           | telephone |

  Scenario Outline: Update an existing owner successfully
    Given an owner exists with id <ownerId>
    When the client updates owner with id <ownerId> with:
      | firstName | lastName | address       | city       | telephone   |
      | <firstName> | <lastName> | <address> | <city> | <telephone> |
    Then the response status code is 204
    When the client requests GET /owners/<ownerId>
    Then the response status code is 200
    And the response contains owner with firstName <firstName> and lastName <lastName>
    Examples:
      | ownerId | firstName | lastName | address         | city       | telephone   |
      | 1       | Alice     | Wonderland | 789 Pine Road  | Wonderland | 1112223333  |

  Scenario Outline: Update an owner that does not exist
    When the client updates owner with id <ownerId> with:
      | firstName | lastName | address       | city       | telephone   |
      | Bob       | Builder  | 321 Brick Lane | Buildtown  | 4445556666  |
    Then the response status code is 404
    And the response contains error message "Owner not found"
    Examples:
      | ownerId |
      | 9999    |

  Scenario Outline: Delete an existing owner successfully
    Given an owner exists with id <ownerId>
    When the client deletes owner with id <ownerId>
    Then the response status code is 204
    When the client requests GET /owners/<ownerId>
    Then the response status code is 404
    Examples:
      | ownerId |
      | 2       |

  Scenario Outline: Delete an owner that does not exist
    When the client deletes owner with id <ownerId>
    Then the response status code is 404
    And the response contains error message "Owner not found"
    Examples:
      | ownerId |
      | 9999    |

  # Pets API
  Scenario Outline: Retrieve pet by ID successfully
    When the client requests GET /pets/<petId>
    Then the response status code is 200
    And the response contains pet with id <petId>
    Examples:
      | petId |
      | 1     |
      | 2     |

  Scenario Outline: Retrieve pet by ID - pet not found
    When the client requests GET /pets/<petId>
    Then the response status code is 404
    And the response contains error message "Pet not found"
    Examples:
      | petId |
      | 9999  |
      | 0     |

  Scenario Outline: Create a new pet successfully
    When the client creates a pet with:
      | name    | birthDate  | typeId | ownerId |
      | <name>  | <birthDate> | <typeId> | <ownerId> |
    Then the response status code is 201
    And the response contains pet with name <name>
    Examples:
      | name    | birthDate  | typeId | ownerId |
      | Buddy   | 2020-01-01 | 1      | 1       |
      | Daisy   | 2019-05-15 | 2      | 2       |

  Scenario Outline: Create a new pet with missing or invalid fields
    When the client creates a pet with:
      | name    | birthDate  | typeId | ownerId |
      | <name>  | <birthDate> | <typeId> | <ownerId> |
    Then the response status code is 400
    And the response contains validation error for <field>
    Examples:
      | name  | birthDate | typeId | ownerId | field     |
      |       | 2020-01-01 | 1      | 1       | name      |
      | Max   |            | 1      | 1       | birthDate |
      | Max   | 2020-01-01 |        | 1       | typeId    |
      | Max   | 2020-01-01 | 1      |         | ownerId   |

  Scenario Outline: Update an existing pet successfully
    Given a pet exists with id <petId>
    When the client updates pet with id <petId> with:
      | name    | birthDate  | typeId | ownerId |
      | <name>  | <birthDate> | <typeId> | <ownerId> |
    Then the response status code is 204
    When the client requests GET /pets/<petId>
    Then the response status code is 200
    And the response contains pet with name <name>
    Examples:
      | petId | name    | birthDate  | typeId | ownerId |
      | 1     | Rocky   | 2018-07-07 | 1      | 1       |

  Scenario Outline: Update a pet that does not exist
    When the client updates pet with id <petId> with:
      | name  | birthDate  | typeId | ownerId |
      | Max   | 2020-01-01 | 1      | 1       |
    Then the response status code is 404
    And the response contains error message "Pet not found"
    Examples:
      | petId |
      | 9999  |

  Scenario Outline: Delete an existing pet successfully
    Given a pet exists with id <petId>
    When the client deletes pet with id <petId>
    Then the response status code is 204
    When the client requests GET /pets/<petId>
    Then the response status code is 404
    Examples:
      | petId |
      | 2     |

  Scenario Outline: Delete a pet that does not exist
    When the client deletes pet with id <petId>
    Then the response status code is 404
    And the response contains error message "Pet not found"
    Examples:
      | petId |
      | 9999  |

  # Visits API
  Scenario Outline: Retrieve visit by ID successfully
    When the client requests GET /visits/<visitId>
    Then the response status code is 200
    And the response contains visit with id <visitId>
    Examples:
      | visitId |
      | 1       |
      | 2       |

  Scenario Outline: Retrieve visit by ID - visit not found
    When the client requests GET /visits/<visitId>
    Then the response status code is 404
    And the response contains error message "Visit not found"
    Examples:
      | visitId |
      | 9999    |
      | 0       |

  Scenario Outline: Create a new visit successfully
    When the client creates a visit with:
      | petId | visitDate  | description          |
      | <petId> | <visitDate> | <description>      |
    Then the response status code is 201
    And the response contains visit with description <description>
    Examples:
      | petId | visitDate  | description          |
      | 1     | 2023-01-01 | Annual checkup       |
      | 2     | 2023-06-15 | Vaccination          |

  Scenario Outline: Create a new visit with missing or invalid fields
    When the client creates a visit with:
      | petId | visitDate  | description          |
      | <petId> | <visitDate> | <description>      |
    Then the response status code is 400
    And the response contains validation error for <field>
    Examples:
      | petId | visitDate | description | field       |
      |       | 2023-01-01 | Checkup    | petId       |
      | 1     |            | Checkup    | visitDate   |
      | 1     | 2023-01-01 |            | description |

  Scenario Outline: Update an existing visit successfully
    Given a visit exists with id <visitId>
    When the client updates visit with id <visitId> with:
      | petId | visitDate  | description          |
      | <petId> | <visitDate> | <description>      |
    Then the response status code is 204
    When the client requests GET /visits/<visitId>
    Then the response status code is 200
    And the response contains visit with description <description>
    Examples:
      | visitId | petId | visitDate  | description          |
      | 1       | 1     | 2023-02-02 | Dental cleaning      |

  Scenario Outline: Update a visit that does not exist
    When the client updates visit with id <visitId> with:
      | petId | visitDate  | description          |
      | 1     | 2023-01-01 | Checkup              |
    Then the response status code is 404
    And the response contains error message "Visit not found"
    Examples:
      | visitId |
      | 9999    |

  Scenario Outline: Delete an existing visit successfully
    Given a visit exists with id <visitId>
    When the client deletes visit with id <visitId>
    Then the response status code is 204
    When the client requests GET /visits/<visitId>
    Then the response status code is 404
    Examples:
      | visitId |
      | 2       |

  Scenario Outline: Delete a visit that does not exist
    When the client deletes visit with id <visitId>
    Then the response status code is 404
    And the response contains error message "Visit not found"
    Examples:
      | visitId |
      | 9999    |