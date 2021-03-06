package com.github.francisfire.anavis.controller;

import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.github.francisfire.anavis.component.AccessCheckerComponent;
import com.github.francisfire.anavis.models.AuthCredentials;
import com.github.francisfire.anavis.models.AuthCredentials.Role;
import com.github.francisfire.anavis.models.Donor;
import com.github.francisfire.anavis.models.Office;
import com.github.francisfire.anavis.services.AuthCredentialsServices;
import com.github.francisfire.anavis.services.DonorServices;
import com.github.francisfire.anavis.services.OfficeServices;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@RestController
@RequestMapping("/api/auth")
public class AuthCredentialsController {

	@Autowired
	private AuthCredentialsServices authCredentialsServices;

	@Autowired
	private DonorServices donorServices;

	@Autowired
	private OfficeServices officeServices;

	@SuppressWarnings("unused")
	@Autowired
	private AccessCheckerComponent accessCheckerComponent;

	@PreAuthorize("permitAll")
	@PostMapping("/login")
	public Role loginWithCredentials(@RequestBody AuthCredentials credentials) {
		return authCredentialsServices.loginWithCredentials(credentials);
	}

	@PreAuthorize("hasAuthority('ADMIN') or @accessCheckerComponent.sameUserId(principal, #mail)")
	@GetMapping("/role/{mail}")
	public Role getUserRole(@PathVariable("mail") String mail) {
		return authCredentialsServices.getAuthCredentialsInstance(mail).getRole();
	}

	@PreAuthorize("hasAuthority('ADMIN')")
	@GetMapping("/")
	public Set<AuthCredentials> getAuthCredentials() {
		return authCredentialsServices.getAuthCredentials();
	}

	@PreAuthorize("permitAll")
	@PostMapping("/donor")
	public boolean addDonorCredentials(@RequestBody UserAndDonor userAndDonor) {
		userAndDonor.donor.setLeftDonationsInYear(userAndDonor.donor.getCategory().getDonationPerYear());
		userAndDonor.donor.setCanDonate(true);
		donorServices.addDonor(userAndDonor.donor);
		return authCredentialsServices.addCredentials(userAndDonor.authCredentials);

	}

	@PreAuthorize("hasAuthority('ADMIN')")
	@PostMapping("/office")
	public boolean addOfficeCredentials(@RequestBody UserAndOffice userAndOffice) {
		officeServices.addOffice(userAndOffice.office);
		return authCredentialsServices.addCredentials(userAndOffice.authCredentials);
	}

	@PreAuthorize("hasAuthority('ADMIN')")
	@PutMapping("/")
	public boolean updateCredentials(@RequestBody AuthCredentials authCredentials) {
		return authCredentialsServices.updateCredentials(authCredentials);
	}

	@PreAuthorize("hasAuthority('ADMIN')")
	@DeleteMapping("/{mail}")
	public boolean removeCredentials(@PathVariable("mail") String mail) {
		return authCredentialsServices.removeCredentials(mail);
	}

	@Setter
	@Getter
	@NoArgsConstructor
	@AllArgsConstructor
	static class UserAndDonor {
		private Donor donor;
		private AuthCredentials authCredentials;
	}

	@Setter
	@Getter
	@NoArgsConstructor
	@AllArgsConstructor
	static class UserAndOffice {
		private Office office;
		private AuthCredentials authCredentials;
	}
}
