=Feature: Petclinic REST API - Owners, Pets, and Visits Management

  Background:
    Given the API base URL is configured

  # Owner endpoints
  # GET /owners/{ownerId}
  Scenario Outline: Retrieve an existing owner by ID
    When I send a GET request to "/owners/<ownerId>"
    Then the response status code should be 200
    And the response JSON should contain owner with id <ownerId> and lastName "<lastName>"

    Examples:
      | ownerId | lastName  |
      | 1       | Douglas   |
      | 2       | McGregor  |

  Scenario Outline: Retrieve a non-existent owner by ID
    When I send a GET request to "/owners/<ownerId>"
    Then the response status code should be 404

    Examples:
      | ownerId |
      | 9999    |
      | 0       |

  # POST /owners
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
      | firstName | lastName | address        | city      | telephone  |
      | John      | Smith    | 123 Elm St     | Springfield | 1234567890 |
      | Jane      | Doe      | 456 Oak Ave    | Shelbyville | 0987654321 |

  Scenario: Create a new owner with missing mandatory fields
    Given the following owner data:
      | firstName | John |
      | city      | Springfield |
    When I send a POST request to "/owners" with the owner data
    Then the response status code should be 400

  Scenario: Create a new owner with invalid telephone number
    Given the following owner data:
      | firstName | John |
      | lastName  | Smith |
      | address   | 123 Elm St |
      | city      | Springfield |
      | telephone | abcdefg |
    When I send a POST request to "/owners" with the owner data
    Then the response status code should be 400

  # PUT /owners/{ownerId}
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
      | ownerId | firstName | lastName | address      | city       | telephone  |
      | 1       | John      | Smith    | 789 Pine Rd  | Springfield| 1234567890 |

  Scenario Outline: Update a non-existent owner
    Given the following owner data:
      | firstName | John |
      | lastName  | Smith |
      | address   | 789 Pine Rd |
      | city      | Springfield |
      | telephone | 1234567890 |
    When I send a PUT request to "/owners/<ownerId>" with the owner data
    Then the response status code should be 404

    Examples:
      | ownerId |
      | 9999    |

  Scenario: Update an owner with invalid data
    Given the following owner data:
      | firstName | John |
      | lastName  | Smith |
      | address   | 789 Pine Rd |
      | city      | Springfield |
      | telephone | invalidphone |
    When I send a PUT request to "/owners/1" with the owner data
    Then the response status code should be 400

  # DELETE /owners/{ownerId}
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

  # Pet endpoints
  # GET /pets/{petId}
  Scenario Outline: Retrieve an existing pet by ID
    When I send a GET request to "/pets/<petId>"
    Then the response status code should be 200
    And the response JSON should contain pet with id <petId> and name "<name>"

    Examples:
      | petId | name     |
      | 1     | Rosy     |
      | 2     | Jolly    |

  Scenario Outline: Retrieve a non-existent pet by ID
    When I send a GET request to "/pets/<petId>"
    Then the response status code should be 404

    Examples:
      | petId |
      | 9999  |

  # POST /owners/{ownerId}/pets
  Scenario Outline: Create a new pet for an existing owner with valid data
    Given the following pet data:
      | name  | <name>  |
      | birthDate | <birthDate> |
      | type  | <type>  |
    When I send a POST request to "/owners/<ownerId>/pets" with the pet data
    Then the response status code should be 201
    And the response JSON should contain pet with name "<name>"

    Examples:
      | ownerId | name  | birthDate  | type    |
      | 1       | Buddy | 2018-01-01 | dog     |
      | 2       | Kitty | 2019-05-20 | cat     |

  Scenario Outline: Create a new pet for a non-existent owner
    Given the following pet data:
      | name  | Buddy  |
      | birthDate | 2018-01-01 |
      | type  | dog    |
    When I send a POST request to "/owners/<ownerId>/pets" with the pet data
    Then the response status code should be 404

    Examples:
      | ownerId |
      | 9999    |

  Scenario: Create a new pet with missing mandatory fields
    Given the following pet data:
      | name  | Buddy |
    When I send a POST request to "/owners/1/pets" with the pet data
    Then the response status code should be 400

  # PUT /pets/{petId}
  Scenario Outline: Update an existing pet with valid data
    Given the following pet data:
      | name  | <name>  |
      | birthDate | <birthDate> |
      | type  | <type>  |
    When I send a PUT request to "/pets/<petId>" with the pet data
    Then the response status code should be 204

    Examples:
      | petId | name  | birthDate  | type    |
      | 1     | Max   | 2017-12-12 | dog     |

  Scenario Outline: Update a non-existent pet
    Given the following pet data:
      | name  | Max   |
      | birthDate | 2017-12-12 |
      | type  | dog   |
    When I send a PUT request to "/pets/<petId>" with the pet data
    Then the response status code should be 404

    Examples:
      | petId |
      | 9999  |

  Scenario: Update a pet with invalid data
    Given the following pet data:
      | name  | Max   |
      | birthDate | invalid-date |
      | type  | dog   |
    When I send a PUT request to "/pets/1" with the pet data
    Then the response status code should be 400

  # DELETE /pets/{petId}
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

  # Visit endpoints
  # GET /visits/{visitId}
  Scenario Outline: Retrieve an existing visit by ID
    When I send a GET request to "/visits/<visitId>"
    Then the response status code should be 200
    And the response JSON should contain visit with id <visitId> and description "<description>"

    Examples:
      | visitId | description          |
      | 1       | Annual checkup       |
      | 2       | Vaccination          |

  Scenario Outline: Retrieve a non-existent visit by ID
    When I send a GET request to "/visits/<visitId>"
    Then the response status code should be 404

    Examples:
      | visitId |
      | 9999    |

  # POST /pets/{petId}/visits
  Scenario Outline: Create a new visit for an existing pet with valid data
    Given the following visit data:
      | date        | <date>        |
      | description | <description> |
    When I send a POST request to "/pets/<petId>/visits" with the visit data
    Then the response status code should be 201
    And the response JSON should contain visit with description "<description>"

    Examples:
      | petId | date       | description       |
      | 1     | 2023-01-01 | Annual checkup    |
      | 2     | 2023-06-15 | Vaccination       |

  Scenario Outline: Create a new visit for a non-existent pet
    Given the following visit data:
      | date        | 2023-01-01 |
      | description | Annual checkup |
    When I send a POST request to "/pets/<petId>/visits" with the visit data
    Then the response status code should be 404

    Examples:
      | petId |
      | 9999  |

  Scenario: Create a new visit with missing mandatory fields
    Given the following visit data:
      | description | Annual checkup |
    When I send a POST request to "/pets/1/visits" with the visit data
    Then the response status code should be 400

  # PUT /visits/{visitId}
  Scenario Outline: Update an existing visit with valid data
    Given the following visit data:
      | date        | <date>        |
      | description | <description> |
    When I send a PUT request to "/visits/<visitId>" with the visit data
    Then the response status code should be 204

    Examples:
      | visitId | date       | description    |
      | 1       | 2023-02-02 | Follow-up visit|

  Scenario Outline: Update a non-existent visit
    Given the following visit data:
      | date        | 2023-02-02 |
      | description | Follow-up visit |
    When I send a PUT request to "/visits/<visitId>" with the visit data
    Then the response status code should be 404

    Examples:
      | visitId |
      | 9999    |

  Scenario: Update a visit with invalid data
    Given the following visit data:
      | date        | invalid-date |
      | description | Follow-up visit |
    When I send a PUT request to "/visits/1" with the visit data
    Then the response status code should be 400

  # DELETE /visits/{visitId}
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