=package org.springframework.samples.petclinic.rest.client;

import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import io.restassured.response.Response;

import java.util.Map;

public class PetclinicApiClient {

    private String baseUrl;

    public PetclinicApiClient() {
        configureBaseUrl();
    }

    public void configureBaseUrl() {
        // Base URL can be configured via system property or environment variable
        String url = System.getProperty("petclinic.api.baseurl");
        if (url == null || url.isEmpty()) {
            url = System.getenv("PETCLINIC_API_BASEURL");
        }
        if (url == null || url.isEmpty()) {
            // Default to empty, user must configure explicitly
            url = "";
        }
        this.baseUrl = url.endsWith("/") ? url.substring(0, url.length() - 1) : url;
    }

    private String buildUrl(String endpoint) {
        if (endpoint.startsWith("/")) {
            return baseUrl + endpoint;
        } else {
            return baseUrl + "/" + endpoint;
        }
    }

    public Response get(String endpoint) {
        return RestAssured.given()
                .accept(ContentType.JSON)
                .when()
                .get(buildUrl(endpoint))
                .andReturn();
    }

    public Response post(String endpoint, Map<String, Object> body) {
        return RestAssured.given()
                .contentType(ContentType.JSON)
                .accept(ContentType.JSON)
                .body(body)
                .when()
                .post(buildUrl(endpoint))
                .andReturn();
    }

    public Response put(String endpoint, Map<String, Object> body) {
        return RestAssured.given()
                .contentType(ContentType.JSON)
                .accept(ContentType.JSON)
                .body(body)
                .when()
                .put(buildUrl(endpoint))
                .andReturn();
    }

    public Response delete(String endpoint) {
        return RestAssured.given()
                .accept(ContentType.JSON)
                .when()
                .delete(buildUrl(endpoint))
                .andReturn();
    }
}