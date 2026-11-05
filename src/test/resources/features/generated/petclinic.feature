=Feature: Petclinic REST API - Owners, Pets, and Visits Management

  Background:
    Given the API base URL is configured

  # Owner endpoints
  @owner
  Scenario Outline: Retrieve an existing owner by ID
    When I send a GET request to "/owners/<ownerId>"
    Then the response status code should be 200
    And the response JSON should contain owner with id <ownerId> and lastName "<lastName>"

    Examples:
      | ownerId | lastName  |
      | 1       | Davis     |
      | 2       | Coleman   |

  @owner
  Scenario Outline: Retrieve a non-existent owner by ID
    When I send a GET request to "/owners/<ownerId>"
    Then the response status code should be 404

    Examples:
      | ownerId |
      | 9999    |
      | 0       |

  @owner
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
      | firstName | lastName | address         | city       | telephone   |
      | John      | Smith    | 123 Elm Street  | Springfield| 1234567890  |
      | Alice     | Johnson  | 456 Oak Avenue  | Shelbyville| 0987654321  |

  @owner
  Scenario Outline: Create a new owner with missing mandatory fields
    Given the following owner data:
      | firstName | <firstName> |
      | lastName  | <lastName>  |
    When I send a POST request to "/owners" with the owner data
    Then the response status code should be 400

    Examples:
      | firstName | lastName |
      |           | Smith    |
      | John      |          |

  @owner
  Scenario Outline: Update an existing owner with valid data
    Given the following owner data:
      | firstName | <firstName> |
      | lastName  | <lastName>  |
      | address   | <address>   |
      | city      | <city>      |
      | telephone | <telephone> |
    When I send a PUT request to "/owners/<ownerId>" with the owner data
    Then the response status code should be 204
    And no content is returned

    Examples:
      | ownerId | firstName | lastName | address         | city       | telephone   |
      | 1       | John      | Smith    | 123 Elm Street  | Springfield| 1234567890  |

  @owner
  Scenario Outline: Update a non-existent owner
    Given the following owner data:
      | firstName | John    |
      | lastName  | Smith   |
    When I send a PUT request to "/owners/<ownerId>" with the owner data
    Then the response status code should be 404

    Examples:
      | ownerId |
      | 9999    |

  @owner
  Scenario Outline: Delete an existing owner
    When I send a DELETE request to "/owners/<ownerId>"
    Then the response status code should be 204
    And no content is returned

    Examples:
      | ownerId |
      | 1       |

  @owner
  Scenario Outline: Delete a non-existent owner
    When I send a DELETE request to "/owners/<ownerId>"
    Then the response status code should be 404

    Examples:
      | ownerId |
      | 9999    |

  # Pet endpoints
  @pet
  Scenario Outline: Retrieve an existing pet by ID
    When I send a GET request to "/pets/<petId>"
    Then the response status code should be 200
    And the response JSON should contain pet with id <petId> and name "<name>"

    Examples:
      | petId | name    |
      | 1     | Leo     |
      | 2     | Basil   |

  @pet
  Scenario Outline: Retrieve a non-existent pet by ID
    When I send a GET request to "/pets/<petId>"
    Then the response status code should be 404

    Examples:
      | petId |
      | 9999  |

  @pet
  Scenario Outline: Create a new pet with valid data
    Given the following pet data:
      | name   | <name>    |
      | birthDate | <birthDate> |
      | type   | <type>    |
      | ownerId| <ownerId> |
    When I send a POST request to "/pets" with the pet data
    Then the response status code should be 201
    And the response JSON should contain pet with name "<name>"

    Examples:
      | name  | birthDate  | type   | ownerId |
      | Max   | 2018-01-01 | dog    | 1       |
      | Bella | 2019-05-15 | cat    | 2       |

  @pet
  Scenario Outline: Create a new pet with missing mandatory fields
    Given the following pet data:
      | name | <name> |
    When I send a POST request to "/pets" with the pet data
    Then the response status code should be 400

    Examples:
      | name  |
      |       |
      | Max   |

  @pet
  Scenario Outline: Update an existing pet with valid data
    Given the following pet data:
      | name   | <name>    |
      | birthDate | <birthDate> |
      | type   | <type>    |
      | ownerId| <ownerId> |
    When I send a PUT request to "/pets/<petId>" with the pet data
    Then the response status code should be 204
    And no content is returned

    Examples:
      | petId | name  | birthDate  | type | ownerId |
      | 1     | Max   | 2018-01-01 | dog  | 1       |

  @pet
  Scenario Outline: Update a non-existent pet
    Given the following pet data:
      | name | Max |
    When I send a PUT request to "/pets/<petId>" with the pet data
    Then the response status code should be 404

    Examples:
      | petId |
      | 9999  |

  @pet
  Scenario Outline: Delete an existing pet
    When I send a DELETE request to "/pets/<petId>"
    Then the response status code should be 204
    And no content is returned

    Examples:
      | petId |
      | 1     |

  @pet
  Scenario Outline: Delete a non-existent pet
    When I send a DELETE request to "/pets/<petId>"
    Then the response status code should be 404

    Examples:
      | petId |
      | 9999  |

  # Visit endpoints
  @visit
  Scenario Outline: Retrieve an existing visit by ID
    When I send a GET request to "/visits/<visitId>"
    Then the response status code should be 200
    And the response JSON should contain visit with id <visitId> and description "<description>"

    Examples:
      | visitId | description          |
      | 1       | Annual checkup       |
      | 2       | Vaccination          |

  @visit
  Scenario Outline: Retrieve a non-existent visit by ID
    When I send a GET request to "/visits/<visitId>"
    Then the response status code should be 404

    Examples:
      | visitId |
      | 9999    |

  @visit
  Scenario Outline: Create a new visit with valid data
    Given the following visit data:
      | date        | <date>           |
      | description | <description>    |
      | petId       | <petId>          |
    When I send a POST request to "/visits" with the visit data
    Then the response status code should be 201
    And the response JSON should contain visit with description "<description>"

    Examples:
      | date       | description      | petId |
      | 2023-01-01 | Annual checkup   | 1     |
      | 2023-06-15 | Vaccination      | 2     |

  @visit
  Scenario Outline: Create a new visit with missing mandatory fields
    Given the following visit data:
      | description | <description> |
    When I send a POST request to "/visits" with the visit data
    Then the response status code should be 400

    Examples:
      | description |
      |             |
      | Checkup     |

  @visit
  Scenario Outline: Update an existing visit with valid data
    Given the following visit data:
      | date        | <date>           |
      | description | <description>    |
      | petId       | <petId>          |
    When I send a PUT request to "/visits/<visitId>" with the visit data
    Then the response status code should be 204
    And no content is returned

    Examples:
      | visitId | date       | description    | petId |
      | 1       | 2023-01-01 | Annual checkup | 1     |

  @visit
  Scenario Outline: Update a non-existent visit
    Given the following visit data:
      | description | Checkup |
    When I send a PUT request to "/visits/<visitId>" with the visit data
    Then the response status code should be 404

    Examples:
      | visitId |
      | 9999    |

  @visit
  Scenario Outline: Delete an existing visit
    When I send a DELETE request to "/visits/<visitId>"
    Then the response status code should be 204
    And no content is returned

    Examples:
      | visitId |
      | 1       |

  @visit
  Scenario Outline: Delete a non-existent visit
    When I send a DELETE request to "/visits/<visitId>"
    Then the response status code should be 404

    Examples:
      | visitId |
      | 9999    |

  # Malformed JSON scenarios
  @error
  Scenario Outline: Send malformed JSON in POST request to <endpoint>
    When I send a POST request to "<endpoint>" with malformed JSON body
    Then the response status code should be 400

    Examples:
      | endpoint   |
      | /owners    |
      | /pets      |
      | /visits    |

  @error
  Scenario Outline: Send malformed JSON in PUT request to <endpoint>
    When I send a PUT request to "<endpoint>" with malformed JSON body
    Then the response status code should be 400

    Examples:
      | endpoint          |
      | /owners/1         |
      | /pets/1           |
      | /visits/1         |