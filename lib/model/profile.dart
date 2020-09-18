class Profile{

  String borrowerNumber;
  String firstname;
  String surname;
  String cardNumber;
  String email;
  String contactNumber;

  Profile({
    this.borrowerNumber,
    this.firstname,
    this.surname,
    this.cardNumber,
    this.email,
    this.contactNumber
  });

  String getShorName(){
    return this.firstname.substring(0, 1) + " " + this.surname.substring(0, 1);
  }

}