package com.github.francisfire.anavis.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.github.francisfire.anavis.models.Donor;
import com.github.francisfire.anavis.models.Donor.DonorCategory;
import com.github.francisfire.anavis.models.Office;
import com.github.francisfire.anavis.services.DonorServices;
import com.github.francisfire.anavis.services.OfficeServices;

@SpringBootTest
public class DonorServicesTest {

	@Autowired
	private DonorServices donorServices;
	@Autowired
	private OfficeServices officeServices;

	@BeforeEach
	public void initSingleTest() {
		Office officeOne = new Office("officeOne@office.com", "officeOne");
		officeServices.addOffice(officeOne);
		Office officeTwo = new Office("officeTwo@office.com", "officeTwo");
		officeServices.addOffice(officeTwo);

		Donor donor = new Donor("donor@gmail.com", "officeOne@office.com", DonorCategory.MAN);
		donorServices.addDonor(donor);
		Donor secondDonor = new Donor("secondDonor@gmail.com", "officeOne@office.com", DonorCategory.MAN);
		secondDonor.setCanDonate(false);
		donorServices.addDonor(secondDonor);

	}

	@AfterEach
	public void closeSingleTest() {
		donorServices.removeDonor("donor@gmail.com");
		officeServices.removeOffice("officeOne@office.com");
		officeServices.removeOffice("officeTwo@office.com");
	}

	@Test
	public void addDonor() {
		assertThrows(NullPointerException.class, () -> donorServices.addDonor(null));

		Donor newDonor = new Donor("newDonor@gmail.com", "officeOne@office.com", DonorCategory.MAN);
		assertTrue(donorServices.addDonor(newDonor));
		assertFalse(donorServices.addDonor(newDonor));
		assertFalse(donorServices.getDonors().isEmpty());
	}

	@Test
	public void getOfficeIdByDonor() {
		assertThrows(NullPointerException.class, () -> donorServices.getOfficeIdByDonor(null));

		assertEquals("officeOne@office.com", donorServices.getOfficeIdByDonor("donor@gmail.com"));
		assertNotEquals("officeTwo@office.com", donorServices.getOfficeIdByDonor("donor@gmail.com"));
		assertNull(donorServices.getOfficeIdByDonor("fakeDonor@gmail.com"));
	}

	@Test
	public void checkDonationPossibility() {
		assertThrows(NullPointerException.class, () -> donorServices.checkDonationPossibility(null));

		assertTrue(donorServices.checkDonationPossibility("donor@gmail.com"));
		assertFalse(donorServices.checkDonationPossibility("secondDonor@gmail.com"));
		assertFalse(donorServices.checkDonationPossibility("fakeDonor@gmail.com"));
	}

	@Test
	public void getDonorsByOfficeId() {
		assertThrows(NullPointerException.class, () -> donorServices.getDonorsByOfficeId(null));

		Donor donor = new Donor("donor@gmail.com", "officeOne@office.com", DonorCategory.MAN);

		assertTrue(donorServices.getDonorsByOfficeId("officeOne@office.com").contains(donor));
		assertFalse(donorServices.getDonorsByOfficeId("officeTwo@office.com").contains(donor));
	}

	@Test
	public void getAvailableDonorsByOfficeId() {
		assertThrows(NullPointerException.class, () -> donorServices.getAvailableDonorsByOfficeId(null));

		Donor donor = new Donor("donor@gmail.com", "officeOne@office.com", DonorCategory.MAN);
		Donor secondDonor = new Donor("secondDonor@gmail.com", "officeOne@office.com", DonorCategory.MAN);
		assertTrue(donorServices.getAvailableDonorsByOfficeId("officeOne@office.com").contains(donor));
		assertFalse(donorServices.getAvailableDonorsByOfficeId("officeOne@office.com").contains(secondDonor));
	}

}
