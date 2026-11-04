=package org.springframework.samples.petclinic.rest.api;

import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import io.restassured.response.Response;

import java.util.Map;

public class ApiClient {

    private String baseUri = "http://localhost:9966/petclinic/api";

    public void setBaseUri(String baseUri) {
        this.baseUri = baseUri;
    }

    public Response getAllOwners() {
        return RestAssured.given()
                .baseUri(baseUri)
                .basePath("/owners")
                .accept(ContentType.JSON)
                .when()
                .get()
                .then()
                .extract()
                .response();
    }

    public Response getOwnerById(int ownerId) {
        return RestAssured.given()
                .baseUri(baseUri)
                .basePath("/owners/{ownerId}")
                .pathParam("ownerId", ownerId)
                .accept(ContentType.JSON)
                .when()
                .get()
                .then()
                .extract()
                .response();
    }

    public Response createOwner(Map<String, String> ownerData) {
        return RestAssured.given()
                .baseUri(baseUri)
                .basePath("/owners")
                .contentType(ContentType.JSON)
                .accept(ContentType.JSON)
                .body(ownerData)
                .when()
                .post()
                .then()
                .extract()
                .response();
    }

    public Response updateOwner(int ownerId, Map<String, String> ownerData) {
        return RestAssured.given()
                .baseUri(baseUri)
                .basePath("/owners/{ownerId}")
                .pathParam("ownerId", ownerId)
                .contentType(ContentType.JSON)
                .accept(ContentType.JSON)
                .body(ownerData)
                .when()
                .put()
                .then()
                .extract()
                .response();
    }

    public Response deleteOwner(int ownerId) {
        return RestAssured.given()
                .baseUri(baseUri)
                .basePath("/owners/{ownerId}")
                .pathParam("ownerId", ownerId)
                .when()
                .delete()
                .then()
                .extract()
                .response();
    }
}
```