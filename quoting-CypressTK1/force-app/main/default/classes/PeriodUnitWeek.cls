/**
 *  Provus Services Quoting
 *  WeekPeriod
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class PeriodUnitWeek extends PeriodUnitBase implements IPeriodUnit {
	public PeriodUnitWeek(Decimal weekPeriods, PeriodUnits periodUnits) {
		super(weekPeriods, periodUnits);
		this.timePeriod = TimePeriodDay.NAME_PLURAL;
	}

	public IPeriodUnit toPeriodUnit(String timePeriod) {
		IPeriodUnit newPeriodUnit;
		Decimal newAmount;
		if (timePeriod.contains(TimePeriodDay.NAME)) {
			newAmount = this.amount * periodUnits.dayPeriodsInAWeek;
			newPeriodUnit = new PeriodUnitWeek(newAmount, this.periodUnits);
		} else if (timePeriod.contains(TimePeriodWeek.NAME)) {
			newPeriodUnit = this;
		} else if (timePeriod.contains(TimePeriodMonth.NAME)) {
			newAmount = this.amount / this.periodUnits.weekPeriodsInAMonth;
			newPeriodUnit = new PeriodUnitMonth(newAmount, this.periodUnits);
		} else if (timePeriod.contains(TimePeriodQuarter.NAME)) {
			newAmount = this.amount / this.periodUnits.weekPeriodsInAQuarter;
			newPeriodUnit = new PeriodUnitQuarter(newAmount, this.periodUnits);
		} else if (timePeriod.contains(TimePeriodYear.NAME)) {
			newAmount = this.amount / (this.periodUnits.weekPeriodsInAMonth * 12);
			newPeriodUnit = new PeriodUnitYear(newAmount, this.periodUnits);
		}

		return newPeriodUnit;
	}

	public Decimal getAmount() {
		return this.amount;
	}
}
