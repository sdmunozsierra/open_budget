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

class TaxCalculator{
  // TODO make this the method with all  the properties
  // toString(), getCurrentBracket(), calculateGenericTax, etc.
  List bracketRate;
  List bracketThreshold;

  int calculateGenericTax(var householdIncome){
    double totalTax = 0;
    // Iterate to find a Tax bracket
    for (int i = 0; i < bracketThreshold.length; i++){
      // Not in the current bracket
      if (bracketThreshold[i] <= householdIncome){
        // First bracket
        if (i == 0){
          totalTax += bracketThreshold[i] * bracketRate[i];
          continue;
        }
        // Second bracket and beyond
        totalTax += (bracketThreshold[i] - bracketThreshold[i-1]) * bracketRate[i];

        // Found current bracket
      }else{
        // Catch income less than first bracket
        if (i == 0){
          return 0;
        }
        totalTax += (householdIncome - bracketThreshold[i-1]) * bracketRate[i];
        break;
      }
    }
    return totalTax.ceil();
  }
}

// TODO Figure this shit out I feel happy enough to do this shit
class VirginiaStateTax extends TaxCalculator{
  // Single and Couple have the same rates
  List bracketRate = [.02, .03, .05, .575];
  List bracketThreshold = [3000, 5000, 17000, 17000.01];

  VirginiaStateTax(){
    super.bracketRate = this.bracketRate;
    super.bracketThreshold = this.bracketThreshold;
  }
//  VirginiaStateTax(): super(bracketRate)

}

class FederalIncomeTax{
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

