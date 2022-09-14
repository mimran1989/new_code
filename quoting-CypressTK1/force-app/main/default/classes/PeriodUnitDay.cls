/**
 *  Provus Services Quoting
 *  PeriodUnit
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class PeriodUnitDay extends PeriodUnitBase implements IPeriodUnit {
	public PeriodUnitDay(Decimal dayPeriods, PeriodUnits periodUnits) {
		super(dayPeriods, periodUnits);
		this.timePeriod = TimePeriodDay.NAME_PLURAL;
	}

	public IPeriodUnit toPeriodUnit(String timePeriod) {
		IPeriodUnit newPeriodUnit;
		Decimal newAmount;

		if (timePeriod.contains(TimePeriodDay.NAME)) {
			newPeriodUnit = this;
		} else if (timePeriod.contains(TimePeriodWeek.NAME)) {
			newAmount = this.amount / periodUnits.dayPeriodsInAWeek;
			newPeriodUnit = new PeriodUnitWeek(newAmount, this.periodUnits);
		} else if (timePeriod.contains(TimePeriodMonth.NAME)) {
			newAmount = this.amount / this.periodUnits.dayPeriodsInAMonth;
			newPeriodUnit = new PeriodUnitMonth(newAmount, this.periodUnits);
		} else if (timePeriod.contains(TimePeriodQuarter.NAME)) {
			newAmount = this.amount / this.periodUnits.dayPeriodsInAQuarter;
			newPeriodUnit = new PeriodUnitQuarter(newAmount, this.periodUnits);
		} else if (timePeriod.contains(TimePeriodYear.NAME)) {
			newAmount = this.amount / (this.periodUnits.dayPeriodsInAQuarter * 4);
			newPeriodUnit = new PeriodUnitYear(newAmount, this.periodUnits);
		}

		return newPeriodUnit;
	}

	public Decimal getAmount() {
		return this.amount;
	}
}
