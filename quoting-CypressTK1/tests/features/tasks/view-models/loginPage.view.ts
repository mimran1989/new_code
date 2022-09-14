const loginPage = {
	usernameInput: () => cy.get('#username'),
	passwordInput: () => cy.get('#password'),
	logInButton: () => cy.get('#Login'),
};

export default loginPage;
