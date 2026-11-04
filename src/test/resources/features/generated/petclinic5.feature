=Feature: Spring Petclinic REST API

  Background:
    Given the API base URL is configured

  # Owners API
  @owners
  Scenario Outline: Retrieve owner by ID
    When I send a GET request to "/owners/<ownerId>"
    Then the response status code should be <statusCode>
    And the response JSON should contain owner with id <ownerId>
  
    Examples:
      | ownerId | statusCode |
      | 1       | 200        |
      | 9999    | 404        |

  @owners
  Scenario Outline: Create a new owner
    When I send a POST request to "/owners" with body:
      """
      {
        "firstName": "<firstName>",
        "lastName": "<lastName>",
        "address": "<address>",
        "city": "<city>",
        "telephone": "<telephone>"
      }
      """
    Then the response status code should be <statusCode>
    And the response JSON should contain owner with firstName "<firstName>" and lastName "<lastName>"

    Examples:
      | firstName | lastName | address       | city       | telephone   | statusCode |
      | John      | Doe      | 123 Elm St    | Springfield| 1234567890  | 201        |
      |           | Doe      | 123 Elm St    | Springfield| 1234567890  | 400        |
      | John      |          | 123 Elm St    | Springfield| 1234567890  | 400        |
      | John      | Doe      |               | Springfield| 1234567890  | 400        |
      | John      | Doe      | 123 Elm St    |            | 1234567890  | 400        |
      | John      | Doe      | 123 Elm St    | Springfield| abcdefg    | 400        |

  @owners
  Scenario Outline: Update an existing owner
    When I send a PUT request to "/owners/<ownerId>" with body:
      """
      {
        "firstName": "<firstName>",
        "lastName": "<lastName>",
        "address": "<address>",
        "city": "<city>",
        "telephone": "<telephone>"
      }
      """
    Then the response status code should be <statusCode>
    And if <statusCode> = 200 then the response JSON should contain owner with id <ownerId> and firstName "<firstName>" and lastName "<lastName>"

    Examples:
      | ownerId | firstName | lastName | address       | city       | telephone   | statusCode |
      | 1       | Jane      | Smith    | 456 Oak St    | Shelbyville| 0987654321  | 200        |
      | 9999    | Jane      | Smith    | 456 Oak St    | Shelbyville| 0987654321  | 404        |
      | 1       |          | Smith    | 456 Oak St    | Shelbyville| 0987654321  | 400        |

  @owners
  Scenario Outline: Partially update an existing owner
    When I send a PATCH request to "/owners/<ownerId>" with body:
      """
      {
        "firstName": "<firstName>"
      }
      """
    Then the response status code should be <statusCode>
    And if <statusCode> = 200 then the response JSON should contain owner with id <ownerId> and firstName "<firstName>"

    Examples:
      | ownerId | firstName | statusCode |
      | 1       | Janet     | 200        |
      | 9999    | Janet     | 404        |
      | 1       |           | 400        |

  @owners
  Scenario Outline: Delete an owner by ID
    When I send a DELETE request to "/owners/<ownerId>"
    Then the response status code should be <statusCode>

    Examples:
      | ownerId | statusCode |
      | 1       | 204        |
      | 9999    | 404        |

  # Pets API
  @pets
  Scenario Outline: Retrieve pet by ID
    When I send a GET request to "/pets/<petId>"
    Then the response status code should be <statusCode>
    And the response JSON should contain pet with id <petId>

    Examples:
      | petId | statusCode |
      | 1     | 200        |
      | 9999  | 404        |

  @pets
  Scenario Outline: Create a new pet
    When I send a POST request to "/pets" with body:
      """
      {
        "name": "<name>",
        "birthDate": "<birthDate>",
        "type": {
          "id": <typeId>
        },
        "owner": {
          "id": <ownerId>
        }
      }
      """
    Then the response status code should be <statusCode>
    And the response JSON should contain pet with name "<name>" and owner id <ownerId>

    Examples:
      | name    | birthDate  | typeId | ownerId | statusCode |
      | Buddy   | 2018-01-01 | 1      | 1       | 201        |
      |         | 2018-01-01 | 1      | 1       | 400        |
      | Buddy   | invalid    | 1      | 1       | 400        |
      | Buddy   | 2018-01-01 | 9999   | 1       | 400        |
      | Buddy   | 2018-01-01 | 1      | 9999    | 400        |

  @pets
  Scenario Outline: Update an existing pet
    When I send a PUT request to "/pets/<petId>" with body:
      """
      {
        "name": "<name>",
        "birthDate": "<birthDate>",
        "type": {
          "id": <typeId>
        },
        "owner": {
          "id": <ownerId>
        }
      }
      """
    Then the response status code should be <statusCode>
    And if <statusCode> = 200 then the response JSON should contain pet with id <petId> and name "<name>"

    Examples:
      | petId | name    | birthDate  | typeId | ownerId | statusCode |
      | 1     | Max     | 2017-05-05 | 1      | 1       | 200        |
      | 9999  | Max     | 2017-05-05 | 1      | 1       | 404        |
      | 1     |         | 2017-05-05 | 1      | 1       | 400        |

  @pets
  Scenario Outline: Delete a pet by ID
    When I send a DELETE request to "/pets/<petId>"
    Then the response status code should be <statusCode>

    Examples:
      | petId | statusCode |
      | 1     | 204        |
      | 9999  | 404        |

  # Visits API
  @visits
  Scenario Outline: Retrieve visit by ID
    When I send a GET request to "/visits/<visitId>"
    Then the response status code should be <statusCode>
    And the response JSON should contain visit with id <visitId>

    Examples:
      | visitId | statusCode |
      | 1       | 200        |
      | 9999    | 404        |

  @visits
  Scenario Outline: Create a new visit
    When I send a POST request to "/visits" with body:
      """
      {
        "date": "<date>",
        "description": "<description>",
        "pet": {
          "id": <petId>
        }
      }
      """
    Then the response status code should be <statusCode>
    And the response JSON should contain visit with description "<description>" and pet id <petId>

    Examples:
      | date       | description       | petId | statusCode |
      | 2023-01-01 | Annual Checkup    | 1     | 201        |
      | invalid    | Annual Checkup    | 1     | 400        |
      | 2023-01-01 |                   | 1     | 400        |
      | 2023-01-01 | Annual Checkup    | 9999  | 400        |

  @visits
  Scenario Outline: Update an existing visit
    When I send a PUT request to "/visits/<visitId>" with body:
      """
      {
        "date": "<date>",
        "description": "<description>",
        "pet": {
          "id": <petId>
        }
      }
      """
    Then the response status code should be <statusCode>
    And if <statusCode> = 200 then the response JSON should contain visit with id <visitId> and description "<description>"

    Examples:
      | visitId | date       | description       | petId | statusCode |
      | 1       | 2023-02-02 | Follow-up Visit   | 1     | 200        |
      | 9999    | 2023-02-02 | Follow-up Visit   | 1     | 404        |
      | 1       | invalid    | Follow-up Visit   | 1     | 400        |

  @visits
  Scenario Outline: Delete a visit by ID
    When I send a DELETE request to "/visits/<visitId>"
    Then the response status code should be <statusCode>

    Examples:
      | visitId | statusCode |
      | 1       | 204        |
      | 9999    | 404        |

  # Pet Types API
  @pettypes
  Scenario: Retrieve all pet types
    When I send a GET request to "/pettypes"
    Then the response status code should be 200
    And the response JSON should be a non-empty list of pet types