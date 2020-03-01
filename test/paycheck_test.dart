// Test paycheck class

import 'package:open_budget/model/paycheck.dart';
import 'package:test/test.dart';

void main(){
  test('String.split() splits the string on the delimiter', () {
    var string = 'foo,bar,baz';
    expect(string.split(','), equals(['foo', 'bar', 'baz']));
  });

  test('test paycheck', (){
    var testPaycheck = Paycheck(
        paycheckType: "Pretax",
        name: "test paycheck",
        amount: 2000.0);

    expect(testPaycheck.name, "test paycheck");
  });

  test('Federal Income Tax', (){
    FederalIncomeTax federalIncomeTax = new FederalIncomeTax();

    // Test myFederalIncomeTax with Standard Exception Enabled (default)
    int testFederalIncomeTax = federalIncomeTax.calculateFederalIncomeTax(80000);
    print(federalIncomeTax.toString());
    expect(testFederalIncomeTax, 10662);

    // Test different tax brackets without Standard Exception
    // Bracket 0
    testFederalIncomeTax = federalIncomeTax.calculateFederalIncomeTax(1, circumstanceEx: false);
    print(federalIncomeTax.toString());
    expect(testFederalIncomeTax, 0);

    // Bracket 1
    testFederalIncomeTax = federalIncomeTax.calculateFederalIncomeTax(9875, circumstanceEx: false);
    print("HERE");
    print(federalIncomeTax.toString());
    expect(testFederalIncomeTax, 988);

    // Bracket 2
    testFederalIncomeTax = federalIncomeTax.calculateFederalIncomeTax(45125, circumstanceEx: false);
    print(federalIncomeTax.toString());
    expect(testFederalIncomeTax, 5718);

    // Bracket 3
    testFederalIncomeTax = federalIncomeTax.calculateFederalIncomeTax(85525, circumstanceEx: false);
    print(federalIncomeTax.toString());
    expect(testFederalIncomeTax, 14606);

    // Bracket 4
    testFederalIncomeTax = federalIncomeTax.calculateFederalIncomeTax(163300, circumstanceEx: false);
    print(federalIncomeTax.toString());
    expect(testFederalIncomeTax, 33272);

    // Bracket 5
    testFederalIncomeTax = federalIncomeTax.calculateFederalIncomeTax(207350, circumstanceEx: false);
    print(federalIncomeTax.toString());
    expect(testFederalIncomeTax, 47368);

    // Bracket 6
    testFederalIncomeTax = federalIncomeTax.calculateFederalIncomeTax(518400, circumstanceEx: false);
    print(federalIncomeTax.toString());
    expect(testFederalIncomeTax, 156235);
  });

  test('test income tax', (){
    IncomeTax incomeTax = new IncomeTax();
    incomeTax.calculateStateTaxRate("VA");

    // My bracket 80k
    expect(incomeTax.calculateEffectiveTax(67600), 10775);

    // Others
    expect(incomeTax.calculateEffectiveTax(41049), 4890);
  });

}
