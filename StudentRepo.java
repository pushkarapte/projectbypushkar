package com.tsfdemo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.tsfdemo.model.StudentModel;

	@Repository
	public interface StudentRepo extends JpaRepository<StudentModel, Long>{


	}