/**
 *  Provus Services Quoting
 *  PeriodUnitYear
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class PeriodUnitYear extends PeriodUnitBase implements IPeriodUnit {
	public PeriodUnitYear(Decimal quarterPeriods, PeriodUnits periodUnits) {
		super(quarterPeriods, periodUnits);
		this.timePeriod = TimePeriodDay.NAME_PLURAL;
	}

	public IPeriodUnit toPeriodUnit(String timePeriod) {
		IPeriodUnit newPeriodUnit;
		Decimal newAmount;

		if (timePeriod.contains(TimePeriodDay.NAME)) {
			newAmount = this.amount * (this.periodUnits.dayPeriodsInAQuarter * 4);
			newPeriodUnit = new PeriodUnitDay(newAmount, this.periodUnits);
		} else if (timePeriod.contains(TimePeriodWeek.NAME)) {
			newAmount = this.amount * (this.periodUnits.weekPeriodsInAMonth * 12);
			newPeriodUnit = new PeriodUnitWeek(newAmount, this.periodUnits);
		} else if (timePeriod.contains(TimePeriodMonth.NAME)) {
			newAmount = this.amount * 12;
			newPeriodUnit = new PeriodUnitMonth(newAmount, this.periodUnits);
		} else if (timePeriod.contains(TimePeriodQuarter.NAME)) {
			newAmount = this.amount * 4;
			newPeriodUnit = new PeriodUnitQuarter(newAmount, this.periodUnits);
		} else if (timePeriod.contains(TimePeriodYear.NAME)) {
			newPeriodUnit = this;
		}

		return newPeriodUnit;
	}

	public Decimal getAmount() {
		return this.amount;
	}
}
