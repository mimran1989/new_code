/**
 *  Provus Services Quoting
 *  FilterBy
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class FilterBy {
	// filter by a specific field name to a value
	public Map<String, String> valueByFieldName;
	// filter by a specific field name to a list of ids
	public Map<String, Set<Id>> valuesByFieldName;
	// filter by a specific field name to a list of strings
	public Map<String, Set<String>> stringValuesByFieldName;
	// filter by a specific field name to a boolean value
	public Map<String, Boolean> booleanValuesByFieldName;
	// boolean operand for how we combine multiple conditions
	public String boolOperand;
	// cache where clause
	private String whereClause;

	public FilterBy() {
		init();
	}

	public FilterBy(Map<String, String> valueByFieldName) {
		init();
		this.valueByFieldName = valueByFieldName;
	}

	public FilterBy(Map<String, Set<Id>> valuesByFieldName) {
		init();
		this.valuesByFieldName = valuesByFieldName;
	}

	public FilterBy(Map<String, Set<String>> stringValuesByFieldName) {
		init();
		this.stringValuesByFieldName = stringValuesByFieldName;
	}

	public FilterBy(Map<String, Boolean> booleanValuesByFieldName) {
		init();
		this.booleanValuesByFieldName = booleanValuesByFieldName;
	}

	public void addFilterBy(String field, String value) {
		this.valueByFieldName.put(field, value);
	}

	public void addFilterBy(String field, Set<Id> recordIds) {
		this.valuesByFieldName.put(field, recordIds);
	}

	public void addFilterBy(String field, Boolean value) {
		this.booleanValuesByFieldName.put(field, value);
	}

	public void setWhereClause(String criteria) {
		this.whereClause = ' WHERE ' + criteria;
	}

	private void init() {
		this.valueByFieldName = new Map<String, String>();
		this.valuesByFieldName = new Map<String, Set<Id>>();
		this.booleanValuesByFieldName = new Map<String, Boolean>();
		this.whereClause = null;
		this.boolOperand = SOQLConstants.BOOL_OPERATION_AND;
	}

	/**
	 * Generates where clause given a specific field and value pair
	 * @return list of where clause conditions
	 */
	private List<String> getWhereClauseWithValue() {
		List<String> conditions = new List<String>();
		for (String fieldName : this.valueByFieldName.keySet()) {
			String fieldValue = this.valueByFieldName.get(fieldName);
			String safeFieldValue = fieldValue;
			if (safeFieldValue != null) {
				safeFieldValue = String.escapeSingleQuotes(this.valueByFieldName.get(fieldName));
			}

			String condition = fieldName + ' = ';
			if (safeFieldValue != null) {
				condition += '\'' + safeFieldValue + '\'';
			} else {
				condition += 'NULL';
			}

			conditions.add(condition);
		}
		return conditions;
	}

	/**
	 * Generates where clause given a specific field and set pair
	 * @return returns where clause conditions
	 */
	private List<String> getWhereClauseWithIdSet() {
		List<String> conditions = new List<String>();
		for (String fieldName : this.valuesByFieldName.keySet()) {
			List<Id> idsForField = new List<Id>(this.valuesByFieldName.get(fieldName));
			String condition = fieldName + ' IN (\'' + String.join(idsForField, '\', \'') + '\')';
			conditions.add(condition);
		}
		return conditions;
	}

	private List<String> getWhereClauseWithSet() {
		List<String> conditions = new List<String>();
		for (String fieldName : this.stringValuesByFieldName.keySet()) {
			List<String> stringsForField = new List<String>(this.stringValuesByFieldName.get(fieldName));
			String condition = fieldName + ' IN (\'' + String.join(stringsForField, '\', \'') + '\')';
			conditions.add(condition);
		}
		return conditions;
	}

	private List<String> getWhereClauseWithBoolean() {
		List<String> conditions = new List<String>();
		for (String fieldName : this.booleanValuesByFieldName.keySet()) {
			Boolean fieldValue = this.booleanValuesByFieldName.get(fieldName);
			Boolean safeFieldValue = fieldValue;
			String condition = fieldName + ' = ' + safeFieldValue;
			conditions.add(condition);
		}
		return conditions;
	}

	/**
	 * Retrieves where clause without needing to know context of what
	 * type of data is being used for where clause
	 * @return returns where clause string
	 */
	public String getWhereClause() {
		if (this.whereClause == null) {
			List<String> conditions = new List<String>();
			if (this.valueByFieldName != null) {
				conditions.addAll(getWhereClauseWithValue());
			}

			if (this.valuesByFieldName != null) {
				conditions.addAll(getWhereClauseWithIdSet());
			}

			if (this.stringValuesByFieldName != null) {
				conditions.addAll(getWhereClauseWithSet());
			}

			if (this.booleanValuesByFieldName != null) {
				conditions.addAll(getWhereClauseWithBoolean());
			}

			if (!SystemUtility.nullOrEmpty(conditions)) {
				this.whereClause = ' WHERE ' + String.join(conditions, ' ' + this.boolOperand + ' ');
			}
		}
		return this.whereClause;
	}
}
