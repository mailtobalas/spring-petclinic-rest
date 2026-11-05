=Feature: Petclinic REST API - Owners, Pets, and Visits Management

  Background:
    Given the API base URL is configured

  # Owner endpoints: GET /owners/{ownerId}, POST /owners, PUT /owners/{ownerId}, DELETE /owners/{ownerId}
  # Pet endpoints: GET /pets/{petId}, POST /pets, PUT /pets/{petId}, DELETE /pets/{petId}
  # Visit endpoints: GET /visits/{visitId}, POST /visits, PUT /visits/{visitId}, DELETE /visits/{visitId}

  # OWNER SCENARIOS

  Scenario Outline: Retrieve an existing owner by ID
    When I send a GET request to "/owners/<ownerId>"
    Then the response status code should be 200
    And the response JSON should contain owner with id <ownerId> and lastName "<lastName>"

    Examples:
      | ownerId | lastName  |
      | 1       | Douglas   |
      | 2       | Smith     |

  Scenario Outline: Retrieve a non-existent owner by ID
    When I send a GET request to "/owners/<ownerId>"
    Then the response status code should be 404

    Examples:
      | ownerId |
      | 9999    |
      | 0       |

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
      | firstName | lastName | address         | city       | telephone  |
      | John      | Doe      | 123 Elm Street  | Metropolis | 1234567890 |
      | Jane      | Roe      | 456 Oak Avenue  | Gotham     | 0987654321 |

  Scenario Outline: Create a new owner with missing required fields
    Given the following owner data:
      | firstName | <firstName> |
      | lastName  | <lastName>  |
    When I send a POST request to "/owners" with the owner data
    Then the response status code should be 400

    Examples:
      | firstName | lastName |
      |           | Doe      |
      | John      |          |

  Scenario Outline: Update an existing owner with valid data
    Given the following owner data:
      | firstName | <firstName> |
      | lastName  | <lastName>  |
      | address   | <address>   |
      | city      | <city>      |
      | telephone | <telephone> |
    When I send a PUT request to "/owners/<ownerId>" with the owner data
    Then the response status code should be 204

    Examples:
      | ownerId | firstName | lastName | address        | city       | telephone  |
      | 1       | John      | Doe      | 789 Pine Road  | Star City  | 1112223333 |

  Scenario Outline: Update a non-existent owner
    Given the following owner data:
      | firstName | John |
      | lastName  | Doe  |
    When I send a PUT request to "/owners/<ownerId>" with the owner data
    Then the response status code should be 404

    Examples:
      | ownerId |
      | 9999    |

  Scenario Outline: Delete an existing owner
    When I send a DELETE request to "/owners/<ownerId>"
    Then the response status code should be 204

    Examples:
      | ownerId |
      | 1       |

  Scenario Outline: Delete a non-existent owner
    When I send a DELETE request to "/owners/<ownerId>"
    Then the response status code should be 404

    Examples:
      | ownerId |
      | 9999    |

  # PET SCENARIOS

  Scenario Outline: Retrieve an existing pet by ID
    When I send a GET request to "/pets/<petId>"
    Then the response status code should be 200
    And the response JSON should contain pet with id <petId> and name "<name>"

    Examples:
      | petId | name    |
      | 1     | Leo     |
      | 2     | Bubbles |

  Scenario Outline: Retrieve a non-existent pet by ID
    When I send a GET request to "/pets/<petId>"
    Then the response status code should be 404

    Examples:
      | petId |
      | 9999  |

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
      | name   | birthDate  | type   | ownerId |
      | Max    | 2019-01-01 | dog    | 1       |
      | Whiskers | 2020-06-15 | cat   | 2       |

  Scenario Outline: Create a new pet with missing required fields
    Given the following pet data:
      | name  | <name>  |
      | type  | <type>  |
    When I send a POST request to "/pets" with the pet data
    Then the response status code should be 400

    Examples:
      | name | type |
      |      | dog  |
      | Max  |      |

  Scenario Outline: Update an existing pet with valid data
    Given the following pet data:
      | name  | <name>  |
      | birthDate | <birthDate> |
      | type  | <type>  |
      | ownerId | <ownerId> |
    When I send a PUT request to "/pets/<petId>" with the pet data
    Then the response status code should be 204

    Examples:
      | petId | name   | birthDate  | type | ownerId |
      | 1     | Max    | 2018-12-12 | dog  | 1       |

  Scenario Outline: Update a non-existent pet
    Given the following pet data:
      | name | Max |
      | type | dog |
    When I send a PUT request to "/pets/<petId>" with the pet data
    Then the response status code should be 404

    Examples:
      | petId |
      | 9999  |

  Scenario Outline: Delete an existing pet
    When I send a DELETE request to "/pets/<petId>"
    Then the response status code should be 204

    Examples:
      | petId |
      | 1     |

  Scenario Outline: Delete a non-existent pet
    When I send a DELETE request to "/pets/<petId>"
    Then the response status code should be 404

    Examples:
      | petId |
      | 9999  |

  # VISIT SCENARIOS

  Scenario Outline: Retrieve an existing visit by ID
    When I send a GET request to "/visits/<visitId>"
    Then the response status code should be 200
    And the response JSON should contain visit with id <visitId> and description "<description>"

    Examples:
      | visitId | description         |
      | 1       | Annual checkup      |
      | 2       | Vaccination         |

  Scenario Outline: Retrieve a non-existent visit by ID
    When I send a GET request to "/visits/<visitId>"
    Then the response status code should be 404

    Examples:
      | visitId |
      | 9999    |

  Scenario Outline: Create a new visit with valid data
    Given the following visit data:
      | petId       | <petId>       |
      | visitDate   | <visitDate>   |
      | description | <description> |
    When I send a POST request to "/visits" with the visit data
    Then the response status code should be 201
    And the response JSON should contain visit with description "<description>"

    Examples:
      | petId | visitDate  | description       |
      | 1     | 2023-01-01 | Annual checkup    |
      | 2     | 2023-06-15 | Dental cleaning   |

  Scenario Outline: Create a new visit with missing required fields
    Given the following visit data:
      | petId       | <petId>       |
      | description | <description> |
    When I send a POST request to "/visits" with the visit data
    Then the response status code should be 400

    Examples:
      | petId | description |
      |       | Checkup     |
      | 1     |             |

  Scenario Outline: Update an existing visit with valid data
    Given the following visit data:
      | petId       | <petId>       |
      | visitDate   | <visitDate>   |
      | description | <description> |
    When I send a PUT request to "/visits/<visitId>" with the visit data
    Then the response status code should be 204

    Examples:
      | visitId | petId | visitDate  | description     |
      | 1       | 1     | 2023-02-01 | Follow-up check |

  Scenario Outline: Update a non-existent visit
    Given the following visit data:
      | petId       | 1             |
      | description | Follow-up     |
    When I send a PUT request to "/visits/<visitId>" with the visit data
    Then the response status code should be 404

    Examples:
      | visitId |
      | 9999    |

  Scenario Outline: Delete an existing visit
    When I send a DELETE request to "/visits/<visitId>"
    Then the response status code should be 204

    Examples:
      | visitId |
      | 1       |

  Scenario Outline: Delete a non-existent visit
    When I send a DELETE request to "/visits/<visitId>"
    Then the response status code should be 404

    Examples:
      | visitId |
      | 9999    |