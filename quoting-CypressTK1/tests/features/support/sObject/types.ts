import { Task } from '../task';

export interface SObjectSO {
	id?: string;
	Name?: string;
	[customField: string]: any;
}

export interface IRecordInput { }

export type SObjectDO = {
    apiName: string;
    getRecordCreateDefaults: (isDeployedInPackage: boolean, createParams?: IRecordInput) => SObjectSO;
}

export type SObjectSOCallback = Task<SObjectSO>;
