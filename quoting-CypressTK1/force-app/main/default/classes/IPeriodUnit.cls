/**
 *  Provus Services Quoting
 *  IPeriodUnit
 *  @2022 Provus Inc. All rights reserved.
 */
public interface IPeriodUnit {
	IPeriodUnit toPeriodUnit(String timePeriod);
	Decimal getAmount();
}
