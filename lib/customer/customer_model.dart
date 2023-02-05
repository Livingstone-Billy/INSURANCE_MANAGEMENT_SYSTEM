class Customer{
  String idNo;
  String firstname;
  String lastname;
  String imgUrl;
  String phoneNo;
  String email;

  Customer(this.idNo, this.firstname, this.lastname, this.imgUrl, this.phoneNo, this.email);

  Map<String, dynamic> toMap(){
    return{
      "idNo": idNo,
      "firstname": firstname,
      "lastname": lastname,
      "phoneNo": phoneNo,
      "imgUrl": imgUrl,
      "email": email
    };
  }

  static Customer fromMap(Map<String, dynamic> map){
    return Customer(map['idNo'], map['firstname'], map['lastname'], map['imgUrl'], map['phoneNo'], map['email']);
  }
}