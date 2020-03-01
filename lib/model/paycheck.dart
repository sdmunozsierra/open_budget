import 'dart:math';

// Paycheck model
class Paycheck{
  String name;
  String paycheckType; // Before Tax or After Tax
  double amount; // raw amount
  Paycheck({this.name, this.paycheckType, this.amount});
}

class PretaxPaycheck extends Paycheck{

}

class FederalIncomeTax{
// Factory class for income tax generation (Not needed yet)
//  // Factory declaration
//  static FederalIncomeTax federalIncomeTaxSingleton;
//  factory FederalIncomeTax(){
//    if (federalIncomeTaxSingleton == null){
//      federalIncomeTaxSingleton =  new FederalIncomeTax();
//    }
//    return federalIncomeTaxSingleton;
//  }

  // 2020 Tax Information
  static List bracketRate = [.10, .12, .22, .24, .32, .35, .37];
  static List bracketThreshold = [9875, 40125, 85525, 163300, 207350, 518400, 518400.01];
  static int standardDeduction = 12400;

  String _currentBracket;
  double totalTax = 0;

  int calculateFederalIncomeTax(var householdIncome, {bool circumstanceEx = true}){
    // Reset the calculations each time
    this.totalTax = 0;

    // Check for circumstance exception
    if (circumstanceEx == true){
      householdIncome -= standardDeduction;
      if (householdIncome <= 0) {
        this._currentBracket = "Federal Income Tax Bracket for $householdIncome is 0";
        return 0;
      }
    }

    // Iterate to find a Tax bracket
    for (int i = 0; i < bracketThreshold.length; i++){
      // Not in the current bracket
      if (bracketThreshold[i] <= householdIncome){
        // First bracket
        if (i == 0){
          this.totalTax += bracketThreshold[i] * bracketRate[i];
          continue;
        }
        // Second bracket and beyond
        this.totalTax += (bracketThreshold[i] - bracketThreshold[i-1]) * bracketRate[i];

      // Found current bracket
      }else{
        // Catch income less than first bracket
        if (i == 0){
          this._currentBracket = "Federal Income Tax Bracket for $householdIncome is 0";
          return 0;
        }
        this.totalTax += (householdIncome - bracketThreshold[i-1]) * bracketRate[i];
        this._currentBracket = "Federal Income Tax Bracket for $householdIncome is ${bracketRate[i]}";
        break;
      }
    }
    return this.totalTax.ceil();
  }

  @override
  String toString() => this._currentBracket;

}

class IncomeTax{
  // These are 2020 brakets
  static var taxBracketRate = [.10, .12, .22, .24, .32, .35, .37];
  static var taxBracketThreshold = [9875, 40125, 85525, 163300, 207350, 518400, 518400.01];
  static var stateTaxRate = {"VA": .765};
  // My Bracket
  static double federalTax;
  static double ficaTax = 7.65; // TODO investigate how to calculate this
  static double stateTax;
  static double localTax = 0.0; // TODO investigate how to calculate this

  // Calculated
  double marginalTax = 0;
  double totalTax = 0;

  // TODO make this recursive please
  double calculateEffectiveTax(double householdIncome){
    var householdIncomeRem = householdIncome;
    if (householdIncome <= 9700){
      print("not here");
      this.totalTax += householdIncome * taxBracketRate[0];
    }

    if (householdIncome > 9700 && householdIncome <= 39475) {
      print("not here");
      this.totalTax += 9700 * taxBracketRate[0];
      this.totalTax += (householdIncome - 9700) * taxBracketRate[1];
    }

    if (householdIncome > 39475 && householdIncome <= 84200) {
      var first = 9700 * taxBracketRate[0];
      print("First bracket: " + first.toString());
      this.totalTax += first;
      print(this.totalTax);

      var second = (39475 - 9700) * taxBracketRate[1];
      print("Second bracket: " + second.toString());
      this.totalTax += second;
      print(this.totalTax);

      var third = (householdIncome - 39475) * taxBracketRate[2];
      print("Third bracket: " + third.toString());
      this.totalTax += third;
      print(this.totalTax);
    }

    if (householdIncome > 84200 && householdIncome <= 160725) {
      print("wtf");
      this.totalTax += 9700 * taxBracketRate[0];
      this.totalTax += 39475 - 9700 * taxBracketRate[1];
      this.totalTax += 84200 - 39475 * taxBracketRate[2];
      this.totalTax += (householdIncome - 84200) * taxBracketRate[3];
    }
    if (householdIncome > 160725 && householdIncome <= 204100) {
      print("not here");
      this.totalTax += 9700 * taxBracketRate[0];
      this.totalTax += 39475 * taxBracketRate[1];
      this.totalTax += 84200 * taxBracketRate[2];
      this.totalTax += 160725 * taxBracketRate[3];
      this.totalTax += (householdIncome - 160725) * taxBracketRate[4];
    }

    if (householdIncome > 204100 && householdIncome <= 510300) {
      print("not here");
      this.totalTax += 9700 * taxBracketRate[0];
      this.totalTax += 39475 * taxBracketRate[1];
      this.totalTax += 84200 * taxBracketRate[2];
      this.totalTax += 160725 * taxBracketRate[3];
      this.totalTax += 204100 * taxBracketRate[4];
      this.totalTax += (householdIncome - 510300) * taxBracketRate[5];
    }
    if (householdIncome >= 510300) {
      this.totalTax += 9700 * taxBracketRate[0];
      this.totalTax += 39475 * taxBracketRate[1];
      this.totalTax += 84200 * taxBracketRate[2];
      this.totalTax += 160725 * taxBracketRate[3];
      this.totalTax += 204100 * taxBracketRate[4];
      this.totalTax += 510300 * taxBracketRate[5];
      this.totalTax += (householdIncome - 510300) * taxBracketRate[5];
    }

    this.marginalTax =  householdIncome / this.totalTax;
    return this.totalTax.ceil().toDouble();
  }

  double calculateStateTaxRate(String state) => stateTaxRate[state];

//  double getIncomeTax(double householdIncome){
//    IncomeTax.federalTax = calculateTaxBracketRate(householdIncome);
//  }

}

