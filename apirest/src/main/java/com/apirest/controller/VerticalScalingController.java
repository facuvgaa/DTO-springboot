package com.apirest.controller;

import com.apirest.model.DvVerticalScaling;
import com.apirest.service.VerticalScalingService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/vertical-scaling")
@CrossOrigin(origins = "*")
public class VerticalScalingController {

    @Autowired
    private VerticalScalingService service;

    @GetMapping
    public ResponseEntity<List<DvVerticalScaling>> getAll() {
        try {
            List<DvVerticalScaling> verticalScalings = service.findAll();
            return ResponseEntity.ok(verticalScalings);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<DvVerticalScaling> getById(@PathVariable Long id) {
        Optional<DvVerticalScaling> verticalScaling = service.findById(id);
        return verticalScaling.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<?> create(@Valid @RequestBody DvVerticalScaling verticalScaling) {
        try {
            DvVerticalScaling saved = service.save(verticalScaling);
            return ResponseEntity.status(HttpStatus.CREATED).body(saved);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Error al crear: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, 
                                     @Valid @RequestBody DvVerticalScaling verticalScaling) {
        try {
            DvVerticalScaling updated = service.update(id, verticalScaling);
            return ResponseEntity.ok(updated);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Error al actualizar: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            service.deleteById(id);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error al eliminar: " + e.getMessage());
        }
    }
}

