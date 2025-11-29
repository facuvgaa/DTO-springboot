package com.apirest.service;

import com.apirest.model.DvVerticalScaling;
import com.apirest.repository.VerticalScalingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class VerticalScalingService {

    @Autowired
    private VerticalScalingRepository repository;

    public List<DvVerticalScaling> findAll() {
        return repository.findAll();
    }

    public Optional<DvVerticalScaling> findById(Long id) {
        return repository.findById(id);
    }

    public DvVerticalScaling save(DvVerticalScaling verticalScaling) {
        return repository.save(verticalScaling);
    }

    public DvVerticalScaling update(Long id, DvVerticalScaling verticalScalingDetails) {
        DvVerticalScaling verticalScaling = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Vertical Scaling no encontrado con id: " + id));

        verticalScaling.setIdUserCoverageMap(verticalScalingDetails.getIdUserCoverageMap());
        verticalScaling.setStatus(verticalScalingDetails.getStatus());
        verticalScaling.setOperationName(verticalScalingDetails.getOperationName());
        verticalScaling.setProcedureName(verticalScalingDetails.getProcedureName());
        verticalScaling.setSite(verticalScalingDetails.getSite());
        verticalScaling.setSegment(verticalScalingDetails.getSegment());
        verticalScaling.setIsReschedule(verticalScalingDetails.getIsReschedule());
        verticalScaling.setParentId(verticalScalingDetails.getParentId());

        return repository.save(verticalScaling);
    }

    public void deleteById(Long id) {
        if (!repository.existsById(id)) {
            throw new RuntimeException("Vertical Scaling no encontrado con id: " + id);
        }
        repository.deleteById(id);
    }

    public boolean existsById(Long id) {
        return repository.existsById(id);
    }
}

