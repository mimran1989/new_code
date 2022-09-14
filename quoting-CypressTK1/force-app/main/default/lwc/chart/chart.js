/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { api, LightningElement } from 'lwc';
import chartjs from '@salesforce/resourceUrl/ChartJs';
import { loadScript } from 'lightning/platformResourceLoader';

export default class Chart extends LightningElement {
	@api labels;
	@api inputData;
	@api type = 'bar';
	@api chartLabel;

	config;
	isInitialized = false;

	// May need to dynamically generate colors depending on how many locations are supported.
	// Otherwise, we need to add more colors based on the color palette we would like to use.
	backgroundColor = [
		'rgba(255, 99, 132, 0.2)',
		'rgba(54, 162, 235, 0.2)',
		'rgba(255, 206, 86, 0.2)',
		'rgba(75, 192, 192, 0.2)',
		'rgba(153, 102, 255, 0.2)',
		'rgba(255, 159, 64, 0.2)',
	];

	borderColor = [
		'rgba(255, 99, 132, 1)',
		'rgba(54, 162, 235, 1)',
		'rgba(255, 206, 86, 1)',
		'rgba(75, 192, 192, 1)',
		'rgba(153, 102, 255, 1)',
		'rgba(255, 159, 64, 1)',
	];

	connectedCallback() {
		this.config = {
			type: this.type,
			options: {
				responsive: true,
				legend: {
					position: 'right',
				},
			},
			data: {
				labels: this.labels,
				datasets: [
					{
						label: this.chartLabel,
						data: this.inputData,
						backgroundColor: this.backgroundColor,
						borderColor: this.borderColor,
						borderWidth: 1,
					},
				],
			},
		};
	}

	async renderedCallback() {
		if (this.isInitialized) {
			return;
		}

		this.isInitialized = true;
		await loadScript(this, chartjs);

		// disable Chart.js CSS injection
		window.Chart.platform.disableCSSInjection = true;

		const canvas = document.createElement('canvas');
		this.template.querySelector('.chart-container').appendChild(canvas);
		const ctx = canvas.getContext('2d');
		this.chart = new window.Chart(ctx, this.config);
	}
}
