package com.github.francisfire.anavis;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import com.github.francisfire.anavis.models.Donatore;
import com.github.francisfire.anavis.models.UfficioAVIS;
import com.github.francisfire.anavis.services.GestoreDonatori;

import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@SpringBootTest
public class DonorServicesTest {

	private static GestoreDonatori donorServices;
	
	@BeforeAll
	public static void setUp() {
		donorServices = GestoreDonatori.getInstance();
	}
	
	@Test
	public void addDonor() {
		UfficioAVIS avisPineto = new UfficioAVIS("Pineto");
		assertTrue(donorServices.addDonor(new Donatore("Gianni", avisPineto)));
		assertFalse(donorServices.getDonors().isEmpty());
	}
	
}
