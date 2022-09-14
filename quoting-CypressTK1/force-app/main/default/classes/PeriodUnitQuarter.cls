/**
 *  Provus Services Quoting
 *  YearPeriod
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class PeriodUnitQuarter extends PeriodUnitBase implements IPeriodUnit {
	public PeriodUnitQuarter(Decimal quarterPeriods, PeriodUnits periodUnits) {
		super(quarterPeriods, periodUnits);
		this.timePeriod = TimePeriodDay.NAME_PLURAL;
	}

	public IPeriodUnit toPeriodUnit(String timePeriod) {
		IPeriodUnit newPeriodUnit;
		Decimal newAmount;

		if (timePeriod.contains(TimePeriodDay.NAME)) {
			newAmount = (this.amount * (this.periodUnits.dayPeriodsInAMonth * 3)).setScale(1);
			newPeriodUnit = new PeriodUnitDay(newAmount, this.periodUnits);
		} else if (timePeriod.contains(TimePeriodWeek.NAME)) {
			newAmount = (this.amount * (this.periodUnits.weekPeriodsInAMonth * 3)).setScale(2);
			newPeriodUnit = new PeriodUnitWeek(newAmount, this.periodUnits);
		} else if (timePeriod.contains(TimePeriodMonth.NAME)) {
			newAmount = this.amount * 3;
			newPeriodUnit = new PeriodUnitMonth(newAmount, this.periodUnits);
		} else if (timePeriod.contains(TimePeriodQuarter.NAME)) {
			newPeriodUnit = this;
		} else if (timePeriod.contains(TimePeriodYear.NAME)) {
			newAmount = this.amount / 4;
			newPeriodUnit = new PeriodUnitYear(newAmount, this.periodUnits);
		}

		return newPeriodUnit;
	}

	public Decimal getAmount() {
		return this.amount;
	}
}
