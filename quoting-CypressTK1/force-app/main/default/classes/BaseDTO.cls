/**
 *  Provus Services Quoting
 *  ManagedDO
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing abstract class BaseDTO {
	public static final String OPERATION_TYPE_INSERT = 'insert';
	public static final String OPERATION_TYPE_UPDATE = 'update';
	public static final String OPERATION_TYPE_DELETE = 'delete';

	public SObject sObj;

	protected BaseDTO() {
	}

	protected BaseDTO(SObject sObj) {
		this.sObj = sObj;
		this.id = sObj.Id;
	}

	@AuraEnabled
	public String operationType { get; set; }

	@AuraEnabled
	public Id id { get; set; }
	@AuraEnabled
	public String name { get; set; }

	@AuraEnabled
	public Boolean isNew {
		get {
			return this.id == null;
		}
	}

	public Boolean isInsert() {
		return operationType == OPERATION_TYPE_INSERT;
	}

	public Boolean isUpdate() {
		return operationType == OPERATION_TYPE_UPDATE;
	}

	public Boolean isDelete() {
		return operationType == OPERATION_TYPE_DELETE;
	}

	public void stripUnqueried() {
		// strip fields that were not queried
		String jsonString = JSON.serialize(sObj);
		Map<String, Object> dataMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
		jsonString = JSON.serialize(dataMap);

		this.sObj = (SObject) JSON.deserialize(jsonString, SObject.class);
	}

	abstract public SObject refreshSo();
}
