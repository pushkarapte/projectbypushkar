package com.Tsfdemo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Tsfdemo.model.StudentModel;

@Repository
public interface StudentRepo extends JpaRepository<StudentModel, Long>{

}
