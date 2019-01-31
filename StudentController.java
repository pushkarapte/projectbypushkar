package com.Tsfdemo.controller;

import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.Tsfdemo.model.StudentModel;
import com.Tsfdemo.repository.StudentRepo;

@RestController
@RequestMapping("/")
public class StudentController {
	
StudentModel studModel;
	
@Autowired
StudentRepo studRepo;


@GetMapping("students")
private List<StudentModel> getAll()
{
	return studRepo.findAll();
	}
	
@PostMapping("addStudent")
private StudentModel createStud(@valid @RequestBody StudentModel studM)
{
	return studRepo.save(studM);
}
	
	
}

