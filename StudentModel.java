package com.tsfdemo.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class StudentModel {
	
	 @Id
	 @GeneratedValue(strategy = GenerationType.AUTO)
     private int id;
    
	 @Column(name= "Name")
	 private String name;

	public StudentModel()
	{
		
	}

	public StudentModel(int id, String name)
	{
		this.id = id;
		this.name = name;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	
}