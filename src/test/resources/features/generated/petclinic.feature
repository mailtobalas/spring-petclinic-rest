=Feature: Petclinic REST API - Owners, Pets, and Visits Management

  Background:
    Given the API base URL is configured

  # Owner endpoints
  # GET /owners/{ownerId}
  Scenario Outline: Retrieve an existing owner by ID
    When I send a GET request to "/owners/<ownerId>"
    Then the response status code should be <statusCode>
    And the response JSON should contain owner with id <ownerId> and lastName "<lastName>"

    Examples:
      | ownerId | lastName   | statusCode |
      | 1       | Davis      | 200        |
      | 2       | Mueller    | 200        |

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
      | firstName | lastName | address       | city       | telephone  |
      | John      | Doe      | 123 Elm St    | Springfield| 1234567890 |
      | Jane      | Smith    | 456 Oak Ave   | Shelbyville| 0987654321 |

  Scenario Outline: Create a new owner with missing required fields
    Given the following owner data:
      | firstName | <firstName> |
      | lastName  | <lastName>  |
      | address   | <address>   |
      | city      | <city>      |
      | telephone | <telephone> |
    When I send a POST request to "/owners" with the owner data
    Then the response status code should be 400

    Examples:
      # Missing lastName
      | firstName | lastName | address     | city       | telephone  |
      | John      |          | 123 Elm St  | Springfield| 1234567890 |
      # Missing telephone
      | Jane      | Smith    | 456 Oak Ave | Shelbyville|            |

  Scenario Outline: Create a new owner with invalid telephone number
    Given the following owner data:
      | firstName | <firstName> |
      | lastName  | <lastName>  |
      | address   | <address>   |
      | city      | <city>      |
      | telephone | <telephone> |
    When I send a POST request to "/owners" with the owner data
    Then the response status code should be 400

    Examples:
      | firstName | lastName | address     | city       | telephone  |
      | John      | Doe      | 123 Elm St  | Springfield| abcdefg    |
      | Jane      | Smith    | 456 Oak Ave | Shelbyville| 12345abc   |

  # PUT /owners/{ownerId}
  Scenario Outline: Update an existing owner with valid data
    Given the following owner data:
      | firstName | <firstName> |
      | lastName  | <lastName>  |
      | address   | <address>   |
      | city      | <city>      |
      | telephone | <telephone> |
    When I send a PUT request to "/owners/<ownerId>" with the owner data
    Then the response status code should be <statusCode>
    And the response JSON should contain owner with lastName "<lastName>"

    Examples:
      | ownerId | firstName | lastName | address      | city       | telephone  | statusCode |
      | 1       | Michael   | Weston   | 789 Pine Rd  | Miami      | 5551234567 | 200        |
      | 9999    | John      | Doe      | 123 Elm St   | Springfield| 1234567890 | 404        |

  Scenario Outline: Update an existing owner with invalid data
    Given the following owner data:
      | firstName | <firstName> |
      | lastName  | <lastName>  |
      | address   | <address>   |
      | city      | <city>      |
      | telephone | <telephone> |
    When I send a PUT request to "/owners/<ownerId>" with the owner data
    Then the response status code should be 400

    Examples:
      | ownerId | firstName | lastName | address     | city       | telephone  |
      | 1       | John      |          | 123 Elm St  | Springfield| 1234567890 |
      | 1       | Jane      | Smith    | 456 Oak Ave | Shelbyville| abcdefg    |

  # DELETE /owners/{ownerId}
  Scenario Outline: Delete an existing owner by ID
    When I send a DELETE request to "/owners/<ownerId>"
    Then the response status code should be <statusCode>

    Examples:
      | ownerId | statusCode |
      | 1       | 204        |
      | 9999    | 404        |

  # Pet endpoints
  # GET /pets/{petId}
  Scenario Outline: Retrieve an existing pet by ID
    When I send a GET request to "/pets/<petId>"
    Then the response status code should be <statusCode>
    And the response JSON should contain pet with id <petId> and name "<name>"

    Examples:
      | petId | name    | statusCode |
      | 1     | Leo     | 200        |
      | 2     | Basil   | 200        |

  Scenario Outline: Retrieve a non-existent pet by ID
    When I send a GET request to "/pets/<petId>"
    Then the response status code should be 404

    Examples:
      | petId |
      | 9999  |
      | 0     |

  # POST /pets
  Scenario Outline: Create a new pet with valid data
    Given the following pet data:
      | name     | <name>     |
      | birthDate| <birthDate>|
      | type     | <type>     |
      | ownerId  | <ownerId>  |
    When I send a POST request to "/pets" with the pet data
    Then the response status code should be 201
    And the response JSON should contain pet with name "<name>"

    Examples:
      | name   | birthDate  | type    | ownerId |
      | Rocky  | 2018-01-01 | dog     | 1       |
      | Whiskers| 2019-05-20| cat     | 2       |

  Scenario Outline: Create a new pet with missing required fields
    Given the following pet data:
      | name     | <name>     |
      | birthDate| <birthDate>|
      | type     | <type>     |
      | ownerId  | <ownerId>  |
    When I send a POST request to "/pets" with the pet data
    Then the response status code should be 400

    Examples:
      # Missing name
      | name | birthDate  | type | ownerId |
      |      | 2018-01-01 | dog  | 1       |
      # Missing ownerId
      | name   | birthDate  | type | ownerId |
      | Rocky  | 2018-01-01 | dog  |         |

  Scenario Outline: Create a new pet with invalid birthDate format
    Given the following pet data:
      | name     | <name>     |
      | birthDate| <birthDate>|
      | type     | <type>     |
      | ownerId  | <ownerId>  |
    When I send a POST request to "/pets" with the pet data
    Then the response status code should be 400

    Examples:
      | name  | birthDate | type | ownerId |
      | Rocky | 01-01-2018| dog  | 1       |
      | Whiskers | 2018/01/01 | cat | 2     |

  # PUT /pets/{petId}
  Scenario Outline: Update an existing pet with valid data
    Given the following pet data:
      | name     | <name>     |
      | birthDate| <birthDate>|
      | type     | <type>     |
      | ownerId  | <ownerId>  |
    When I send a PUT request to "/pets/<petId>" with the pet data
    Then the response status code should be <statusCode>
    And the response JSON should contain pet with name "<name>"

    Examples:
      | petId | name    | birthDate  | type  | ownerId | statusCode |
      | 1     | Max     | 2017-12-12 | dog   | 1       | 200        |
      | 9999  | Max     | 2017-12-12 | dog   | 1       | 404        |

  Scenario Outline: Update an existing pet with invalid data
    Given the following pet data:
      | name     | <name>     |
      | birthDate| <birthDate>|
      | type     | <type>     |
      | ownerId  | <ownerId>  |
    When I send a PUT request to "/pets/<petId>" with the pet data
    Then the response status code should be 400

    Examples:
      | petId | name | birthDate  | type | ownerId |
      | 1     |      | 2017-12-12 | dog  | 1       |
      | 1     | Max  | invalid    | dog  | 1       |

  # DELETE /pets/{petId}
  Scenario Outline: Delete an existing pet by ID
    When I send a DELETE request to "/pets/<petId>"
    Then the response status code should be <statusCode>

    Examples:
      | petId | statusCode |
      | 1     | 204        |
      | 9999  | 404        |

  # Visit endpoints
  # GET /visits/{visitId}
  Scenario Outline: Retrieve an existing visit by ID
    When I send a GET request to "/visits/<visitId>"
    Then the response status code should be <statusCode>
    And the response JSON should contain visit with id <visitId> and description "<description>"

    Examples:
      | visitId | description          | statusCode |
      | 1       | Annual checkup       | 200        |
      | 2       | Vaccination          | 200        |

  Scenario Outline: Retrieve a non-existent visit by ID
    When I send a GET request to "/visits/<visitId>"
    Then the response status code should be 404

    Examples:
      | visitId |
      | 9999    |
      | 0       |

  # POST /visits
  Scenario Outline: Create a new visit with valid data
    Given the following visit data:
      | petId       | <petId>       |
      | visitDate   | <visitDate>   |
      | description | <description> |
    When I send a POST request to "/visits" with the visit data
    Then the response status code should be 201
    And the response JSON should contain visit with description "<description>"

    Examples:
      | petId | visitDate  | description     |
      | 1     | 2023-01-01 | Annual checkup  |
      | 2     | 2023-06-15 | Vaccination     |

  Scenario Outline: Create a new visit with missing required fields
    Given the following visit data:
      | petId       | <petId>       |
      | visitDate   | <visitDate>   |
      | description | <description> |
    When I send a POST request to "/visits" with the visit data
    Then the response status code should be 400

    Examples:
      # Missing petId
      | petId | visitDate  | description    |
      |       | 2023-01-01 | Annual checkup |
      # Missing description
      | petId | visitDate  | description    |
      | 1     | 2023-01-01 |                |

  Scenario Outline: Create a new visit with invalid visitDate format
    Given the following visit data:
      | petId       | <petId>       |
      | visitDate   | <visitDate>   |
      | description | <description> |
    When I send a POST request to "/visits" with the visit data
    Then the response status code should be 400

    Examples:
      | petId | visitDate | description    |
      | 1     | 01-01-2023| Annual checkup |
      | 2     | 2023/01/01| Vaccination    |

  # PUT /visits/{visitId}
  Scenario Outline: Update an existing visit with valid data
    Given the following visit data:
      | petId       | <petId>       |
      | visitDate   | <visitDate>   |
      | description | <description> |
    When I send a PUT request to "/visits/<visitId>" with the visit data
    Then the response status code should be <statusCode>
    And the response JSON should contain visit with description "<description>"

    Examples:
      | visitId | petId | visitDate  | description    | statusCode |
      | 1       | 1     | 2023-02-02 | Dental cleaning| 200        |
      | 9999    | 1     | 2023-02-02 | Dental cleaning| 404        |

  Scenario Outline: Update an existing visit with invalid data
    Given the following visit data:
      | petId       | <petId>       |
      | visitDate   | <visitDate>   |
      | description | <description> |
    When I send a PUT request to "/visits/<visitId>" with the visit data
    Then the response status code should be 400

    Examples:
      | visitId | petId | visitDate  | description |
      | 1       |       | 2023-02-02 | Dental cleaning |
      | 1       | 1     | invalid    | Dental cleaning |

  # DELETE /visits/{visitId}
  Scenario Outline: Delete an existing visit by ID
    When I send a DELETE request to "/visits/<visitId>"
    Then the response status code should be <statusCode>

    Examples:
      | visitId | statusCode |
      | 1       | 204        |
      | 9999    | 404        |