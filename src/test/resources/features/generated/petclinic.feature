=Feature: Petclinic REST API - Owners, Pets, and Visits Management

  Background:
    Given the API base URL is configured

  # OWNER ENDPOINTS

  Scenario: Retrieve all owners successfully
    When I send a GET request to "/api/owners"
    Then the response status code should be 200
    And the response JSON should contain owner with lastName "Davis"

  Scenario Outline: Retrieve owner by ID
    When I send a GET request to "/api/owners/<ownerId>"
    Then the response status code should be <status>
    And if <status> = 200 then the response JSON should contain owner with id <ownerId> and lastName "<lastName>"

    Examples:
      | ownerId | lastName | status |
      | 1       | Davis    | 200    |
      | 9999    |          | 404    |

  Scenario Outline: Create a new owner with valid data
    Given the following owner data:
      | firstName | <firstName> |
      | lastName  | <lastName>  |
      | address   | <address>   |
      | city      | <city>      |
      | telephone | <telephone> |
    When I send a POST request to "/api/owners" with the owner data
    Then the response status code should be 201
    And the response JSON should contain owner with lastName "<lastName>"

    Examples:
      | firstName | lastName | address       | city       | telephone  |
      | John      | Smith    | 123 Elm St    | Springfield| 1234567890 |

  Scenario Outline: Create a new owner with missing required fields
    Given the following owner data:
      | firstName | <firstName> |
      | lastName  | <lastName>  |
      | address   | <address>   |
      | city      | <city>      |
      | telephone | <telephone> |
    When I send a POST request to "/api/owners" with the owner data
    Then the response status code should be 400

    Examples:
      | firstName | lastName | address | city | telephone |
      |           | Smith    | 123 Elm | City | 1234567   |
      | John      |          | 123 Elm | City | 1234567   |
      | John      | Smith    |         | City | 1234567   |
      | John      | Smith    | 123 Elm |      | 1234567   |
      | John      | Smith    | 123 Elm | City |           |

  Scenario Outline: Update an existing owner with valid data
    Given the following owner data:
      | firstName | <firstName> |
      | lastName  | <lastName>  |
      | address   | <address>   |
      | city      | <city>      |
      | telephone | <telephone> |
    When I send a PUT request to "/api/owners/<ownerId>" with the owner data
    Then the response status code should be <status>
    And if <status> = 204 then no content is returned

    Examples:
      | ownerId | firstName | lastName | address    | city       | telephone  | status |
      | 1       | John      | Smith    | 123 Elm St | Springfield| 1234567890 | 204    |
      | 9999    | John      | Smith    | 123 Elm St | Springfield| 1234567890 | 404    |

  Scenario Outline: Delete an existing owner
    When I send a DELETE request to "/api/owners/<ownerId>"
    Then the response status code should be <status>

    Examples:
      | ownerId | status |
      | 1       | 204    |
      | 9999    | 404    |

  # PET ENDPOINTS

  Scenario Outline: Retrieve pet by ID
    When I send a GET request to "/api/pets/<petId>"
    Then the response status code should be <status>
    And if <status> = 200 then the response JSON should contain pet with id <petId> and name "<name>"

    Examples:
      | petId | name    | status |
      | 1     | Leo     | 200    |
      | 9999  |         | 404    |

  Scenario Outline: Create a new pet with valid data
    Given the following pet data:
      | name      | <name>      |
      | birthDate | <birthDate> |
      | type      | <type>      |
      | ownerId   | <ownerId>   |
    When I send a POST request to "/api/pets" with the pet data
    Then the response status code should be 201
    And the response JSON should contain pet with name "<name>"

    Examples:
      | name  | birthDate  | type   | ownerId |
      | Bella | 2018-06-01 | dog    | 1       |

  Scenario Outline: Create a new pet with missing or invalid fields
    Given the following pet data:
      | name      | <name>      |
      | birthDate | <birthDate> |
      | type      | <type>      |
      | ownerId   | <ownerId>   |
    When I send a POST request to "/api/pets" with the pet data
    Then the response status code should be 400

    Examples:
      | name  | birthDate  | type   | ownerId |
      |       | 2018-06-01 | dog    | 1       |
      | Bella |            | dog    | 1       |
      | Bella | 2018-06-01 |        | 1       |
      | Bella | 2018-06-01 | dog    |         |

  Scenario Outline: Update an existing pet with valid data
    Given the following pet data:
      | name      | <name>      |
      | birthDate | <birthDate> |
      | type      | <type>      |
      | ownerId   | <ownerId>   |
    When I send a PUT request to "/api/pets/<petId>" with the pet data
    Then the response status code should be <status>

    Examples:
      | petId | name  | birthDate  | type | ownerId | status |
      | 1     | Max   | 2017-05-01 | cat  | 1       | 204    |
      | 9999  | Max   | 2017-05-01 | cat  | 1       | 404    |

  Scenario Outline: Delete an existing pet
    When I send a DELETE request to "/api/pets/<petId>"
    Then the response status code should be <status>

    Examples:
      | petId | status |
      | 1     | 204    |
      | 9999  | 404    |

  # VISIT ENDPOINTS

  Scenario Outline: Retrieve visit by ID
    When I send a GET request to "/api/visits/<visitId>"
    Then the response status code should be <status>
    And if <status> = 200 then the response JSON should contain visit with id <visitId> and description "<description>"

    Examples:
      | visitId | description       | status |
      | 1       | Annual checkup    | 200    |
      | 9999    |                   | 404    |

  Scenario Outline: Create a new visit with valid data
    Given the following visit data:
      | date        | <date>        |
      | description | <description> |
      | petId       | <petId>       |
    When I send a POST request to "/api/visits" with the visit data
    Then the response status code should be 201
    And the response JSON should contain visit with description "<description>"

    Examples:
      | date       | description    | petId |
      | 2023-01-01 | Vaccination    | 1     |

  Scenario Outline: Create a new visit with missing or invalid fields
    Given the following visit data:
      | date        | <date>        |
      | description | <description> |
      | petId       | <petId>       |
    When I send a POST request to "/api/visits" with the visit data
    Then the response status code should be 400

    Examples:
      | date       | description | petId |
      |            | Checkup     | 1     |
      | 2023-01-01 |             | 1     |
      | 2023-01-01 | Checkup     |       |

  Scenario Outline: Update an existing visit with valid data
    Given the following visit data:
      | date        | <date>        |
      | description | <description> |
      | petId       | <petId>       |
    When I send a PUT request to "/api/visits/<visitId>" with the visit data
    Then the response status code should be <status>

    Examples:
      | visitId | date       | description | petId | status |
      | 1       | 2023-02-01 | Checkup     | 1     | 204    |
      | 9999    | 2023-02-01 | Checkup     | 1     | 404    |

  Scenario Outline: Delete an existing visit
    When I send a DELETE request to "/api/visits/<visitId>"
    Then the response status code should be <status>

    Examples:
      | visitId | status |
      | 1       | 204    |
      | 9999    | 404    |

  # ERROR SCENARIOS

  Scenario: Send malformed JSON in POST request to owners endpoint
    Given the following owner data:
      | firstName | John |
      | lastName  | Smith|
      | address   | 123 Elm St |
      | city      | Springfield|
      | telephone | 1234567890 |
    When I send a POST request to "/api/owners" with malformed JSON body
    Then the response status code should be 400

  Scenario: Send malformed JSON in POST request to pets endpoint
    Given the following pet data:
      | name      | Bella      |
      | birthDate | 2018-06-01 |
      | type      | dog        |
      | ownerId   | 1          |
    When I send a POST request to "/api/pets" with malformed JSON body
    Then the response status code should be 400

  Scenario: Send malformed JSON in POST request to visits endpoint
    Given the following visit data:
      | date        | 2023-01-01 |
      | description | Vaccination|
      | petId       | 1          |
    When I send a POST request to "/api/visits" with malformed JSON body
    Then the response status code should be 400