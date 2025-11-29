package com.apirest.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "DV_VERTICAL_SCALING", schema = "WFM")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DvVerticalScaling {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "vertical_seq")
    @SequenceGenerator(name = "vertical_seq", sequenceName = "WFM.DV_VERTICAL_SCALING_SEQ", allocationSize = 1)
    @Column(name = "ID")
    private Long id;

    @NotBlank(message = "ID_USER_COVERAGE_MAP no puede estar vacío")
    @Column(name = "ID_USER_COVERAGE_MAP", nullable = false, length = 255)
    private String idUserCoverageMap;

    @NotBlank(message = "STATUS no puede estar vacío")
    @Pattern(regexp = "SCHEDULED|INTERRUPTED|COMPLETED|CANCELED|PENDING", 
             message = "STATUS debe ser: SCHEDULED, INTERRUPTED, COMPLETED, CANCELED o PENDING")
    @Column(name = "STATUS", nullable = false, length = 255)
    private String status;

    @NotBlank(message = "OPERATION_NAME no puede estar vacío")
    @Pattern(regexp = "ONSET|EXPANSION", 
             message = "OPERATION_NAME debe ser: ONSET o EXPANSION")
    @Column(name = "OPERATION_NAME", nullable = false, length = 255)
    private String operationName;

    @NotBlank(message = "PROCEDURE_NAME no puede estar vacío")
    @Pattern(regexp = "TPDV|TADV|TMDV|TGDV", 
             message = "PROCEDURE_NAME debe ser: TPDV, TADV, TMDV o TGDV")
    @Column(name = "PROCEDURE_NAME", nullable = false, length = 255)
    private String procedureName;

    @NotBlank(message = "SITE no puede estar vacío")
    @Pattern(regexp = "RELEASED|PLANNED|WITHOUT_PORTS", 
             message = "SITE debe ser: RELEASED, PLANNED o WITHOUT_PORTS")
    @Column(name = "SITE", nullable = false, length = 255)
    private String site;

    @NotBlank(message = "SEGMENT no puede estar vacío")
    @Pattern(regexp = "CORPORATE|RESIDENTIAL", 
             message = "SEGMENT debe ser: CORPORATE o RESIDENTIAL")
    @Column(name = "SEGMENT", nullable = false, length = 255)
    private String segment;

    @Column(name = "CREATED_AT")
    private LocalDateTime createdAt;

    @Column(name = "UPDATED_AT")
    private LocalDateTime updatedAt;

    @NotNull(message = "IS_RESCHEDULE no puede ser nulo")
    @Column(name = "IS_RESCHEDULE", nullable = false)
    private Integer isReschedule = 0;

    @Column(name = "PARENT_ID")
    private Long parentId;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (isReschedule == null) {
            isReschedule = 0;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
