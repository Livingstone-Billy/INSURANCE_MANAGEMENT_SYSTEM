class Policy {
  String policyName;
  double sumAssured;
  int premium;
  String category;
  int tenure;

  Policy(this.policyName, this.sumAssured, this.premium, this.category,
      this.tenure);

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "name": policyName,
      "sumAssured": sumAssured,
      "premium": premium,
      "tenure": tenure,
    };
  }
}
