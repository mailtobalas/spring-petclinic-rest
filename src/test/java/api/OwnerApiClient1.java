=package org.springframework.samples.petclinic.rest.api;

import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import io.restassured.response.Response;

public class PetclinicApiClient {

    private String baseUrl;

    public void configureBaseUrl() {
        // Configure base URL from environment variable or default
        String envBaseUrl = System.getenv("PETCLINIC_API_BASE_URL");
        if (envBaseUrl != null && !envBaseUrl.isBlank()) {
            baseUrl = envBaseUrl;
        } else {
            baseUrl = "http://localhost:9966/petclinic/api";
        }
        RestAssured.baseURI = baseUrl;
    }

    public Response get(String endpoint) {
        return RestAssured
                .given()
                .accept(ContentType.JSON)
                .when()
                .get(endpoint)
                .andReturn();
    }

    public Response post(String endpoint, String jsonBody) {
        return RestAssured
                .given()
                .contentType(ContentType.JSON)
                .accept(ContentType.JSON)
                .body(jsonBody)
                .when()
                .post(endpoint)
                .andReturn();
    }

    public Response put(String endpoint, String jsonBody) {
        return RestAssured
                .given()
                .contentType(ContentType.JSON)
                .accept(ContentType.JSON)
                .body(jsonBody)
                .when()
                .put(endpoint)
                .andReturn();
    }

    public Response patch(String endpoint, String jsonBody) {
        return RestAssured
                .given()
                .contentType("application/merge-patch+json")
                .accept(ContentType.JSON)
                .body(jsonBody)
                .when()
                .patch(endpoint)
                .andReturn();
    }

    public Response delete(String endpoint) {
        return RestAssured
                .given()
                .accept(ContentType.JSON)
                .when()
                .delete(endpoint)
                .andReturn();
    }
}