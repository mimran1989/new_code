/**
 *  Provus Services Quoting
 *  BasePeriodUnit
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing abstract class PeriodUnitBase {
	public Decimal amount;
	public String timePeriod;
	public PeriodUnits periodUnits;

	public PeriodUnitBase(Decimal amount, PeriodUnits periodUnits) {
		this.amount = amount;
		this.periodUnits = periodUnits;
	}
}
