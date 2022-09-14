/**
 *  Provus Services Quoting
 *  MonthPeriod
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class PeriodUnitMonth extends PeriodUnitBase implements IPeriodUnit {
	public PeriodUnitMonth(Decimal monthPeriods, PeriodUnits periodUnits) {
		super(monthPeriods, periodUnits);
		this.timePeriod = TimePeriodDay.NAME_PLURAL;
	}

	public IPeriodUnit toPeriodUnit(String timePeriod) {
		IPeriodUnit newPeriodUnit;
		Decimal newAmount;
		if (timePeriod.contains(TimePeriodDay.NAME)) {
			newAmount = this.amount * this.periodUnits.dayPeriodsInAMonth;
			newPeriodUnit = new PeriodUnitWeek(newAmount, this.periodUnits);
		} else if (timePeriod.contains(TimePeriodWeek.NAME)) {
			newAmount = this.amount * this.periodUnits.weekPeriodsInAMonth;
			newPeriodUnit = new PeriodUnitWeek(newAmount, this.periodUnits);
		} else if (timePeriod.contains(TimePeriodMonth.NAME)) {
			newPeriodUnit = this;
		} else if (timePeriod.contains(TimePeriodQuarter.NAME)) {
			newAmount = this.amount / 3;
			newPeriodUnit = new PeriodUnitQuarter(newAmount, this.periodUnits);
		} else if (timePeriod.contains(TimePeriodYear.NAME)) {
			newAmount = this.amount / 12;
			newPeriodUnit = new PeriodUnitYear(newAmount, this.periodUnits);
		}

		return newPeriodUnit;
	}

	public Decimal getAmount() {
		return this.amount;
	}
}
