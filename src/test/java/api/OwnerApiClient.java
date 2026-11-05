=package org.springframework.samples.petclinic.rest.client;

import io.restassured.RestAssured;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;

import java.util.Map;

public class ApiClient {

    private final String baseUrl;

    public ApiClient() {
        // Base URL configurable via system property or environment variable
        String url = System.getProperty("petclinic.api.baseurl");
        if (url == null || url.isEmpty()) {
            url = System.getenv("PETCLINIC_API_BASEURL");
        }
        if (url == null || url.isEmpty()) {
            url = "http://localhost:9966/petclinic/api"; // default fallback
        }
        this.baseUrl = url;
    }

    private RequestSpecification givenJson() {
        return RestAssured.given()
                .baseUri(baseUrl)
                .contentType("application/json")
                .accept("application/json");
    }

    // Owners

    public Response getOwnerById(int ownerId) {
        return givenJson()
                .when()
                .get("/owners/{ownerId}", ownerId)
                .andReturn();
    }

    public Response createOwner(Map<String, Object> owner) {
        return givenJson()
                .body(owner)
                .when()
                .post("/owners")
                .andReturn();
    }

    public Response updateOwner(int ownerId, Map<String, Object> owner) {
        return givenJson()
                .body(owner)
                .when()
                .put("/owners/{ownerId}", ownerId)
                .andReturn();
    }

    public Response deleteOwner(int ownerId) {
        return givenJson()
                .when()
                .delete("/owners/{ownerId}", ownerId)
                .andReturn();
    }

    // Pets

    public Response getPetById(int petId) {
        return givenJson()
                .when()
                .get("/pets/{petId}", petId)
                .andReturn();
    }

    public Response createPet(Map<String, Object> pet) {
        return givenJson()
                .body(pet)
                .when()
                .post("/pets")
                .andReturn();
    }

    public Response updatePet(int petId, Map<String, Object> pet) {
        return givenJson()
                .body(pet)
                .when()
                .put("/pets/{petId}", petId)
                .andReturn();
    }

    public Response deletePet(int petId) {
        return givenJson()
                .when()
                .delete("/pets/{petId}", petId)
                .andReturn();
    }

    // Visits

    public Response getVisitById(int visitId) {
        return givenJson()
                .when()
                .get("/visits/{visitId}", visitId)
                .andReturn();
    }

    public Response createVisit(Map<String, Object> visit) {
        return givenJson()
                .body(visit)
                .when()
                .post("/visits")
                .andReturn();
    }

    public Response updateVisit(int visitId, Map<String, Object> visit) {
        return givenJson()
                .body(visit)
                .when()
                .put("/visits/{visitId}", visitId)
                .andReturn();
    }

    public Response deleteVisit(int visitId) {
        return givenJson()
                .when()
                .delete("/visits/{visitId}", visitId)
                .andReturn();
    }
}