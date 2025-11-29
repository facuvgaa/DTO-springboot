package com.apirest.repository;

import org.springframework.data.jpa.repository.JpaRepository;  
import org.springframework.stereotype.Repository;

import com.apirest.model.DvVerticalScaling;

@Repository
public interface VerticalScalingRepository extends JpaRepository<DvVerticalScaling, Long> {
}
